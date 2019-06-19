% Filenames are saved as
    % BASELINE: numbera, or 
    % POST: numberb 
% e.g Participant 7 is saved as 7a and 7b, for baseline and post files,
% respectively

%% Participants
PARTICIPANT_LIST = 1:20;

%% Load/Save Parameters
DIR     = '/Volumes/MacHD/CET'; % Directory where data is stored
LETTER  = ['a';'b']; % a refers to baseline data, b to post data
VAR     = 'data';

%% Load Data + Line Noise Removal/Filtering/Downsampling
INFOLD  = '0.raw';      % folder where input data is stored
OUTFOLD = '1.preproc';  % folder where output data is saved

for a = 1:length(PARTICIPANT_LIST)
    for l = 1:length(LETTER)
        % Read in TMSi Polybench data and convert to a Fieldtrip format
        filename    = fullfile(DIR,INFOLD,strcat(num2str(PARTICIPANT_LIST(a)),LETTER(l),'.Poly5'));
        raw         = sn_CETreadTMSiEEG(filename);
        data        = sn_CETpreprocess(raw);

        % Save data to a OUTFOLD folder
        fullpath1 = fullfile(DIR,OUTFOLD,strcat(VAR,num2str(PARTICIPANT_LIST(a)),LETTER(l)));
        save(fullpath1,'data');
    end
end

%% Create events
INFOLD  = '1.preproc';
OUTFOLD = '2.events';

for a = 1:length(PARTICIPANT_LIST)
    for l = 1:length(LETTER)
        filename    = fullfile(DIR,INFOLD,strcat(VAR,num2str(PARTICIPANT_LIST(a)),LETTER(l)));
        load(filename)
        
        % Uses triggers to timestamp resting state and task events
        events = sn_CETevents(data);

        % Save data to a OUTFOLD folder
        fullpath1 = fullfile(DIR,OUTFOLD,strcat(VAR,num2str(PARTICIPANT_LIST(a)),LETTER(l)));
        save(fullpath1,'events');
    end
end

%% Create trials 
INFOLD  = '2.events';
OUTFOLD = '3.trials';
VAR     = 'data';

for a = 1:length(PARTICIPANT_LIST)
    for l = 1:length(LETTER)
        filename    = fullfile(DIR,INFOLD,strcat(VAR,num2str(PARTICIPANT_LIST(a)),LETTER(l)));
        load(filename);
        
        % Create trials/epochs
        trials = sn_CETtrials(events);

        % Save data to a OUTFOLD folder
        fullpath1 = fullfile(DIR,OUTFOLD,strcat(VAR,num2str(PARTICIPANT_LIST(a)),LETTER(l)));
        save(fullpath1,'trials');
    end
end

%% Automated rejection of trials
INFOLD  = '3.trials';
OUTFOLD = '4.1.visrej';
VAR     = 'data';

for a = 1:length(PARTICIPANT_LIST)
    for l = 1:length(LETTER)
        
        filename = fullfile(DIR,INFOLD,strcat(VAR,num2str(PARTICIPANT_LIST(a)),LETTER(l)));
        load(filename);
        
        % Reject noisy trials/epochs
        autorej = sn_CETtrialrejection(trials);

        fullpath1 = fullfile(DIR,OUTFOLD,strcat(VAR,num2str(PARTICIPANT_LIST(a)),LETTER(l)));
        save(fullpath1,'autorej');
    end
end

%% Visual rejection of trials
INFOLD  = '4.1.autorej';
OUTFOLD = '4.2.visrej';
VAR     = 'data';

PARTICIPANT = 1; % Select participant to check trials
TIME        = 1; % Select time (BASELINE|POST) to check trials
BLOCK       = 4; % Select block to check trials
% 1=EO EEG; 2=EC EEG; 3=Practice Nback; 4=NBack; 5=Practice+RealNback

filename    = fullfile(DIR,INFOLD,strcat(VAR,...
    num2str(PARTICIPANT_LIST(PARTICIPANT)),LETTER(TIME)));
load(filename);

cfg         = [];
cfg.method  = 'summary';
visrej      = ft_rejectvisual(cfg,autorej(BLOCK)); 
 
fullpath1 = fullfile(DIR,OUTFOLD,strcat(VAR,...
    num2str(PARTICIPANT_LIST(PARTICIPANT)),LETTER(TIME)));
save(fullpath1,'visrej');
        
%% ICA
INFOLD  = '4.2.visrej';
OUTFOLD = '5.ICs';
VAR     = 'data';

PARTICIPANT = 1; % Select participant to check trials
TIME        = 1; % Select time (BASELINE|POST) to check trials

filename    = fullfile(DIR,INFOLD,strcat(VAR,...
    num2str(PARTICIPANT_LIST(PARTICIPANT)),LETTER(TIME)));
load(filename);

% Creates a concatenated file for ICA
ICA_data    = sn_CETICAdata(visrej);

% Run ICA
cfg         = [];
cfg.method  = 'runica';
cfg.channel = {'all','-Marker'};
comps       = ft_componentanalysis(cfg,ICA_data);

% IC Rejection
% Plot, inspect, and identify ICs for removal
% At the prompt, list the components to reject
% Example: [3,6,7,8,9];

comps       = sn_CETICAcheck(comps);

fullpath1 = fullfile(DIR,OUTFOLD,strcat('comps',...
    num2str(PARTICIPANT_LIST(PARTICIPANT)),LETTER(TIME)));
save(fullpath1,'comps');

%% Create layout for final structure
INFOLD1 = '4.2.visrej';
INFOLD2 = '2.events';
OUTFOLD = '6.struct';
VAR     = 'data';

for a = 1:length(PARTICIPANT_LIST)
    for l = 1:length(LETTER)
        
        filename1 = fullfile(DIR,INFOLD1,strcat(VAR,num2str(PARTICIPANT_LIST(a)),LETTER(l)));
        load(filename1);

        filename2 = fullfile(DIR,INFOLD2,strcat(VAR,num2str(PARTICIPANT_LIST(a)),LETTER(l)));
        load(filename2);
        
        struct = sn_CETblocks(events);
        
        A = find(strcmp({visrej.block},'Practice NBACK'));
        B = find(strcmp({visrej.block},'NBACK'));

        struct(3) = visrej(A);
        struct(4) = visrej(B);

        fullpath1 = fullfile(DIR,OUTFOLD,strcat(VAR,num2str(PARTICIPANT_LIST(a)),LETTER(l)));
        save(fullpath1,'struct');
    end
end

%% Reject ICs
INFOLD1 = '6.struct';
INFOLD2 = '5.ICs';
OUTFOLD = '7.postICA';
VAR1    = 'data';
VAR2    = 'comps';

for a = 1:length(PARTICIPANT_LIST)
    for l = 1:length(LETTER)
        
        filename1 = fullfile(DIR,INFOLD1,strcat(VAR1,num2str(PARTICIPANT_LIST(a)),LETTER(l)));
        load(filename1);

        filename2 = fullfile(DIR,INFOLD2,strcat(VAR2,num2str(PARTICIPANT_LIST(a)),LETTER(l)));
        load(filename2);

        for m = 1:length(struct)
            % Create component time series using original data
            cfg             = [];
            cfg.unmixing    = comps.unmixing; % NxN unmixing matrix
            cfg.topolabel   = comps.topolabel; % Nx1 cell-array with the channel labels
            comp_orig       = ft_componentanalysis(cfg,struct(m));

            % Original data reconstructed excluding rejected components
            cfg             = [];
            cfg.component   = comps.rejected;
            postica(m)      = ft_rejectcomponent(cfg,comp_orig,struct(m));
        end

        fullpath1 = fullfile(DIR,OUTFOLD,strcat(VAR,num2str(PARTICIPANT_LIST(a)),LETTER(l)));
        save(fullpath1,'postica');
    end
end

%% Re-referencing to average
INFOLD  = '7.postICA';
OUTFOLD = '8.reref';
VAR     = 'data';

for a = 1:length(PARTICIPANT_LIST)
    for l = 1:length(LETTER)
        
        filename = fullfile(DIR,INFOLD,strcat(VAR,num2str(PARTICIPANT_LIST(a)),LETTER(l)));
        load(filename);
        
        cfg             = [];
        cfg.channel     = 'all';
        cfg.refchannel  = 'all';
        cfg.reref       = 'yes';
        cfg.refmethod   = 'avg';
        cfg.trials      = 'all';

        for n = 1:length(postica)
            temp(n)     = ft_preprocessing(cfg,postica(n));
        end

        reref = temp;

        for o = 1:length(postica)
            reref(o).event = postica(o).event;
            reref(o).block = postica(o).block;
        end

        % Create All N-Back trials, i.e. practice and real tasks combined
        A = find(strcmp({reref.block},'Practice NBACK'));
        B = find(strcmp({reref.block},'NBACK'));

        i               = length(reref);
        reref(i + 1)    = reref(i);

        reref(i + 1).block      = 'All NBACK';
        reref(i + 1).sampleinfo = vertcat(reref(A).sampleinfo, reref(B).sampleinfo);
        reref(i + 1).trial      = horzcat(reref(A).trial, reref(B).trial);
        reref(i + 1).time       = horzcat(reref(A).time, reref(B).time);
        reref(i + 1).event      = horzcat(reref(A).event, reref(B).event);

        fullpath1 = fullfile(DIR,OUTFOLD,strcat(VAR,num2str(PARTICIPANT_LIST(a)),LETTER(l)));
        save(fullpath1,'reref');
    end
end

%% ERP Calculation
INFOLD  = '8.reref';
OUTFOLD = '9.ERP';
VAR     = 'data';

for a = 1:length(PARTICIPANT_LIST)
    for l = 1:length(LETTER)
        
        filename = fullfile(DIR,INFOLD,strcat(VAR,num2str(PARTICIPANT_LIST(a)),LETTER(l)));
        load(filename);
        
        ERP_dat = sn_CETERPcalc(reref);
        
        fullpath1 = fullfile(DIR,OUTFOLD,strcat(VAR,num2str(PARTICIPANT_LIST(a)),LETTER(l)));
        save(fullpath1,'ERP_dat');
    end
end

%% TFR Calculation
INFOLD  = '8.reref';
OUTFOLD = '10.TFR';
VAR     = 'data';

for a = 1:length(PARTICIPANT_LIST)
    for l = 1:length(LETTER)
        
        filename = fullfile(DIR,INFOLD,strcat(VAR,num2str(PARTICIPANT_LIST(a)),LETTER(l)));
        load(filename);
        
        TFR_dat = sn_CETTFRcalc(reref);
        
        fullpath1 = fullfile(DIR,OUTFOLD,strcat(VAR,num2str(PARTICIPANT_LIST(a)),LETTER(l)));
        save(fullpath1,'TFR_dat');
    end
end

%% PSD Calculation
INFOLD  = '8.reref';
OUTFOLD = '11.PSD';
VAR     = 'data';

for a = 1:length(PARTICIPANT_LIST)
    for l = 1:length(LETTER)
        
        filename = fullfile(DIR,INFOLD,strcat(VAR,num2str(PARTICIPANT_LIST(a)),LETTER(l)));
        load(filename);
        
        PSD_dat = sn_CETPSDcalc(reref);
        
        fullpath1 = fullfile(DIR,OUTFOLD,strcat(VAR,num2str(PARTICIPANT_LIST(a)),LETTER(l)));
        save(fullpath1,'PSD_dat');
    end
end

%% Compile participant data for analyses

sn_CETdatacollection

%% Statistical analyses

sn_CETstatistics

%% Generate manuscript figures

sn_CETfig1
sn_CETfig2
sn_CETfig3
sn_CETfig4
sn_CETfig5

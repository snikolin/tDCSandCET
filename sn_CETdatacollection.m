
%% Parameters
PARTICIPANT_LIST = 1:20;
DIR         = '/Volumes/MacHD/CET';
CMAP        = cbrewer('qual','Dark2', 3, 'cubic'); % Baseline | Diff | Post
BOOTSTRAPS  = 1000;
FORMAT      = 'all'; 
LETTER      = ['a';'b'];
VAR         = 'data';
FS          = 1024;
FONTSIZE    = 8; % for all axes
TITLESIZE   = 9;

%% Resting-State PSD 
INFOLD  = '11.PSD';
VAR     = 'data';

% Generate data structure
for a = 1:length(PARTICIPANT_LIST)
    for l = 1:length(LETTER)
        for rs = 1:2
            
            % Load data
            filename = fullfile(DIR,INFOLD,strcat(VAR,num2str(PARTICIPANT_LIST(a)),LETTER(l)));
            load(filename);

            % Generate analysis structure 
            temp        = [];
            temp.avg    = log(PSD_dat(rs).PSD);
            temp.var    = ones(size(PSD_dat(rs).PSD));
            temp.time   = PSD_dat(rs).freq;
            temp.label  = PSD_dat(rs).label;
            
            % preCET_PSD{1,:} is Eyes Open EEG data
            % preCET_PSD{2,:} is Eyes Closed EEG data
            if l == 1
                preCET_PSD{rs,a} = temp;
            elseif l == 2
                pstCET_PSD{rs,a} = temp;
            end
        end
    end
end

%% Data for Statistics - PSD
% Frontal Alpha Asymmetry - (F4 - F3)./sum(F4 + F3) 
% or Current Source Density (CSD). Eyes Closed
F3          = find(strcmp(PSD.EC.label,'F3'));
F4          = find(strcmp(PSD.EC.label,'F4'));
ALPHA_FREQ  = [8 13];

alpha = PSD.EC.freq >= ALPHA_FREQ(1) & PSD.EC.freq <= ALPHA_FREQ(2);

tempF3pre = mean(PSD.EC.pre(:,F3,alpha),[2,3]);
tempF4pre = mean(PSD.EC.pre(:,F4,alpha),[2,3]);
tempFAApre= (tempF4pre - tempF3pre)./(tempF4pre + tempF3pre);

tempF3pst = mean(PSD.EC.pst(:,F3,alpha),[2,3]);
tempF4pst = mean(PSD.EC.pst(:,F4,alpha),[2,3]);
tempFAApst= (tempF4pst - tempF3pst)./(tempF4pst + tempF3pst);

% Frontal Theta (Fp1,Fp2,AFz,F3,Fz,F4): see Arns manuscript
CHANNELS    = {'Fp1','Fp2','Afz','F3','Fz','F4'};
THETA_FREQ  = [4 8];

chans = ismember(PSD.EC.label,CHANNELS);
theta = PSD.EC.freq >= THETA_FREQ(1) & PSD.EC.freq <= THETA_FREQ(2);

tempFTpre = mean(PSD.EC.pre(:,chans,theta),[2,3]);
tempFTpst = mean(PSD.EC.pst(:,chans,theta),[2,3]);

for a = 1:length(PARTICIPANT_LIST)
    EEGdata(a).FAAPSD_pre = tempFAApre(a);
    EEGdata(a).FAAPSD_pst = tempFAApst(a);
    EEGdata(a).ThetaPSD_pre = tempFTpre(a);
    EEGdata(a).ThetaPSD_pst = tempFTpst(a);
end 

%% Working Memory EEG ERPs
INFOLD  = '9.ERP';
VAR     = 'data';

% Generate data structure
for a = 1:length(PARTICIPANT_LIST)
    for l = 1:length(LETTER)
        
        % Load data
        filename = fullfile(DIR,INFOLD,strcat(VAR,num2str(PARTICIPANT_LIST(a)),LETTER(l)));
        load(filename);
        
        % Generate analysis structure 
        i = strcmp({ERP_dat.all.stimtype},FORMAT);
        
        if l == 1
            preCET_ERP{a} = ERP_dat.post(i); 
        elseif l == 2
            pstCET_ERP{a} = ERP_dat.post(i);
        end
    end
end

cfg         = [];
cfg.method  = 'across';
basegrndavg = ft_timelockgrandaverage(cfg,preCET_ERP{:});
endgrndavg  = ft_timelockgrandaverage(cfg,pstCET_ERP{:});

%% Data for statistics - ERP
INTERVAL = 0.02;  
P2       = 0.1455; 
P3       = 0.3730; 
CHANNEL  = 'Fz';

TIME_WINDOW = [-0.2 0.6];
erp_channel = strcmp(preCET_ERP{1}.label,CHANNEL);
erp_P2index = find(preCET_ERP{1}.time >= (P2-INTERVAL) & preCET_ERP{1}.time <= (P2+INTERVAL));
erp_P3index = find(preCET_ERP{1}.time >= (P3-INTERVAL) & preCET_ERP{1}.time <= (P3+INTERVAL));

for a = 1:length(PARTICIPANT_LIST)
    EEGdata(a).P2_pre  = mean(preCET_ERP{a}.avg(erp_channel,erp_P2index));
    EEGdata(a).P2_pst  = mean(pstCET_ERP{a}.avg(erp_channel,erp_P2index));
    EEGdata(a).P3_pre  = mean(preCET_ERP{a}.avg(erp_channel,erp_P3index));
    EEGdata(a).P3_pst  = mean(pstCET_ERP{a}.avg(erp_channel,erp_P3index));
end 

%% Working Memory TFRs
INFOLD      = '8.reref';
OUTFOLD     = '10.TFR';
S           = 0.6;

% Process the data
for a = 1:length(PARTICIPANT_LIST)
    for l = 1:length(LETTER)
        
        % Load
        filename = fullfile(DIR_CET,OUTFOLD,strcat(VAR,num2str(PARTICIPANT_LIST(a)),LETTER(l)));
        load(filename);

        % Temporary var: Channel | Time | Freq | Participants
        if l == 1
            temp_pre(:,:,:,a) = TFR_dat.powspctrm;
        elseif l == 2
            temp_pst(:,:,:,a) = TFR_dat.powspctrm;
        end
    end
end

% TFR data - all individuals
TFR_comb.pre            = TFR_dat;
TFR_comb.pst            = TFR_dat;

TFR_comb.pre.powspctrm  = temp_pre;
TFR_comb.pst.powspctrm  = temp_pst;

% TFR data - grandaverage
TFR_avg.pre             = TFR_dat;
TFR_avg.pre.powspctrm   = mean(temp_pre,4);
TFR_avg.pre.tanh        = sn_tanhmean(temp_pre,4,S);

TFR_avg.pst             = TFR_dat;
TFR_avg.pst.powspctrm   = mean(temp_pst,4);
TFR_avg.pst.tanh        = sn_tanhmean(temp_pst,4,S);

% Differences
cfg             = [];
cfg.operation   = 'subtract';
cfg.parameter   = 'powspctrm';

% Diff all data
TFR_comb.diff   = ft_math(cfg,TFR_comb.pst,TFR_comb.pre);

% Diff avg data
TFR_avg.diff    = ft_math(cfg,TFR_avg.pst,TFR_avg.pre);

% Set dimension order
TFR_comb.pre.dimord     = 'chan_freq_time_rpt';
TFR_comb.pst.dimord     = 'chan_freq_time_rpt';
TFR_comb.diff.dimord    = 'chan_freq_time_rpt';

%% Data for statistics - TFR
% Need to collect alpha and thetavalues
ALPHA_COI = {'P2','P3'};
ALPHA_FOI = [8 12];
ALPHA_TOI = [0.2 0.7];
THETA_COI = 'Fz';
THETA_FOI = [4 8];
THETA_TOI = [0 0.5];
CHANNEL   = 'Fz';

TIME_WINDOW = [-0.2 0.6];
tfr_ERD_coi = strcmp(TFR_comb.pre.label,CHANNEL);
tfr_ERD_foi = find(TFR_comb.pre.freq >= ALPHA_FOI(1) & TFR_comb.pre.freq <= ALPHA_FOI(2));
tfr_ERD_toi = find(TFR_comb.pre.time >= ALPHA_TOI(1) & TFR_comb.pre.time <= ALPHA_TOI(2));
AERDpre = squeeze(mean(TFR_comb.pre.powspctrm(tfr_ERD_coi,tfr_ERD_foi,tfr_ERD_toi,:),[2,3]));
AERDpst = squeeze(mean(TFR_comb.pst.powspctrm(tfr_ERD_coi,tfr_ERD_foi,tfr_ERD_toi,:),[2,3]));

tfr_ERS_coi = strcmp(TFR_comb.pre.label,CHANNEL);
tfr_ERS_foi = find(TFR_comb.pre.freq >= THETA_FOI(1) & TFR_comb.pre.freq <= THETA_FOI(2));
tfr_ERS_toi = find(TFR_comb.pre.time >= THETA_TOI(1) & TFR_comb.pre.time <= THETA_TOI(2));
TERSpre = squeeze(mean(TFR_comb.pre.powspctrm(tfr_ERS_coi,tfr_ERS_foi,tfr_ERS_toi,:),[2,3]));
TERSpst = squeeze(mean(TFR_comb.pst.powspctrm(tfr_ERS_coi,tfr_ERS_foi,tfr_ERS_toi,:),[2,3]));

for a = 1:length(PARTICIPANT_LIST)
    if EEGdata(a).ID == PARTICIPANT_LIST(a)
        EEGdata(a).AlphaERD_pre = AERDpre(a);
        EEGdata(a).AlphaERD_pst = AERDpst(a);
        EEGdata(a).ThetaERS_pre = TERSpre(a);
        EEGdata(a).ThetaERS_pst = TERSpst(a);
    end
end 

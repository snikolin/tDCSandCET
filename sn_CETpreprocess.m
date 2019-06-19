function data = sn_CETpreprocess(data)

LINE_NOISE  = 50;
MARKER      = find(strcmp(data.label,'Marker'));
ECG         = find(strcmp(data.label,'ECG'));
DATA_CHS    = setdiff(1:length(data.label),[MARKER, ECG]);

% Remove line noise
[b,a] = butter(2, ([LINE_NOISE*0.99 LINE_NOISE*1.01])/(data.fsample * 0.5),'stop');
data.trial{1}(DATA_CHS,:) = filtfilt(b,a,data.trial{1}(DATA_CHS,:)')';

% Filtering
cfg = [];
cfg.bpfilter    = 'yes';
cfg.bpfiltord   = 2;
cfg.demean      = 'yes';
cfg.channel     = {'all', '-ECG', '-Marker'};
cfg.bpfreq      = [0.5 70];
marker_ch       = data.trial{1}(MARKER,:);   
data            = ft_preprocessing(cfg,data);

c                  = DATA_CHS(end) + 1;
data.trial{1}(c,:) = marker_ch;
data.label(c,1)    = {'Marker'};

% Downsample to target sampling rate
TARGET_FS   = 1024;
FS          = data.fsample;
INCREMENT   = FS/TARGET_FS;

data.trial{1}   = data.trial{1}(:,1:INCREMENT:end);
data.time{1}    = data.time{1}(1,1:INCREMENT:end);
data.fsample    = TARGET_FS;

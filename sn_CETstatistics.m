% sn_CETstatistics
% Non-Parametric Cluster-Based Permutation Testing
%% PARAMETERS
PARTICIPANT_LIST = setdiff(301:328,S3_REJ);
PERMUTATIONS    = 3000;
ALPHA           = 0.05;
TIMEOFINTEREST  = [0 1];
MIN_NEIGHB      = 1;
TAIL            = 0;

load('easycapM1'); 
load('easycapM1_neighb.mat');

%% PSD Statistics
cfg                     = [];
cfg.layout              = lay;
cfg.neighbours          = neighbours;
cfg.channel             = 'all'; 
cfg.parameter           = 'avg';
cfg.method              = 'montecarlo';
cfg.statistic           = 'depsamplesT'; % or 'ft_statfun_depsamplesT'
cfg.correctm            = 'cluster';
cfg.clusterstatistic    = 'maxsum';
cfg.clusterthreshold    = 'parametric'; % 'parametric' 'nonparametric_individual' 'nonparametric_common'
cfg.minnbchan           = MIN_NEIGHB;
cfg.tail                = TAIL;
cfg.clustertail         = TAIL;
cfg.alpha               = ALPHA;
cfg.clusteralpha        = ALPHA;
cfg.numrandomization    = PERMUTATIONS;
cfg.latency             = [1 70];
cfg.uvar                = 1;
cfg.ivar                = 2;

design(1,:) = [1:length(PARTICIPANT_LIST) 1:length(PARTICIPANT_LIST)];
design(2,:) = [ones(1,length(PARTICIPANT_LIST)) 2*ones(1,length(PARTICIPANT_LIST))];
cfg.design  = design;

[stats_PSD_EO] = ft_timelockstatistics(cfg, preCET_PSD{1,:}, pstCET_PSD{1,:});
[stats_PSD_EC] = ft_timelockstatistics(cfg, preCET_PSD{2,:}, pstCET_PSD{2,:});

%% ERP Statistics
cfg                     = [];
cfg.layout              = lay;
cfg.neighbours          = neighbours;
cfg.channel             = 'all'; 
cfg.parameter           = 'avg';
cfg.method              = 'montecarlo';
cfg.statistic           = 'depsamplesT'; % or 'ft_statfun_depsamplesT'
cfg.correctm            = 'cluster';
cfg.clusterstatistic    = 'maxsum';
cfg.clusterthreshold    = 'nonparametric_common'; % 'parametric' 'nonparametric_individual' 'nonparametric_common'
cfg.minnbchan           = MIN_NEIGHB;
cfg.tail                = TAIL;
cfg.clustertail         = TAIL;
cfg.alpha               = ALPHA;
cfg.clusteralpha        = ALPHA;
cfg.numrandomization    = PERMUTATIONS;
cfg.latency             = TIMEOFINTEREST;
cfg.uvar                = 1;
cfg.ivar                = 2;

design(1,:) = [1:length(PARTICIPANT_LIST) 1:length(PARTICIPANT_LIST)];
design(2,:) = [ones(1,length(PARTICIPANT_LIST)) 2*ones(1,length(PARTICIPANT_LIST))];
cfg.design  = design;

[stats_ERP] = ft_timelockstatistics(cfg, preCET_ERP{:}, pstCET_ERP{:});

%% TFR Statistics
cfg                     = [];
cfg.layout              = lay;
cfg.neighbours          = neighbours;
cfg.channel             = 'all'; 
cfg.parameter           = 'powspctrm';
cfg.method              = 'montecarlo';
cfg.statistic           = 'depsamplesT'; % or 'ft_statfun_depsamplesT'
cfg.correctm            = 'cluster';
cfg.clusterstatistic    = 'maxsum';
cfg.clusterthreshold    = 'nonparametric_individual'; % 'parametric' 'nonparametric_individual' 'nonparametric_common'
cfg.minnbchan           = MIN_NEIGHB;
cfg.tail                = TAIL;
cfg.clustertail         = TAIL;
cfg.alpha               = ALPHA;
cfg.clusteralpha        = ALPHA;
cfg.numrandomization    = PERMUTATIONS;
cfg.latency             = TIMEOFINTEREST;
cfg.uvar                = 1;
cfg.ivar                = 2;

cfg.design(1,:)         = [1:size(TFR_comb.pre.powspctrm,4) 1:size(TFR_comb.pst.powspctrm,4)];
cfg.design(2,:)         = [ones(1,size(TFR_comb.pre.powspctrm,4)),...
    2*ones(1,size(TFR_comb.pst.powspctrm,4))];

[stats_TFR]             = ft_freqstatistics(cfg,TFR_comb.pre,TFR_comb.pst);


%% T-tests & Effect Sizes
% T-test
[h,p,ci,stats] = ttest([EEGdata.test_pre],[EEGdata.test_pst],'Alpha',0.05);

% Effect size
d = computeCohen_d([EEGdata.test_pre],[EEGdata.test_pst], 'paired');
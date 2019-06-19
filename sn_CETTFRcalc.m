function TFR_dat = sn_CETTFRcalc(reref)

FREQ_RANGE  = [1 100]; 
BWINDOW     = [-0.5 0];
TOI         = [-0.5 1.5];

% TFR Settings
cfg             = [];
cfg.output      = 'pow';
cfg.channel     = 'all';
cfg.method      = 'mtmconvol';
cfg.taper       = 'hanning';
cfg.foi         = FREQ_RANGE(1):1:FREQ_RANGE(2);
cfg.t_ftimwin   = ones(length(cfg.foi),1).*0.5;
cfg.toi         = TOI(1):0.05:TOI(2);

% TFR Calculation
A       = strcmp({reref.block},'NBACK');
TFR_dat = ft_freqanalysis(cfg,reref(A));

% TFR Baseline Correction
cfg                 = [];
cfg.baseline        = BWINDOW;
cfg.baselinetype    ='db';
TFR_dat             = ft_freqbaseline(cfg, TFR_dat);

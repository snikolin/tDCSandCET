% sn_CETfig5
% TFR measures

% Add relevant toolbox
addpath /Users/stevannikolin/Documents/MATLAB/toolbox/UnivarScatter_v1.1
addpath /Users/stevannikolin/Documents/MATLAB/toolbox/kakearney-boundedline-pkg-32f2a1f/boundedline
addpath /Users/stevannikolin/Documents/MATLAB/toolbox/kakearney-boundedline-pkg-32f2a1f/inpaint_nans

%% Parameters
CMAP        = cbrewer('qual','Dark2', 3, 'cubic'); % Baseline | Diff | Post
colours     = vertcat(CMAP(1,:),CMAP(3,:));
COMPRESS    = 7;
HEIGHT      = 4;
WIDTH       = 8;
FONTSIZE    = 8;
SCATTERSZ   = 5;
MARKWIDTH   = 0.6;
YLIMS       = 1.05;
XLIMS       = [0.5 2.5];
XLIMDIFF    = [0.5 1.5];
LINEW       = 0.5;
TIME_WINDOW = [-0.2 0.6];
ERP_TIME    = find(preCET_ERP{1}.time >= TIME_WINDOW(1) & preCET_ERP{1}.time <= TIME_WINDOW(2));
CHANNEL     = 'Fz'; 

%% Plot TFR
ALPHA_FOI       = [8 12];
ALPHA_TOI       = [0.2 0.7];
THETA_FOI       = [4 8];
THETA_TOI       = [0 0.5];

cfg             = [];
cfg.channel     = CHANNEL;
cfg.layout      = lay;
cfg.parameter   = 'powspctrm';
cfg.xlim        = [-0.2 1];
cfg.ylim        = [1 30];
cfg.zlim        = [-2.2 1.6];
cfg.gridscale   = 100;
cfg.title       = {''};
cfg.colorbar    = 'yes';
cfg.fontsize    = FONTSIZE;

figure
ft_singleplotTFR(cfg,TFR_avg.all)
ylabel('Frequency (Hz)')
xlabel('Time (secs)')
hold on
% Stimulus Line
plot([0 0],[cfg.ylim(1) cfg.ylim(2)],'linestyle','--','color','black','linewidth',1.5)
% Alpha ERD
rectangle('Position', [ALPHA_TOI(1) ALPHA_FOI(1) (ALPHA_TOI(2)-ALPHA_TOI(1)) (ALPHA_FOI(2)-ALPHA_FOI(1))],'LineStyle',':',...
    'FaceColor','none','EdgeColor','white','LineWidth',1.5) 
% Theta ERS
rectangle('Position', [THETA_TOI(1) THETA_FOI(1) (THETA_TOI(2)-THETA_TOI(1)) (THETA_FOI(2)-THETA_FOI(1))],'LineStyle',':',...
    'FaceColor','none','EdgeColor','white','LineWidth',1.5) 

set(gca,'FontSize',FONTSIZE)
set(gcf,'PaperUnits','centimeters','PaperPosition',[0 0 WIDTH HEIGHT])
print -dtiff TFRFz.tif -r300

%% Scatterplots
HEIGHT          = 4;
SCATTER_WIDTH   = 6;
ERD_YLIM        = [-5.25 1.2];
ERS_YLIM        = [-1.2 2.9];

% Alpha ERD
figure
UnivarScatter(horzcat([EEGdata.AlphaERD_pre]', [EEGdata.AlphaERD_pst]'),'Label',{'BASELINE','POST'},...
    'MarkerFaceColor',colours,'MarkerEdgeColor','black','Width',MARKWIDTH,...
    'Whiskers','box','Compression',COMPRESS,'PointSize',SCATTERSZ); 
hold on
ylabel('Amplitude (uV)')
xlim(XLIMS)
ylim(ERD_YLIM)
set(gca,'FontSize',FONTSIZE)
set(gcf,'PaperUnits','centimeters','PaperPosition',[0 0 SCATTER_WIDTH HEIGHT],'papersize',[21.0 29.7])
print -dtiff AlphaERD.tif -r300

% Theta ERS
figure
UnivarScatter(horzcat([EEGdata.ThetaERS_pre]', [EEGdata.ThetaERS_pst]'),'Label',{'BASELINE','POST'},...
    'MarkerFaceColor',colours,'MarkerEdgeColor','black','Width',MARKWIDTH,...
    'Whiskers','box','Compression',COMPRESS,'PointSize',SCATTERSZ); 
hold on
ylabel('Amplitude (uV)')
xlim(XLIMS)
ylim(ERS_YLIM)
set(gca,'FontSize',FONTSIZE)
set(gcf,'PaperUnits','centimeters','PaperPosition',[0 0 SCATTER_WIDTH HEIGHT],'papersize',[21.0 29.7])
print -dtiff ThetaERS.tif -r300

%%
ALPHA_FOI       = [8 12];
ALPHA_TOI       = [0.2 0.7];
ALPHA_ZLIM      = [-2.2 -0.65];

cfg             = [];
cfg.layout      = lay;
cfg.xlim        = ALPHA_TOI;
cfg.ylim        = ALPHA_FOI;
cfg.zlim        = ALPHA_ZLIM;
cfg.marker      = 'on';
cfg.comment     = 'no';
cfg.highlight   = 'on';
cfg.colorbar    = 'no';
cfg.gridscale   = 100;
cfg.fontsize    = FONTSIZE;
cfg.highlightchannel    = 'Fz';
cfg.highlightcolor      = 'red';
cfg.highlightsymbol     = '+';

figure
ft_topoplotTFR(cfg,TFR_avg.pre)
set(gcf,'PaperUnits','centimeters','PaperPosition',[0 0 HEIGHT HEIGHT])
print -dtiff AlphaERDbaselineTopo.tif -r300

figure
ft_topoplotTFR(cfg,TFR_avg.pst)
set(gcf,'PaperUnits','centimeters','PaperPosition',[0 0 HEIGHT HEIGHT])
print -dtiff AlphaERDpostTopo.tif -r300

figure
cfg.colorbar = 'EastOutside';
ft_topoplotTFR(cfg,TFR_avg.pst)
set(gcf,'PaperUnits','centimeters','PaperPosition',[0 0 1.2*HEIGHT 1.2*HEIGHT])
print -dtiff AlphaERDcolorbar.tif -r300

%%
THETA_FOI       = [4 8];
THETA_TOI       = [0 0.5];
THETA_ZLIM      = [0 0.92];

cfg             = [];
cfg.layout      = lay;
cfg.xlim        = THETA_TOI;
cfg.ylim        = THETA_FOI;
cfg.zlim        = THETA_ZLIM;
cfg.marker      = 'on';
cfg.comment     = 'no';
cfg.highlight   = 'on';
cfg.colorbar    = 'no';
cfg.gridscale   = 100;
cfg.fontsize    = FONTSIZE;
cfg.highlightchannel    = 'Fz';
cfg.highlightcolor      = 'red';
cfg.highlightsymbol     = '+';

figure
ft_topoplotTFR(cfg,TFR_avg.pre)
set(gcf,'PaperUnits','centimeters','PaperPosition',[0 0 HEIGHT HEIGHT])
print -dtiff ThetaERSbaselineTopo.tif -r300

figure
ft_topoplotTFR(cfg,TFR_avg.pst)
set(gcf,'PaperUnits','centimeters','PaperPosition',[0 0 HEIGHT HEIGHT])
print -dtiff ThetaERSpostTopo.tif -r300

figure
cfg.colorbar = 'EastOutside';
ft_topoplotTFR(cfg,TFR_avg.pst)
set(gcf,'PaperUnits','centimeters','PaperPosition',[0 0 1.2*HEIGHT 1.2*HEIGHT])
print -dtiff ThetaERScolorbar.tif -r300
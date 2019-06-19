% sn_cetfig3
% Power Spectral Density

% Add relevant toolbox
addpath /Users/stevannikolin/Documents/MATLAB/toolbox/UnivarScatter_v1.1
addpath /Users/stevannikolin/Documents/MATLAB/toolbox/kakearney-boundedline-pkg-32f2a1f/boundedline
addpath /Users/stevannikolin/Documents/MATLAB/toolbox/kakearney-boundedline-pkg-32f2a1f/inpaint_nans

%% Parameters
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
LABEL       = {'Eyes Closd','Eyes Open'};
CHAN        = find(strcmp(PSD.EC.label,'Cz'));
PSDFREQ  = [1 45];   
psdfreq  = find(PSD.EC.freq >= PSDFREQ(1) & PSD.EC.freq <= PSDFREQ(2));

%% Data for plotting
PSDplot{1,1} = PSD.EC.pre;
PSDplot{1,2} = PSD.EC.pst;
PSDplot{2,1} = PSD.EO.pre;
PSDplot{2,2} = PSD.EO.pst;

%% PSD Plots
PSDYLIMS    = [-4 2];

% Eyes Closed
figure('Units','centimeters','Position',[0 0 WIDTH HEIGHT]);
for b = 1:size(PSDplot,2)
    temp = []; error = [];
    temp = bootstrp(BOOTSTRAPS, @(x) mean(x), squeeze(PSDplot{1,b}(:,chan,psdfreq)));
    temp = sort(temp);
    error(:,1) = temp(975,:) - temp(500,:); 
    error(:,2) = temp(500,:) - temp(25,:);
    tempsd{1,b} = temp(500);

    h{1,b} = boundedline(PSD.EC.freq(psdfreq),temp(500,:)',error,'cmap',CMAP(2*b-1,:),...
        'alpha','transparency',0.2,'linewidth',1.5);

    set(get(get(h{1,b},'Annotation'),'LegendInformation'),...
        'IconDisplayStyle','off');
    xlabel('Frequency (Hz)','Fontsize',FONTSIZE)
    ylabel(strcat(LABEL(1),' (\muV^2/Hz)'));
    hold on
end

axis tight
[~,L] = legend({'BASELINE','POST'}, 'location','northeast');
PatchInLegend = findobj(L,'type','patch');
set(PatchInLegend(1), 'FaceAlpha', 1);
set(PatchInLegend(2), 'FaceAlpha', 1);
set(gca,'Fontsize',FONTSIZE);
ylim(PSDYLIMS);
print -dtiff EC.PSDCz.tif -r300

% Eyes Open
figure('Units','centimeters','Position',[0 0 WIDTH HEIGHT]);
for b = 1:size(PSDplot,2)
    temp = []; error = [];
    temp = bootstrp(BOOTSTRAPS, @(x) mean(x), squeeze(PSDplot{2,b}(:,chan,psdfreq)));
    temp = sort(temp);
    error(:,1) = temp(975,:) - temp(500,:); 
    error(:,2) = temp(500,:) - temp(25,:);
    tempsd{2,b} = temp(500);

    h{2,b} = boundedline(PSD.EC.freq(psdfreq),temp(500,:)',error,'cmap',CMAP(2*b-1,:),...
        'alpha','transparency',0.2,'linewidth',1.5);

    set(get(get(h{2,b},'Annotation'),'LegendInformation'),...
        'IconDisplayStyle','off');
    xlabel('Frequency (Hz)','Fontsize',FONTSIZE)
    ylabel(strcat(LABEL(2),' (\muV^2/Hz)'));
    hold on
end

axis tight
[~,L] = legend({'BASELINE','POST'}, 'location','northeast');
PatchInLegend = findobj(L,'type','patch');
set(PatchInLegend(1), 'FaceAlpha', 1);
set(PatchInLegend(2), 'FaceAlpha', 1);
set(gca,'Fontsize',FONTSIZE);
ylim(PSDYLIMS);
print -dtiff EO.PSDCz.tif -r300

%% Scatterplots
HEIGHT          = 4;
SCATTER_WIDTH   = 6;
FAA_YLIM        = [-0.5 1.2];
THETA_YLIM      = [-4.2 1.5];

% Frontal Alpha Asymmetry
figure
UnivarScatter(horzcat([EEGdata.FAAPSD_pre]', [EEGdata.FAAPSD_pst]'),'Label',{'BASELINE','POST'},...
    'MarkerFaceColor',colours,'MarkerEdgeColor','black','Width',MARKWIDTH,...
    'Whiskers','box','Compression',COMPRESS,'PointSize',SCATTERSZ); 
hold on
ylabel('Frontal Alpha Asymmetry')
xlim(XLIMS)
ylim(FAA_YLIM)
set(gca,'FontSize',FONTSIZE)
set(gcf,'PaperUnits','centimeters','PaperPosition',[0 0 SCATTER_WIDTH HEIGHT],'papersize',[21.0 29.7])
print -dtiff FAAPSDscatter.tif -r300

% Frontal Theta
figure
UnivarScatter(horzcat([EEGdata.ThetaPSD_pre]', [EEGdata.ThetaPSD_pst]'),'Label',{'BASELINE','POST'},...
    'MarkerFaceColor',colours,'MarkerEdgeColor','black','Width',MARKWIDTH,...
    'Whiskers','box','Compression',COMPRESS,'PointSize',SCATTERSZ); 
hold on
ylabel('Frontal Theta')
xlim(XLIMS)
ylim(THETA_YLIM)
set(gca,'FontSize',FONTSIZE)
set(gcf,'PaperUnits','centimeters','PaperPosition',[0 0 SCATTER_WIDTH HEIGHT],'papersize',[21.0 29.7])
print -dtiff ThetaPSDscatter.tif -r300

%% Topography Alpha
ALPHA_FREQ  = [8 13];

alpha   = PSD.EC.freq >= ALPHA_FREQ(1) & PSD.EC.freq <= ALPHA_FREQ(2);
temppre = mean(PSD.EC.pre(:,:,alpha),3);
temppst = mean(PSD.EC.pst(:,:,alpha),3);
FAApre  = sn_tanhmean(temppre,1,0.6)';
FAApst  = sn_tanhmean(temppst,1,0.6)';

topopre.topolabel  = PSD.EC.label;
topopre.topo       = FAApre; % vector n x 1
topopst.topolabel  = PSD.EC.label;
topopst.topo       = FAApst;

cfg             = [];
cfg.title       = 'off';
cfg.layout      = lay;
cfg.component   = 1;
cfg.zlim        = [-0.15 1.33];
cfg.marker      = 'on';
cfg.comment     = 'no';
cfg.highlight   = 'on';
cfg.colorbar    = 'no'; % 'SouthOutside'
cfg.gridscale   = 100;
cfg.fontsize    = FONTSIZE;
cfg.highlightchannel    = {'F3','F4'};
cfg.highlightcolor      = 'red';
cfg.highlightsymbol     = '+';

figure
ft_topoplotIC(cfg,topopre)
set(gcf,'PaperUnits','centimeters','PaperPosition',[0 0 HEIGHT HEIGHT])
print -dtiff FAAtopoBASELINE.tif -r300

figure
ft_topoplotIC(cfg,topopst)
set(gcf,'PaperUnits','centimeters','PaperPosition',[0 0 HEIGHT HEIGHT])
print -dtiff FAAtopoPOST.tif -r300

figure
cfg.colorbar = 'EastOutside';
ft_topoplotIC(cfg,topopst)
set(gca,'FontSize',FONTSIZE)
set(gcf,'PaperUnits','centimeters','PaperPosition',[0 0 1.2*HEIGHT 1.2*HEIGHT])
print -dtiff FAAcolorbar.tif -r300

%% Topography Theta
THETA_FREQ  = [4 8];
CHANNELS    = {'Fp1','Fp2','Afz','F3','Fz','F4'};

theta   = PSD.EC.freq >= THETA_FREQ(1) & PSD.EC.freq <= THETA_FREQ(2);
temppre = mean(PSD.EC.pre(:,:,theta),3);
temppst = mean(PSD.EC.pst(:,:,theta),3);
FTpre   = sn_tanhmean(temppre,1,0.6)';
FTpst   = sn_tanhmean(temppst,1,0.6)';

topoFTpre.topolabel  = PSD.EC.label;
topoFTpre.topo       = FTpre; 
topoFTpst.topolabel  = PSD.EC.label;
topoFTpst.topo       = FTpst;

cfg             = [];
cfg.title       = 'off';
cfg.layout      = lay;
cfg.component   = 1;
cfg.zlim        = [-0.67 0.68];
cfg.marker      = 'on';
cfg.comment     = 'no';
cfg.highlight   = 'on';
cfg.colorbar    = 'no'; % 'SouthOutside'
cfg.gridscale   = 100;
cfg.fontsize    = FONTSIZE;
cfg.highlightchannel    = CHANNELS;
cfg.highlightcolor      = 'red';
cfg.highlightsymbol     = '+';

figure
ft_topoplotIC(cfg,topoFTpre)
set(gcf,'PaperUnits','centimeters','PaperPosition',[0 0 HEIGHT HEIGHT])
print -dtiff FTtopoBASELINE.tif -r300

figure
ft_topoplotIC(cfg,topoFTpst)
set(gcf,'PaperUnits','centimeters','PaperPosition',[0 0 HEIGHT HEIGHT])
print -dtiff FTtopoPOST.tif -r300

figure
cfg.colorbar = 'EastOutside';
ft_topoplotIC(cfg,topoFTpst)
set(gca,'FontSize',FONTSIZE)
set(gcf,'PaperUnits','centimeters','PaperPosition',[0 0 1.2*HEIGHT 1.2*HEIGHT])
print -dtiff FTcolorbar.tif -r300
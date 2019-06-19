% sn_CETfig4
% ERP measures

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
YLIMS       = 1.01;
XLIMS       = [0.5 2.5];
XLIMDIFF    = [0.5 1.5];
LINEW       = 0.5;
TIME_WINDOW = [-0.2 0.6];
ERP_TIME    = find(preCET_ERP{1}.time >= TIME_WINDOW(1) & preCET_ERP{1}.time <= TIME_WINDOW(2));
CHANNEL     = 'Fz'; 

%% Plot ERP

chan = find(strcmp(preCET_ERP{1}.label,CHANNEL));

% Generate data
baseline_indiv = []; post6wk_indiv = []; diff_indiv = [];
for n = 1:length(preCET_ERP)
    baseline_indiv(n,:) = preCET_ERP{n}.avg(chan,ERP_TIME);
    post6wk_indiv(n,:)  = pstCET_ERP{n}.avg(chan,ERP_TIME);
end

% Bootstrapping
temp1 = []; temp2 = []; 
error1 = []; error2 = []; 
temp1 = bootstrp(BOOTSTRAPS, @(x) mean(x), baseline_indiv);
temp2 = bootstrp(BOOTSTRAPS, @(x) mean(x), post6wk_indiv);
temp1 = sort(temp1);
temp2 = sort(temp2);
error1(:,1)  = temp1(975,:) - temp1(500,:);
error1(:,2)  = temp1(500,:) - temp1(25,:); 
error2(:,1)  = temp2(975,:) - temp2(500,:);
error2(:,2)  = temp2(500,:) - temp2(25,:);

% Error Plots
h1 = boundedline(preCET_ERP{1}.time(ERP_TIME),temp1(500,:),error1,...
    'cmap',CMAP(1,:),'alpha','transparency',0.2,'linewidth',1.5);
h2 = boundedline(preCET_ERP{1}.time(ERP_TIME),temp2(500,:),error2,...
    'cmap',CMAP(3,:),'alpha','transparency',0.2,'linewidth',1.5);
set(get(get(h1(1),'Annotation'),'LegendInformation'),'IconDisplayStyle','off');
set(get(get(h2(1),'Annotation'),'LegendInformation'),'IconDisplayStyle','off');
[~,L] = legend({'BASELINE','POST'}, 'location','southeast');
PatchInLegend = findobj(L,'type','patch');
set(PatchInLegend(1), 'FaceAlpha', 1);
set(PatchInLegend(2), 'FaceAlpha', 1);

hold on

yerp_max = max([max(temp1),max(temp2)])*YLIMS;
yerp_min = min([min(temp1),min(temp2)])*YLIMS;
plot([preCET_ERP{1}.time(ERP_TIME(1)) preCET_ERP{1}.time(ERP_TIME(end))],...
    [0 0],'LineStyle','--','Color','black','HandleVisibility','off');
plot([0 0],[yerp_min yerp_max],'LineStyle','--','Color','black','HandleVisibility','off');

rectangle('Position', [(0.1455-0.02) yerp_min 0.04 (yerp_max-yerp_min)],...
    'FaceColor', [0.1 0.1 0.1 0.1],'EdgeColor','none') 
rectangle('Position', [(0.3730-0.02) yerp_min 0.04 (yerp_max-yerp_min)],...
    'FaceColor', [0.1 0.1 0.1 0.1],'EdgeColor','none') 

axis tight
xlabel('Time (secs)')
ylabel ('Amplitude (uV)')

text(0.148,3.00,'P2','FontWeight','bold','Fontsize',FONTSIZE,'VerticalAlignment','bottom')
text(0.371,1.85,'P3','FontWeight','bold','Fontsize',FONTSIZE,'VerticalAlignment','bottom')

set(gca,'FontSize',FONTSIZE)
set(gcf,'PaperUnits','centimeters','PaperPosition',[0 0 WIDTH HEIGHT])
print -dtiff ERPFz.tif -r300

%% Scatterplots
HEIGHT          = 4;
SCATTER_WIDTH   = 6;
P2_YLIM         = [-0.8 4.85];
P3_YLIM         = [-2.5 4.75];

% P2
figure
UnivarScatter(horzcat([EEGdata.P2_pre]', [EEGdata.P2_pst]'),'Label',{'BASELINE','POST'},...
    'MarkerFaceColor',colours,'MarkerEdgeColor','black','Width',MARKWIDTH,...
    'Whiskers','box','Compression',COMPRESS,'PointSize',SCATTERSZ); 
hold on
ylabel('P2 Amplitude (\muV)')
xlim(XLIMS)
ylim(P2_YLIM)
set(gca,'FontSize',FONTSIZE)
set(gcf,'PaperUnits','centimeters','PaperPosition',[0 0 SCATTER_WIDTH HEIGHT],'papersize',[21.0 29.7])
print -dtiff P2.tif -r300

% P3
figure
UnivarScatter(horzcat([EEGdata.P3_pre]', [EEGdata.P3_pst]'),'Label',{'BASELINE','POST'},...
    'MarkerFaceColor',colours,'MarkerEdgeColor','black','Width',MARKWIDTH,...
    'Whiskers','box','Compression',COMPRESS,'PointSize',SCATTERSZ); 
hold on
ylabel('P3 Amplitude (\muV)')
xlim(XLIMS)
ylim(P3_YLIM)
set(gca,'FontSize',FONTSIZE)
set(gcf,'PaperUnits','centimeters','PaperPosition',[0 0 SCATTER_WIDTH HEIGHT],'papersize',[21.0 29.7])
print -dtiff P3.tif -r300

%% Topography P2 and P3
INTERVAL    = 0.02; 
CHANNEL     = 'Fz';
P2          = 0.1455; % all averaged
P2_LIM      = [-4.5 2];

% P2
cfg                     = [];
cfg.xlim                = [P2-INTERVAL P2+INTERVAL];
cfg.zlim                = P2_LIM;
cfg.layout              = lay;
cfg.marker              = 'on';
cfg.comment             = 'no';
cfg.highlight           = 'on';
cfg.highlightchannel    = CHANNEL;
cfg.highlightcolor      = 'red';
cfg.highlightsymbol     = '+';
cfg.colorbar            = 'no';
cfg.gridscale           = 100;
cfg.fontsize            = FONTSIZE;

figure
ft_topoplotER(cfg,basegrndavg)
set(gcf,'PaperUnits','centimeters','PaperPosition',[0 0 HEIGHT HEIGHT])
print -dtiff ERPp2base.tif -r300

figure
ft_topoplotER(cfg,endgrndavg)
set(gcf,'PaperUnits','centimeters','PaperPosition',[0 0 HEIGHT HEIGHT])
print -dtiff ERPp2post.tif -r300

figure
cfg.colorbar = 'EastOutside';
ft_topoplotER(cfg,endgrndavg)
set(gca,'FontSize',FONTSIZE)
set(gcf,'PaperUnits','centimeters','PaperPosition',[0 0 1.2*HEIGHT 1.2*HEIGHT])
print -dtiff ERPp2colorbar.tif -r300

%% P3
INTERVAL    = 0.02; 
P3          = 0.3730; % all averaged
P3_LIM      = [-2.75 1];

cfg                     = [];
cfg.xlim                = [P3-INTERVAL P3+INTERVAL];
cfg.zlim                = P3_LIM;
cfg.layout              = lay;
cfg.marker              = 'on';
cfg.comment             = 'no';
cfg.highlight           = 'on';
cfg.highlightchannel    = CHANNEL;
cfg.highlightcolor      = 'red';
cfg.highlightsymbol     = '+';
cfg.colorbar            = 'no';
cfg.gridscale           = 100;
cfg.fontsize            = FONTSIZE;

figure
ft_topoplotER(cfg,basegrndavg)
set(gcf,'PaperUnits','centimeters','PaperPosition',[0 0 HEIGHT HEIGHT])
print -dtiff ERPp3base.tif -r300

figure
ft_topoplotER(cfg,endgrndavg)
set(gcf,'PaperUnits','centimeters','PaperPosition',[0 0 HEIGHT HEIGHT])
print -dtiff ERPp3post.tif -r300

figure
cfg.colorbar = 'EastOutside';
ft_topoplotER(cfg,endgrndavg)
set(gca,'FontSize',FONTSIZE)
set(gcf,'PaperUnits','centimeters','PaperPosition',[0 0 1.2*HEIGHT 1.2*HEIGHT])
print -dtiff ERPp3colorbar.tif -r300
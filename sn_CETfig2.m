% sn_cetfig2
% Behavioural outcomes

% Add relevant toolbox
addpath /Users/stevannikolin/Documents/MATLAB/toolbox/UnivarScatter_v1.1

% Load data
load('CET_MADRS.mat')
load('CET_WMdprime.mat')
load('CET_WMrt.mat')

%% Parameters
CMAP        = cbrewer('qual','Dark2', 3, 'cubic'); % Baseline | Diff | Post
colours     = vertcat(CMAP(1,:),CMAP(3,:));
COMPRESS    = 7;
HEIGHT      = 4;
WIDTH       = 6;
FONTSIZE    = 8;
SCATTERSZ   = 5;
MARKWIDTH   = 0.6;
YLIMS       = 1.05;
XLIMS       = [0.5 2.5];
XLIMDIFF    = [0.5 1.5];
LINEW       = 0.5;

%% Plots
% Mood (MADRS)
figure
UnivarScatter(CET_MADRS(:,1:2),'Label',{'BASELINE','POST'},...
    'MarkerFaceColor',colours,'MarkerEdgeColor','black','Width',MARKWIDTH,...
    'Whiskers','box','Compression',COMPRESS,'PointSize',SCATTERSZ); 
hold on
ylabel('MADRS Total Score')
xlim(XLIMS)
ylim([0 max(CET_MADRS(:,1))*YLIMS])
set(gca,'FontSize',FONTSIZE)
set(gcf,'PaperUnits','centimeters','PaperPosition',[0 0 WIDTH HEIGHT],'papersize',[21.0 29.7])
print -dtiff MADRS.tif -r300

figure
UnivarScatter(CET_MADRS(:,4)*100,'Label',{'DIFFERENCE'},...
    'MarkerFaceColor',CMAP(2,:),'MarkerEdgeColor','black','Width',MARKWIDTH,...
    'Whiskers','box','Compression',COMPRESS,'PointSize',SCATTERSZ);
hold on
plot(XLIMDIFF, [0 0],'LineWidth',LINEW,'LineStyle',':','Color','black')
ylabel('Change in MADRS (%)')
axis tight
adjustment = (range(CET_MADRS(:,4)*100)*YLIMS - range(CET_MADRS(:,4)*100))/2;
ylim([(min(CET_MADRS(:,4))*100-adjustment) (max(CET_MADRS(:,4))*100+adjustment)])
set(gca,'FontSize',FONTSIZE)
set(gcf,'Units','centimeters','Position',[0 0 0.6*WIDTH HEIGHT])
print -dtiff MADRSdiff.tif -r300

% WM-dprime
figure
UnivarScatter(CET_WMdprime(:,1:2),'Label',{'BASELINE','POST'},...
    'MarkerFaceColor',colours,'MarkerEdgeColor','black','Width',MARKWIDTH,...
    'Whiskers','box','Compression',COMPRESS,'PointSize',SCATTERSZ); 
hold on
xlim(XLIMS)
ylabel('3-Back Task: D-prime')
ylim([-0.8 4])
set(gca,'FontSize',FONTSIZE)
set(gcf,'PaperUnits','centimeters','PaperPosition',[0 0 WIDTH HEIGHT],'papersize',[21.0 29.7])
print -dtiff WMdprime.tif -r300

figure
UnivarScatter(CET_WMdprime(:,3),'Label',{'DIFFERENCE'},...
    'MarkerFaceColor',CMAP(2,:),'MarkerEdgeColor','black','Width',MARKWIDTH,...
    'Whiskers','box','Compression',COMPRESS,'PointSize',SCATTERSZ);
hold on
plot(XLIMDIFF, [0 0],'LineWidth',LINEW,'LineStyle',':','Color','black')
ylabel('Change in D-prime')
axis tight
adjustment = (range(CET_WMdprime(:,3))*YLIMS - range(CET_WMdprime(:,3)))/2;
ylim([(min(-CET_WMdprime(:,3))-adjustment) (max(-CET_WMdprime(:,3))+adjustment)])
set(gca,'FontSize',FONTSIZE)
set(gcf,'PaperUnits','centimeters','PaperPosition',[0 0 0.6*WIDTH HEIGHT])
print -dtiff WMdprimediff.tif -r300

% WM-response time
figure
UnivarScatter(CET_WMrt(:,1:2),'Label',{'BASELINE','POST'},...
    'MarkerFaceColor',colours,'MarkerEdgeColor','black','Width',MARKWIDTH,...
    'Whiskers','box','Compression',COMPRESS,'PointSize',SCATTERSZ); 
hold on
xlim(XLIMS)
ylabel('3-Back Task: RT (ms)')
ylim([300 1300])
set(gca,'FontSize',FONTSIZE)
set(gcf,'PaperUnits','centimeters','PaperPosition',[0 0 WIDTH HEIGHT],'papersize',[21.0 29.7])
print -dtiff WMrt.tif -r300

figure
UnivarScatter(CET_WMrt(:,3),'Label',{'DIFFERENCE'},...
    'MarkerFaceColor',CMAP(2,:),'MarkerEdgeColor','black','Width',MARKWIDTH,...
    'Whiskers','box','Compression',COMPRESS,'PointSize',SCATTERSZ);
hold on
plot(XLIMDIFF, [0 0],'LineWidth',LINEW,'LineStyle',':','Color','black')
ylabel('Change in RT (ms)')
axis tight
adjustment = (range(CET_WMrt(:,3))*YLIMS - range(CET_WMrt(:,3)));
ylim([(min(CET_WMrt(:,3))-adjustment) (max(CET_WMrt(:,3))+adjustment)])
set(gca,'FontSize',FONTSIZE)
set(gcf,'PaperUnits','centimeters','PaperPosition',[0 0 0.6*WIDTH HEIGHT])
print -dtiff WMrtdiff.tif -r300

%%
figure('units','normalized','outerposition',[0 0 WIDTH/16 HEIGHT/16]);
set(gcf,'units','centimeters','position', [0 0 29.7,21.0],'papersize',[29.7 21.0])
%%

LABEL   = {'Difference'};
CMAP    = cbrewer('qual','Dark2', 3, 'cubic'); % Baseline | Diff | Post
MCOLOUR = 'black';
WIDTH   = 0.6;
COMPRESS= 10;
PSIZE   = 20;
S

UnivarScatter(CET_MADRS(:,4)*100,'Label',DIFFERENCE,...
    'MarkerFaceColor',CMAP(2,:),'MarkerEdgeColor',MCOLOUR,...
    'Width',WIDTH,'Whiskers','box','Compression',COMPRESS,...
    'PointSize',PSIZE);


%% Montage
load('lay32.mat')

LAYLINEW    = 1;
WIDTH       = 5;
HEIGHT      = 5;
FONTSIZE    = 7;
SCATTERSZ   = 5;

figure
hold on
plot(lay.outline{1}(:,1), lay.outline{1}(:,2),'k','LineWidth',LAYLINEW)
plot(lay.outline{2}(:,1), lay.outline{2}(:,2),'k','LineWidth',LAYLINEW)
plot(lay.outline{3}(:,1), lay.outline{3}(:,2),'k','LineWidth',LAYLINEW)
plot(lay.outline{4}(:,1), lay.outline{4}(:,2),'k','LineWidth',LAYLINEW)
axis off
axis tight

hold on
channels = setdiff(1:length(lay.label),[find(strcmp(lay.label,'COMNT')),find(strcmp(lay.label,'SCALE'))]);
scatter(lay.pos(channels,1),lay.pos(channels,2),SCATTERSZ,'black','o','filled');

for t = 1:length(lay.label)
    text(lay.pos(t,1),lay.pos(t,2)+0.037,cellstr(lay.label(t)),...
        'fontname','Calibri','fontsize',FONTSIZE,'HorizontalAlignment','center')
end

set(gca,'FontSize',FONTSIZE)
set(gcf,'PaperUnits','centimeters','PaperPosition',[0 0 WIDTH HEIGHT],'papersize',[21.0 29.7])
print -dtiff CETlayout.tif -r300
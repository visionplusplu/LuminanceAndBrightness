function WeightHeatMap(WhichWeight,Allweight,WeightList,WeightMat,OptimalWeight_individual,OptimalWeight_mean,RGB_weights_rad,RGB_weights_lum)

%% Plot weights in another way
for w1 = 1:size(WeightList,1)
    wG = WeightList(w1,2);
    wB = WeightList(w1,3);
    nwG = find(wG==Allweight);
    nwB = find(wB==Allweight);
    WeightMat_realign(nwG,nwB) = WeightMat(w1);
end

%% Plot
f = figure;hold on;
imagesc(Allweight,Allweight,WeightMat_realign)

plot(OptimalWeight_mean(1,3),OptimalWeight_mean(1,2),'ro','MarkerFaceColor','r','MarkerSize',10,'LineWidth',2)
plot(RGB_weights_lum(3)/RGB_weights_lum(1),RGB_weights_lum(2)/RGB_weights_lum(1),'ko','MarkerFaceColor','k','MarkerSize',10,'LineWidth',2);
plot(RGB_weights_rad(3)/RGB_weights_rad(1),RGB_weights_rad(2)/RGB_weights_rad(1),'o','Color',[0.8,0.8,0.8],'MarkerFaceColor',[0.8,0.8,0.8],'MarkerSize',10,'LineWidth',2);

% plot(squeeze(OptimalWeight_individual(1,3)),squeeze(OptimalWeight_individual(1,2)),'ko','MarkerSize',5,'LineWidth',1);
for Subject = 1:size(OptimalWeight_individual,1)
    plot(squeeze(OptimalWeight_individual(Subject,3)),squeeze(OptimalWeight_individual(Subject,2)),'ko','MarkerSize',5,'LineWidth',1)
end

caxis([0,1]);
a = colorbar;
a.Label.Position(1) = 3;
title(WhichWeight)
legend({'Optimal fit','Luminance','Radiance','Individual weights'},'NumColumns',1,'FontSize',8)
xlabel('wB/wR')
ylabel('wG/wR')
xlim([0,3])
ylim([0,4])
set(gca,'YDir','normal')
set(gca,'FontSize',16)
set(gca,'LineWidth',2)
set(gca,'Box','off')
set(f, 'Position', [100, 100, 400, 450]);



function FitExponent(cubeRGBs4Fitting,MeanRanking,Weights,FigId)

exponentList = 0.5:0.05:4.2;

if length(size(cubeRGBs4Fitting)) == 3   %%% Non-chroma Variation Experiment
    MwRGB_temp(1,:,:) = squeeze(cubeRGBs4Fitting(:,:,1)*Weights(1));
    MwRGB_temp(2,:,:) = squeeze(cubeRGBs4Fitting(:,:,2)*Weights(2));
    MwRGB_temp(3,:,:) = squeeze(cubeRGBs4Fitting(:,:,3)*Weights(3));
    for n = 1:length(exponentList)
        Minkowski = squeeze((MwRGB_temp(1,:,:).^exponentList(n)+MwRGB_temp(2,:,:).^exponentList(n)+MwRGB_temp(3,:,:).^exponentList(n)).^(1/exponentList(n)));
        [corrCoef,p_val] = corr(MeanRanking,Minkowski(:),'Type','Spearman');
        Corr_Minkowski(n) = corrCoef;
    end
    MwRGB = squeeze(max(squeeze(MwRGB_temp)));
    [Corr_maxweighted,p_val] = corr(MeanRanking,MwRGB(:),'Type','Spearman');

elseif length(size(cubeRGBs4Fitting)) == 2 %%% Chroma Variation Experiment
    MeanRanking_permuted = permute(MeanRanking, [3, 2, 1]);
    MeanRanking_permuted  = MeanRanking_permuted(:);
    ValidLoc = find(~isnan(MeanRanking_permuted));
    MwRGB_temp(1,:) = squeeze(cubeRGBs4Fitting(:,1)*Weights(1));
    MwRGB_temp(2,:) = squeeze(cubeRGBs4Fitting(:,2)*Weights(2));
    MwRGB_temp(3,:) = squeeze(cubeRGBs4Fitting(:,3)*Weights(3));
    for n = 1:length(exponentList)
        Minkowski = squeeze((MwRGB_temp(1,:).^exponentList(n)+MwRGB_temp(2,:).^exponentList(n)+MwRGB_temp(3,:).^exponentList(n)).^(1/exponentList(n)));
        [corrCoef,p_val] = corr(MeanRanking_permuted(ValidLoc),Minkowski(ValidLoc)','Type','Spearman');
        Corr_Minkowski(n) = corrCoef;
    end
    MwRGB = squeeze(max(squeeze(MwRGB_temp)))';
    [Corr_maxweighted,p_val] = corr(MeanRanking_permuted(ValidLoc),MwRGB(ValidLoc),'Type','Spearman');
end



figure("Name",FigId,'NumberTitle','off');
plot(exponentList,(1-Corr_Minkowski.^2)*100,'-','LineWidth',3,'color',[0.5,0.5,0.5]);
hold on 
plot([exponentList(end)+0.3,exponentList(end)+0.8],[(1-Corr_maxweighted.^2)*100,(1-Corr_maxweighted.^2)*100],'-','LineWidth',3,'color',[0.5,0.5,0.5]);
box off
text(4.3,0,"\\",'FontSize',18);
text(4.5,0,"\\",'FontSize',18);
xticks([0:1:5])
xticklabels({'0','1','2','3','4','∞'});


xlabel('Exponent');
ylabel('Unexplained Variance (%)');
title('Minkowski Metric');
set(gca,'FontSize',18)
set(gca,'LineWidth',2)
hold on
axis square;
ylim([0,50])
xlim([0,exponentList(end)+1.2])


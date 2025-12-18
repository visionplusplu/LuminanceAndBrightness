function FitExponent(cubeRGBs4Fitting,MeanRanking,Weights)

exponentList = 0:0.05:20;

if length(size(cubeRGBs4Fitting)) == 3   %%% Non-chroma Variation Experiment
    MwRGB_temp(1,:,:) = squeeze(cubeRGBs4Fitting(:,:,1)*Weights(1));
    MwRGB_temp(2,:,:) = squeeze(cubeRGBs4Fitting(:,:,2)*Weights(2));
    MwRGB_temp(3,:,:) = squeeze(cubeRGBs4Fitting(:,:,3)*Weights(3));
    for n = 1:length(exponentList)
        Minkowski = squeeze((MwRGB_temp(1,:,:).^exponentList(n)+MwRGB_temp(2,:,:).^exponentList(n)+MwRGB_temp(3,:,:).^exponentList(n)).^(1/exponentList(n)));
        [corrCoef,p_val] = corr(MeanRanking,Minkowski(:),'Type','Spearman');
        Corr_Minkowski(n) = corrCoef;
    end
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
end




figure;
plot(exponentList,(1-Corr_Minkowski.^2)*100,'-','LineWidth',3,'color',[0.5,0.5,0.5]);
box off
xlabel('Exponent');
ylabel('Unexplained Variance (%)');
set(gca,'FontSize',18)
set(gca,'LineWidth',2)
hold on
axis square;
ylim([0,70])
xlim([0,11.5])


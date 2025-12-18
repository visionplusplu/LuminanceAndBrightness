function BrightnessModelComparison(PatchRanking,OptimalWeights,linearRGB,BrightnessModel)
if length(size(PatchRanking)) == 2
    CubeRanking_All = mean(PatchRanking)';
elseif length(size(PatchRanking)) == 4
    CubeRanking_All = squeeze(nanmean(PatchRanking));
    CubeRanking_All = permute(CubeRanking_All, [3, 2, 1]);
    CubeRanking_All = CubeRanking_All(:);
end

ValidLoc_Ranking = find(isnan(CubeRanking_All)~=1);


count = 0;
%% Max-weighted
MaxWeights = OptimalWeights.OptimalMaxWeight;
MwRGB_temp(1,:) = squeeze(linearRGB(:,1)*MaxWeights(1));
MwRGB_temp(2,:) = squeeze(linearRGB(:,2)*MaxWeights(2));
MwRGB_temp(3,:) = squeeze(linearRGB(:,3)*MaxWeights(3));
MwRGB = squeeze(max(squeeze(MwRGB_temp)))';

ValidLoc_Model = find(isnan(MwRGB)~=1);
ValidLoc = intersect(ValidLoc_Ranking,ValidLoc_Model);
figure;
hold on
for nPatch = 1:length(ValidLoc)
    plot(MwRGB(ValidLoc(nPatch)),CubeRanking_All(ValidLoc(nPatch)),'.','MarkerSize',28,'LineWidth',1.5,'Color',linearRGB(ValidLoc(nPatch),:).^(1/2.2));
end
[corrCoef,p_val] = corr(CubeRanking_All(ValidLoc),MwRGB(ValidLoc),'Type','Spearman');
ylabel('Rankings','FontSize',16);
title('Max-weighted Model','FontSize',24);
text(min(MwRGB(ValidLoc))*1.05,11,[num2str((1-corrCoef^2)*100),'%'],'FontSize',16);
set(gca,'FontSize',16)
set(gca,'LineWidth',2)
box off
axis square;
count = count+1;
UnexplainedVariance(1,count) = 1-corrCoef^2;
UnexplainedVariance_withMaxWeighted(1,count) = 1-corr(MwRGB(ValidLoc),MwRGB(ValidLoc),'Type','Spearman')^2;
UnexplainedVarianceList{1,count} = 'Max-weighted Model'
corrCoef

%% Sum-weighted
SumWeights = OptimalWeights.OptimalSumWeight;
SwRGB = linearRGB*SumWeights';

ValidLoc_Model = find(isnan(SwRGB)~=1);
ValidLoc = intersect(ValidLoc_Ranking,ValidLoc_Model);
figure;
hold on
for nPatch = 1:length(ValidLoc)
    plot(SwRGB(ValidLoc(nPatch)),CubeRanking_All(ValidLoc(nPatch)),'.','MarkerSize',28,'LineWidth',1.5,'Color',linearRGB(ValidLoc(nPatch),:).^(1/2.2));
end
[corrCoef,p_val] = corr(CubeRanking_All(ValidLoc),SwRGB(ValidLoc),'Type','Spearman');
ylabel('Rankings','FontSize',16);
title('Sum-weighted Model','FontSize',16);
text(min(SwRGB(ValidLoc))*1.05,11,[num2str((1-corrCoef^2)*100),'%'],'FontSize',16);
set(gca,'FontSize',16)
set(gca,'LineWidth',2)
box off
axis square;
count = count+1;
UnexplainedVariance(1,count) = 1-corrCoef^2;
UnexplainedVariance_withMaxWeighted(1,count) = 1-corr(MwRGB(ValidLoc),SwRGB(ValidLoc),'Type','Spearman')^2;
UnexplainedVarianceList{1,count} = 'Sum-weighted Model';


%% CAM16 (Dim)
ValidLoc_Model = find(isnan(BrightnessModel.CAM16_Q_Dim)~=1);
ValidLoc = intersect(ValidLoc_Ranking,ValidLoc_Model);
figure;
hold on
for nPatch = 1:length(ValidLoc)
    plot(BrightnessModel.CAM16_Q_Dim(ValidLoc(nPatch)),CubeRanking_All(ValidLoc(nPatch)),'.','MarkerSize',28,'LineWidth',1.5,'Color',linearRGB(ValidLoc(nPatch),:).^(1/2.2));
end
[corrCoef,p_val] = corr(CubeRanking_All(ValidLoc),BrightnessModel.CAM16_Q_Dim(ValidLoc),'Type','Spearman');
ylabel('Rankings','FontSize',16);
title('CAM16(Dim)','FontSize',24);
text(min(BrightnessModel.CAM16_Q_Dim(ValidLoc))*1.05,11,[num2str((1-corrCoef^2)*100),'%'],'FontSize',16);
set(gca,'FontSize',16)
set(gca,'LineWidth',2)
box off
axis square;
count = count+1;
UnexplainedVariance(1,count) = 1-corrCoef^2;
UnexplainedVariance_withMaxWeighted(1,count) = 1-corr(MwRGB(ValidLoc),BrightnessModel.CAM16_Q_Dim(ValidLoc),'Type','Spearman')^2;
UnexplainedVarianceList{1,count} = 'CAM16 (Dim)'
corrCoef


%% High Model
ValidLoc_Model = find(isnan(BrightnessModel.High)~=1);
ValidLoc = intersect(ValidLoc_Ranking,ValidLoc_Model);
figure;
hold on
for nPatch = 1:length(ValidLoc)
    plot(BrightnessModel.High(ValidLoc(nPatch)),CubeRanking_All(ValidLoc(nPatch)),'.','MarkerSize',28,'LineWidth',1.5,'Color',linearRGB(ValidLoc(nPatch),:).^(1/2.2));
end
[corrCoef,p_val] = corr(CubeRanking_All(ValidLoc),BrightnessModel.High(ValidLoc),'Type','Spearman');
ylabel('Rankings','FontSize',16);
title('High Model','FontSize',24);
text(min(BrightnessModel.High(ValidLoc))*1.05,11,[num2str((1-corrCoef^2)*100),'%'],'FontSize',16);
set(gca,'FontSize',16)
set(gca,'LineWidth',2)
box off
axis square;
count = count+1;
UnexplainedVariance(1,count) = 1-corrCoef^2;
UnexplainedVariance_withMaxWeighted(1,count) = 1-corr(MwRGB(ValidLoc),BrightnessModel.High(ValidLoc),'Type','Spearman')^2;
UnexplainedVarianceList{1,count} = 'High';

%% Farchild-Pirrotta Model
ValidLoc_Model = find(isnan(BrightnessModel.Farchild_Pirrotta)~=1);
ValidLoc = intersect(ValidLoc_Ranking,ValidLoc_Model);
figure;
hold on
for nPatch = 1:length(ValidLoc)
    plot(BrightnessModel.Farchild_Pirrotta(ValidLoc(nPatch)),CubeRanking_All(ValidLoc(nPatch)),'.','MarkerSize',28,'LineWidth',1.5,'Color',linearRGB(ValidLoc(nPatch),:).^(1/2.2));
end
[corrCoef,p_val] = corr(CubeRanking_All(ValidLoc),BrightnessModel.Farchild_Pirrotta(ValidLoc),'Type','Spearman');
ylabel('Rankings','FontSize',16);
title('Farchild-Pirrotta Model','FontSize',24);
text(min(BrightnessModel.Farchild_Pirrotta(ValidLoc))*1.05,11,[num2str((1-corrCoef^2)*100),'%'],'FontSize',16);
set(gca,'FontSize',16)
set(gca,'LineWidth',2)
box off
axis square;
count = count+1;
UnexplainedVariance(1,count) = 1-corrCoef^2;
UnexplainedVariance_withMaxWeighted(1,count) = 1-corr(MwRGB(ValidLoc),BrightnessModel.Farchild_Pirrotta(ValidLoc),'Type','Spearman')^2;
UnexplainedVarianceList{1,count} = 'Farchild-Pirrotta';
%% Hellwig Model
ValidLoc_Model = find(isnan(BrightnessModel.HellwigHK_CAM16_Q_Dim)~=1);
ValidLoc = intersect(ValidLoc_Ranking,ValidLoc_Model);
figure;
hold on
for nPatch = 1:length(ValidLoc)
    plot(BrightnessModel.HellwigHK_CAM16_Q_Dim(ValidLoc(nPatch)),CubeRanking_All(ValidLoc(nPatch)),'.','MarkerSize',28,'LineWidth',1.5,'Color',linearRGB(ValidLoc(nPatch),:).^(1/2.2));
end
[corrCoef,p_val] = corr(CubeRanking_All(ValidLoc),BrightnessModel.HellwigHK_CAM16_Q_Dim(ValidLoc),'Type','Spearman');
ylabel('Rankings','FontSize',16);
title('Hellwig Model','FontSize',24);
text(min(BrightnessModel.HellwigHK_CAM16_Q_Dim(ValidLoc))*1.05,11,[num2str((1-corrCoef^2)*100),'%'],'FontSize',16);
set(gca,'FontSize',16)
set(gca,'LineWidth',2)
box off
axis square;
count = count+1;
UnexplainedVariance(1,count) = 1-corrCoef^2;
UnexplainedVariance_withMaxWeighted(1,count) = 1-corr(MwRGB(ValidLoc),BrightnessModel.HellwigHK_CAM16_Q_Dim(ValidLoc),'Type','Spearman')^2;
UnexplainedVarianceList{1,count} = 'Hellwig';

%% In Park's paper
ValidLoc_Model = find(isnan(BrightnessModel.Park_Dim)~=1);
ValidLoc = intersect(ValidLoc_Ranking,ValidLoc_Model);
figure;
hold on
for nPatch = 1:length(ValidLoc)
    plot(BrightnessModel.Park_Dim(ValidLoc(nPatch)),CubeRanking_All(ValidLoc(nPatch)),'.','MarkerSize',28,'LineWidth',1.5,'Color',linearRGB(ValidLoc(nPatch),:).^(1/2.2));
end
[corrCoef,p_val] = corr(CubeRanking_All(ValidLoc),BrightnessModel.Park_Dim(ValidLoc),'Type','Spearman');
ylabel('Rankings','FontSize',16);
title('Park Model','FontSize',24);
text(min(BrightnessModel.Park_Dim(ValidLoc))*1.05,11,[num2str((1-corrCoef^2)*100),'%'],'FontSize',16);
set(gca,'FontSize',16)
set(gca,'LineWidth',2)
box off
axis square;
count = count+1;
UnexplainedVariance(1,count) = 1-corrCoef^2;
UnexplainedVariance_withMaxWeighted(1,count) = 1-corr(MwRGB(ValidLoc),BrightnessModel.Park_Dim(ValidLoc),'Type','Spearman')^2;
UnexplainedVarianceList{1,count} = 'Park';

%% In Kim's 2025 paper
ValidLoc_Model = find(isnan(BrightnessModel.J_Dim_Kim_Original)~=1);
ValidLoc = intersect(ValidLoc_Ranking,ValidLoc_Model);
figure;
hold on
for nPatch = 1:length(ValidLoc)
    plot(BrightnessModel.J_Dim_Kim_Original(ValidLoc(nPatch)),CubeRanking_All(ValidLoc(nPatch)),'.','MarkerSize',28,'LineWidth',1.5,'Color',linearRGB(ValidLoc(nPatch),:).^(1/2.2));
end
[corrCoef,p_val] = corr(CubeRanking_All(ValidLoc),BrightnessModel.J_Dim_Kim_Original(ValidLoc),'Type','Spearman');
ylabel('Rankings','FontSize',16);
title('Kim Model (J)','FontSize',24);
text(min(BrightnessModel.J_Dim_Kim_Original(ValidLoc))*1.05,11,[num2str((1-corrCoef^2)*100),'%'],'FontSize',16);
set(gca,'FontSize',16)
set(gca,'LineWidth',2)
box off
axis square;
count = count+1;
UnexplainedVariance(1,count) = 1-corrCoef^2;
UnexplainedVariance_withMaxWeighted(1,count) = 1-corr(MwRGB(ValidLoc),BrightnessModel.J_Dim_Kim_Original(ValidLoc),'Type','Spearman')^2;
UnexplainedVarianceList{1,count} = 'J-Kim';

%% In the sUCS and sCAM papers
ValidLoc_Model = find(isnan(BrightnessModel.Lightess_sUCS_sRGB)~=1);
ValidLoc = intersect(ValidLoc_Ranking,ValidLoc_Model);
figure;
hold on
for nPatch = 1:length(ValidLoc)
    plot(BrightnessModel.Lightess_sUCS_sRGB(ValidLoc(nPatch)),CubeRanking_All(ValidLoc(nPatch)),'.','MarkerSize',28,'LineWidth',1.5,'Color',linearRGB(ValidLoc(nPatch),:).^(1/2.2));
end
[corrCoef,p_val] = corr(CubeRanking_All(ValidLoc),BrightnessModel.Lightess_sUCS_sRGB(ValidLoc),'Type','Spearman');
ylabel('Rankings','FontSize',16);
title('sUCS Lightness','FontSize',24);  %%% in sUCS they used lightness, no brightness
text(min(BrightnessModel.Lightess_sUCS_sRGB(ValidLoc))*1.05,11,[num2str((1-corrCoef^2)*100),'%'],'FontSize',16);
set(gca,'FontSize',16)
set(gca,'LineWidth',2)
box off
axis square;
count = count+1;
UnexplainedVariance(1,count) = 1-corrCoef^2;
UnexplainedVariance_withMaxWeighted(1,count) = 1-corr(MwRGB(ValidLoc),BrightnessModel.Lightess_sUCS_sRGB(ValidLoc),'Type','Spearman')^2;
UnexplainedVarianceList{1,count} = 'sUCS';

ValidLoc_Model = find(isnan(BrightnessModel.Q_sCAM_sRGB)~=1);
ValidLoc = intersect(ValidLoc_Ranking,ValidLoc_Model);
figure;
hold on
for nPatch = 1:length(ValidLoc)
    plot(BrightnessModel.Q_sCAM_sRGB(ValidLoc(nPatch)),CubeRanking_All(ValidLoc(nPatch)),'.','MarkerSize',28,'LineWidth',1.5,'Color',linearRGB(ValidLoc(nPatch),:).^(1/2.2));
end
[corrCoef,p_val] = corr(CubeRanking_All(ValidLoc),BrightnessModel.Q_sCAM_sRGB(ValidLoc),'Type','Spearman');
ylabel('Rankings','FontSize',16);
title('sCAM Brightness','FontSize',24); %%% in sCAM they used Q
text(min(BrightnessModel.Q_sCAM_sRGB(ValidLoc))*1.05,11,[num2str((1-corrCoef^2)*100),'%'],'FontSize',16);
set(gca,'FontSize',16)
set(gca,'LineWidth',2)
box off
axis square;
count = count+1;
UnexplainedVariance(1,count) = 1-corrCoef^2;
UnexplainedVariance_withMaxWeighted(1,count) = 1-corr(MwRGB(ValidLoc),BrightnessModel.Q_sCAM_sRGB(ValidLoc),'Type','Spearman')^2;
UnexplainedVarianceList{1,count} = 'sCAM';



%% In the Liao et al papers, based on CAM16
ValidLoc_Model = find(isnan(BrightnessModel.L_star_byLiao)~=1);
ValidLoc = intersect(ValidLoc_Ranking,ValidLoc_Model);
figure;
hold on
for nPatch = 1:length(ValidLoc)
    plot(BrightnessModel.L_star_byLiao(ValidLoc(nPatch)),CubeRanking_All(ValidLoc(nPatch)),'.','MarkerSize',28,'LineWidth',1.5,'Color',linearRGB(ValidLoc(nPatch),:).^(1/2.2));
end
[corrCoef,p_val] = corr(CubeRanking_All(ValidLoc),BrightnessModel.L_star_byLiao(ValidLoc),'Type','Spearman');
ylabel('Rankings','FontSize',16);
title('L* by Liao et al','FontSize',24);  %%% in sUCS they used lightness, no brightness
text(min(BrightnessModel.L_star_byLiao(ValidLoc))*1.05,11,[num2str((1-corrCoef^2)*100),'%'],'FontSize',16);
set(gca,'FontSize',16)
set(gca,'LineWidth',2)
box off
axis square;
count = count+1;
UnexplainedVariance(1,count) = 1-corrCoef^2;
UnexplainedVariance_withMaxWeighted(1,count) = 1-corr(MwRGB(ValidLoc),BrightnessModel.L_star_byLiao(ValidLoc),'Type','Spearman')^2;
UnexplainedVarianceList{1,count} = 'L* - Liao et al';

ValidLoc_Model = find(isnan(BrightnessModel.J_HK_byLiao)~=1);
ValidLoc = intersect(ValidLoc_Ranking,ValidLoc_Model);
figure;
hold on
for nPatch = 1:length(ValidLoc)
    plot(BrightnessModel.J_HK_byLiao(ValidLoc(nPatch)),CubeRanking_All(ValidLoc(nPatch)),'.','MarkerSize',28,'LineWidth',1.5,'Color',linearRGB(ValidLoc(nPatch),:).^(1/2.2));
end
[corrCoef,p_val] = corr(CubeRanking_All(ValidLoc),BrightnessModel.J_HK_byLiao(ValidLoc),'Type','Spearman');
ylabel('Rankings','FontSize',16);
title('J(HK) by Liao et al','FontSize',24); %%% in sCAM they used Q
text(min(BrightnessModel.J_HK_byLiao(ValidLoc))*1.05,11,[num2str((1-corrCoef^2)*100),'%'],'FontSize',16);
set(gca,'FontSize',16)
set(gca,'LineWidth',2)
box off
axis square;
count = count+1;
UnexplainedVariance(1,count) = 1-corrCoef^2;
UnexplainedVariance_withMaxWeighted(1,count) = 1-corr(MwRGB(ValidLoc),BrightnessModel.J_HK_byLiao(ValidLoc),'Type','Spearman')^2;
UnexplainedVarianceList{1,count} = 'J - Liao et al';



%% VB function of G0 from Nayatani's paper
ValidLoc_Model = find(isnan(BrightnessModel.Nayatani_G0)~=1);
ValidLoc = intersect(ValidLoc_Ranking,ValidLoc_Model);
figure;
hold on
for nPatch = 1:length(ValidLoc)
    plot(BrightnessModel.Nayatani_G0(ValidLoc(nPatch)),CubeRanking_All(ValidLoc(nPatch)),'.','MarkerSize',28,'LineWidth',1.5,'Color',linearRGB(ValidLoc(nPatch),:).^(1/2.2));
end
[corrCoef,p_val] = corr(CubeRanking_All(ValidLoc),BrightnessModel.Nayatani_G0(ValidLoc)','Type','Spearman');
ylabel('Rankings','FontSize',16);
title('Nayatani (G0)','FontSize',24); %%% in sCAM they used Q
text(min(BrightnessModel.Nayatani_G0(ValidLoc))*1.05,11,[num2str((1-corrCoef^2)*100),'%'],'FontSize',16);
set(gca,'FontSize',16)
set(gca,'LineWidth',2)
box off
axis square;
count = count+1;
UnexplainedVariance(1,count) = 1-corrCoef^2;
UnexplainedVariance_withMaxWeighted(1,count) = 1-corr(MwRGB(ValidLoc),BrightnessModel.Nayatani_G0(ValidLoc)','Type','Spearman')^2;
UnexplainedVarianceList{1,count} = 'Nayatani (G0)';

%% Luminance
ValidLoc_Model = find(isnan(BrightnessModel.Luminance)~=1);
ValidLoc = intersect(ValidLoc_Ranking,ValidLoc_Model);
figure;
hold on
for nPatch = 1:length(ValidLoc)
    plot(BrightnessModel.Luminance(ValidLoc(nPatch)),CubeRanking_All(ValidLoc(nPatch)),'.','MarkerSize',28,'LineWidth',1.5,'Color',linearRGB(ValidLoc(nPatch),:).^(1/2.2));
end
[corrCoef,p_val] = corr(CubeRanking_All(ValidLoc),BrightnessModel.Luminance(ValidLoc)','Type','Spearman');
ylabel('Rankings','FontSize',16);
title('Luminance','FontSize',24);
text(min(BrightnessModel.Luminance(ValidLoc))*1.05,11,[num2str((1-corrCoef^2)*100),'%'],'FontSize',16);
set(gca,'FontSize',16)
set(gca,'LineWidth',2)
box off
axis square;
count = count+1;
UnexplainedVariance(1,count) = 1-corrCoef^2;
UnexplainedVariance_withMaxWeighted(1,count) = 1-corr(MwRGB(ValidLoc),BrightnessModel.Luminance(ValidLoc)','Type','Spearman')^2;
UnexplainedVarianceList{1,count} = 'Luminance'
corrCoef
%% Radiance
ValidLoc_Model = find(isnan(BrightnessModel.Radiance)~=1);
ValidLoc = intersect(ValidLoc_Ranking,ValidLoc_Model);
figure;
hold on
for nPatch = 1:length(ValidLoc)
    plot(BrightnessModel.Radiance(ValidLoc(nPatch)),CubeRanking_All(ValidLoc(nPatch)),'.','MarkerSize',28,'LineWidth',1.5,'Color',linearRGB(ValidLoc(nPatch),:).^(1/2.2));
end
[corrCoef,p_val] = corr(CubeRanking_All(ValidLoc),BrightnessModel.Radiance(ValidLoc)','Type','Spearman');
ylabel('Rankings','FontSize',16);
title('Radiance','FontSize',24);
text(min(BrightnessModel.Radiance(ValidLoc))*1.05,11,[num2str((1-corrCoef^2)*100),'%'],'FontSize',16);
set(gca,'FontSize',16)
set(gca,'LineWidth',2)
box off
axis square;
count = count+1;
UnexplainedVariance(1,count) = 1-corrCoef^2;
UnexplainedVariance_withMaxWeighted(1,count) = 1-corr(MwRGB(ValidLoc),BrightnessModel.Radiance(ValidLoc)','Type','Spearman')^2;
UnexplainedVarianceList{1,count} = 'Radiance'
corrCoef
%% Hunt
ValidLoc_Model = find(isnan(BrightnessModel.Hunt_Q_Norm)~=1);
ValidLoc = intersect(ValidLoc_Ranking,ValidLoc_Model);
figure;
hold on
for nPatch = 1:length(ValidLoc)
    plot(BrightnessModel.Hunt_Q_Norm(ValidLoc(nPatch)),CubeRanking_All(ValidLoc(nPatch)),'.','MarkerSize',28,'LineWidth',1.5,'Color',linearRGB(ValidLoc(nPatch),:).^(1/2.2));
end
[corrCoef,p_val] = corr(CubeRanking_All(ValidLoc),BrightnessModel.Hunt_Q_Norm(ValidLoc)','Type','Spearman');
ylabel('Rankings','FontSize',16);
title('Hunt Model','FontSize',24);
text(min(BrightnessModel.Hunt_Q_Norm(ValidLoc))*1.05,11,[num2str((1-corrCoef^2)*100),'%'],'FontSize',16);
set(gca,'FontSize',16)
set(gca,'LineWidth',2)
box off
axis square;
count = count+1;
UnexplainedVariance(1,count) = 1-corrCoef^2;
UnexplainedVariance_withMaxWeighted(1,count) = 1-corr(MwRGB(ValidLoc),BrightnessModel.Hunt_Q_Norm(ValidLoc)','Type','Spearman')^2;
UnexplainedVarianceList{1,count} = 'Hunt';
%% Nayatani Brightness
ValidLoc_Model = find(isnan(BrightnessModel.Nayatani_Brightness)~=1);
ValidLoc = intersect(ValidLoc_Ranking,ValidLoc_Model);
figure;
hold on
for nPatch = 1:length(ValidLoc)
    plot(BrightnessModel.Nayatani_Brightness(ValidLoc(nPatch)),CubeRanking_All(ValidLoc(nPatch)),'.','MarkerSize',28,'LineWidth',1.5,'Color',linearRGB(ValidLoc(nPatch),:).^(1/2.2));
end
[corrCoef,p_val] = corr(CubeRanking_All(ValidLoc),BrightnessModel.Nayatani_Brightness(ValidLoc)','Type','Spearman');
ylabel('Rankings','FontSize',16);
title('Nayatani Brightness','FontSize',24);
text(min(BrightnessModel.Nayatani_Brightness(ValidLoc))*1.05,11,[num2str((1-corrCoef^2)*100),'%'],'FontSize',16);
set(gca,'FontSize',16)
set(gca,'LineWidth',2)
box off
axis square;
count = count+1;
UnexplainedVariance(1,count) = 1-corrCoef^2;
UnexplainedVariance_withMaxWeighted(1,count) = 1-corr(MwRGB(ValidLoc),BrightnessModel.Nayatani_Brightness(ValidLoc)','Type','Spearman')^2;
UnexplainedVarianceList{1,count} = 'Nayatani Brightness';
%% L*
ValidLoc_Model = find(isnan(BrightnessModel.Lstar)~=1);
ValidLoc = intersect(ValidLoc_Ranking,ValidLoc_Model);
figure;
hold on
for nPatch = 1:length(ValidLoc)
    plot(BrightnessModel.Lstar(ValidLoc(nPatch)),CubeRanking_All(ValidLoc(nPatch)),'.','MarkerSize',28,'LineWidth',1.5,'Color',linearRGB(ValidLoc(nPatch),:).^(1/2.2));
end
[corrCoef,p_val] = corr(CubeRanking_All(ValidLoc),BrightnessModel.Lstar(ValidLoc)','Type','Spearman');
ylabel('Rankings','FontSize',16);
title('L*','FontSize',24);
text(min(BrightnessModel.Lstar(ValidLoc))*1.05,11,[num2str((1-corrCoef^2)*100),'%'],'FontSize',16);
set(gca,'FontSize',16)
set(gca,'LineWidth',2)
box off
axis square;
count = count+1;
UnexplainedVariance(1,count) = 1-corrCoef^2;
UnexplainedVariance_withMaxWeighted(1,count) = 1-corr(MwRGB(ValidLoc),BrightnessModel.Lstar(ValidLoc)','Type','Spearman')^2;
UnexplainedVarianceList{1,count} = 'L*';

%% Guth
ValidLoc_Model = find(isnan(BrightnessModel.Guth_Luminance)~=1);
ValidLoc = intersect(ValidLoc_Ranking,ValidLoc_Model);
figure;
hold on
for nPatch = 1:length(ValidLoc)
    plot(BrightnessModel.Guth_Luminance(ValidLoc(nPatch)),CubeRanking_All(ValidLoc(nPatch)),'.','MarkerSize',28,'LineWidth',1.5,'Color',linearRGB(ValidLoc(nPatch),:).^(1/2.2));
end
[corrCoef,p_val] = corr(CubeRanking_All(ValidLoc),BrightnessModel.Guth_Luminance(ValidLoc)','Type','Spearman');
ylabel('Rankings','FontSize',16);
title('Guth Model','FontSize',24);
text(min(BrightnessModel.Guth_Luminance(ValidLoc))*1.05,11,[num2str((1-corrCoef^2)*100),'%'],'FontSize',16);
set(gca,'FontSize',16)
set(gca,'LineWidth',2)
box off
axis square;
count = count+1;
UnexplainedVariance(1,count) = 1-corrCoef^2;
UnexplainedVariance_withMaxWeighted(1,count) = 1-corr(MwRGB(ValidLoc),BrightnessModel.Guth_Luminance(ValidLoc)','Type','Spearman')^2;
UnexplainedVarianceList{1,count} = 'Guth'
corrCoef
%% CIE Brightness Matching (2 deg) Ikeda
ValidLoc_Model = find(isnan(BrightnessModel.CIEBrightnessMatching2Deg)~=1);
ValidLoc = intersect(ValidLoc_Ranking,ValidLoc_Model);
figure;
hold on
for nPatch = 1:length(ValidLoc)
    plot(BrightnessModel.CIEBrightnessMatching2Deg(ValidLoc(nPatch)),CubeRanking_All(ValidLoc(nPatch)),'.','MarkerSize',28,'LineWidth',1.5,'Color',linearRGB(ValidLoc(nPatch),:).^(1/2.2));
end
[corrCoef,p_val] = corr(CubeRanking_All(ValidLoc),BrightnessModel.CIEBrightnessMatching2Deg(ValidLoc),'Type','Spearman');
ylabel('Rankings','FontSize',16);
title('CIE Brightness Matching (2 deg)','FontSize',24);
text(min(BrightnessModel.CIEBrightnessMatching2Deg(ValidLoc))*1.05,11,[num2str((1-corrCoef^2)*100),'%'],'FontSize',16);
set(gca,'FontSize',16)
set(gca,'LineWidth',2)
box off
axis square;
count = count+1;
UnexplainedVariance(1,count) = 1-corrCoef^2;
UnexplainedVariance_withMaxWeighted(1,count) = 1-corr(MwRGB(ValidLoc),BrightnessModel.CIEBrightnessMatching2Deg(ValidLoc),'Type','Spearman')^2;
UnexplainedVarianceList{1,count} = 'CIE Brightness Matching';

%% Plot all unexplained variance
[SortUV,ID] = sort(UnexplainedVariance,'ascend');
SortUVList = UnexplainedVarianceList(1,ID);

%%%%%%% switch Loc of L* And Luminance, since they always have the same
%%%%%%% unexplained variance, so it does not matter for switching
LstarLoc = find(strcmp(SortUVList,'L*')==1);
LuminanceLoc = find(strcmp(SortUVList,'Luminance')==1);
SortUV([LstarLoc,LuminanceLoc]) = SortUV([LuminanceLoc,LstarLoc]);
SortUVList([LstarLoc,LuminanceLoc]) = SortUVList([LuminanceLoc,LstarLoc]);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

figure;
bar(1:length(SortUV),SortUV*100,0.8,'FaceColor',[0.3,0.3,0.3],'EdgeColor',[0,0,0],'FaceAlpha',0.2,'LineWidth',2)
box off;
xlim([0,length(SortUV)+0.5])
xticks(1:length(SortUV));
xticklabels(SortUVList)
ylim([0,50])
ylabel('Unexplained Variance (%)'); 
set(gca,'FontSize',18); 
set(gcf,'Position',[0,0,2000,800])
set(gca,'LineWidth',2);
set(gca,'FontSize',24)

end

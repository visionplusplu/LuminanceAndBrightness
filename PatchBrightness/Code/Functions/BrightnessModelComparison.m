function BrightnessModelComparison(PatchRanking,OptimalWeights,OptimalWeights_LMS,OptimalWeights_DKL,linearRGB,BrightnessModel,TestRetest_UV,FigIdList)
if length(size(PatchRanking)) == 2
    CubeRanking_All = mean(PatchRanking)';
elseif length(size(PatchRanking)) == 4
    CubeRanking_All = squeeze(nanmean(PatchRanking));
    CubeRanking_All = permute(CubeRanking_All, [3, 2, 1]);
    CubeRanking_All = CubeRanking_All(:);
end

ValidLoc_Ranking = find(isnan(CubeRanking_All)~=1);
count = 0;
%% Max-weighted RGB
MaxWeights = OptimalWeights.OptimalMaxWeight;
MwRGB_temp(1,:) = squeeze(linearRGB(:,1)*MaxWeights(1));
MwRGB_temp(2,:) = squeeze(linearRGB(:,2)*MaxWeights(2));
MwRGB_temp(3,:) = squeeze(linearRGB(:,3)*MaxWeights(3));
MwRGB = squeeze(max(squeeze(MwRGB_temp)))';

ValidLoc_Model = find(isnan(MwRGB)~=1);
ValidLoc = intersect(ValidLoc_Ranking,ValidLoc_Model);
count = count+1;
figure("Name",FigIdList{1,count},'NumberTitle','off');
hold on
for nPatch = 1:length(ValidLoc)
    plot(MwRGB(ValidLoc(nPatch)),CubeRanking_All(ValidLoc(nPatch)),'.','MarkerSize',28,'LineWidth',1.5,'Color',linearRGB(ValidLoc(nPatch),:).^(1/2.2));
end
[corrCoef,p_val] = corr(CubeRanking_All(ValidLoc),MwRGB(ValidLoc),'Type','Spearman');
xlabel('wMaxRGB','FontSize',16);
ylabel('Rankings','FontSize',16);
title('wMaxRGB','FontSize',24);
text(min(MwRGB(ValidLoc))*1.05,11,[num2str((1-corrCoef^2)*100),'%'],'FontSize',16);
set(gca,'FontSize',16)
set(gca,'LineWidth',2)
box off
axis square;
UnexplainedVariance(1,count) = 1-corrCoef^2;
UnexplainedVariance_withMaxWeighted(1,count) = 1-corr(MwRGB(ValidLoc),MwRGB(ValidLoc),'Type','Spearman')^2;
UnexplainedVarianceList{1,count} = 'wMaxRGB';

%% MaxRGB
if length(size(PatchRanking)) == 4
    MaxRGB_temp(1,:) = squeeze(linearRGB(:,1));
    MaxRGB_temp(2,:) = squeeze(linearRGB(:,2));
    MaxRGB_temp(3,:) = squeeze(linearRGB(:,3));
    MaxRGB = squeeze(max(squeeze(MaxRGB_temp)))';

    ValidLoc_Model = find(isnan(MaxRGB)~=1);
    ValidLoc = intersect(ValidLoc_Ranking,ValidLoc_Model);
    count = count+1;
    [corrCoef,p_val] = corr(CubeRanking_All(ValidLoc),MaxRGB(ValidLoc),'Type','Spearman');
    UnexplainedVariance(1,count) = 1-corrCoef^2;
    UnexplainedVarianceList{1,count} = 'MaxRGB';
end
%% Weighted maxDKL
MaxWeights_DKL = OptimalWeights_DKL.OptimalMaxWeight;
MwRGB_temp(1,:) = squeeze(BrightnessModel.NormalizedDKL(:,1)*MaxWeights_DKL(1));
MwRGB_temp(2,:) = squeeze(BrightnessModel.NormalizedDKL(:,2)*MaxWeights_DKL(2));
MwRGB_temp(3,:) = squeeze(BrightnessModel.NormalizedDKL(:,3)*MaxWeights_DKL(3));
MwRGB_DKL = squeeze(max(squeeze(MwRGB_temp)))';

ValidLoc_Model = find(isnan(MwRGB_DKL)~=1);
ValidLoc = intersect(ValidLoc_Ranking,ValidLoc_Model);
count = count+1;
figure("Name",FigIdList{1,count},'NumberTitle','off');
hold on
for nPatch = 1:length(ValidLoc)
    plot(MwRGB_DKL(ValidLoc(nPatch)),CubeRanking_All(ValidLoc(nPatch)),'.','MarkerSize',28,'LineWidth',1.5,'Color',linearRGB(ValidLoc(nPatch),:).^(1/2.2));
end
[corrCoef,p_val] = corr(CubeRanking_All(ValidLoc),MwRGB_DKL(ValidLoc),'Type','Spearman');
xlabel('wMaxDKL','FontSize',16);
ylabel('Rankings','FontSize',16);
title('wMaxDKL','FontSize',24);
text(min(MwRGB_DKL(ValidLoc))*1.05,11,[num2str((1-corrCoef^2)*100),'%'],'FontSize',16);
set(gca,'FontSize',16)
set(gca,'LineWidth',2)
box off
axis square;
UnexplainedVariance(1,count) = 1-corrCoef^2;
UnexplainedVarianceList{1,count} = 'wMaxDKL';

%% Weighted maxLMS
MaxWeights_LMS = OptimalWeights_LMS.OptimalMaxWeight;
MwRGB_temp(1,:) = squeeze(BrightnessModel.Normalizedlms(:,1)*MaxWeights_LMS(1));
MwRGB_temp(2,:) = squeeze(BrightnessModel.Normalizedlms(:,2)*MaxWeights_LMS(2));
MwRGB_temp(3,:) = squeeze(BrightnessModel.Normalizedlms(:,3)*MaxWeights_LMS(3));
MwRGB_LMS = squeeze(max(squeeze(MwRGB_temp)))';

ValidLoc_Model = find(isnan(MwRGB_LMS)~=1);
ValidLoc = intersect(ValidLoc_Ranking,ValidLoc_Model);
count = count+1;
figure("Name",FigIdList{1,count},'NumberTitle','off');
hold on
for nPatch = 1:length(ValidLoc)
    plot(MwRGB_LMS(ValidLoc(nPatch)),CubeRanking_All(ValidLoc(nPatch)),'.','MarkerSize',28,'LineWidth',1.5,'Color',linearRGB(ValidLoc(nPatch),:).^(1/2.2));
end
[corrCoef,p_val] = corr(CubeRanking_All(ValidLoc),MwRGB_LMS(ValidLoc),'Type','Spearman');
xlabel('wMaxLMS','FontSize',16);
ylabel('Rankings','FontSize',16);
title('wMaxLMS','FontSize',24);
text(min(MwRGB_LMS(ValidLoc))*1.05,11,[num2str((1-corrCoef^2)*100),'%'],'FontSize',16);
set(gca,'FontSize',16)
set(gca,'LineWidth',2)
box off
axis square;
UnexplainedVariance(1,count) = 1-corrCoef^2;
UnexplainedVarianceList{1,count} = 'wMaxLMS';


%% Sum-weighted
SumWeights = OptimalWeights.OptimalSumWeight;
SwRGB = linearRGB*SumWeights';

ValidLoc_Model = find(isnan(SwRGB)~=1);
ValidLoc = intersect(ValidLoc_Ranking,ValidLoc_Model);
count = count+1;
figure("Name",FigIdList{1,count},'NumberTitle','off');
hold on
for nPatch = 1:length(ValidLoc)
    plot(SwRGB(ValidLoc(nPatch)),CubeRanking_All(ValidLoc(nPatch)),'.','MarkerSize',28,'LineWidth',1.5,'Color',linearRGB(ValidLoc(nPatch),:).^(1/2.2));
end
[corrCoef,p_val] = corr(CubeRanking_All(ValidLoc),SwRGB(ValidLoc),'Type','Spearman');
ylabel('Rankings','FontSize',16);
title('Weighted SumRGB','FontSize',16);
text(min(SwRGB(ValidLoc))*1.05,11,[num2str((1-corrCoef^2)*100),'%'],'FontSize',16);
set(gca,'FontSize',16)
set(gca,'LineWidth',2)
box off
axis square;
UnexplainedVariance(1,count) = 1-corrCoef^2;
UnexplainedVarianceList{1,count} = 'Weighted SumRGB';


%% CAM16 (Dim)
ValidLoc_Model = find(isnan(BrightnessModel.CAM16_Q_Dim)~=1);
ValidLoc = intersect(ValidLoc_Ranking,ValidLoc_Model);
count = count+1;
figure("Name",FigIdList{1,count},'NumberTitle','off');
hold on
for nPatch = 1:length(ValidLoc)
    plot(BrightnessModel.CAM16_Q_Dim(ValidLoc(nPatch)),CubeRanking_All(ValidLoc(nPatch)),'.','MarkerSize',28,'LineWidth',1.5,'Color',linearRGB(ValidLoc(nPatch),:).^(1/2.2));
end
[corrCoef,p_val] = corr(CubeRanking_All(ValidLoc),BrightnessModel.CAM16_Q_Dim(ValidLoc),'Type','Spearman');
ylabel('Rankings','FontSize',16);
xlabel('Q (CAM16)','FontSize',16)
title('CAM16','FontSize',24);
text(min(BrightnessModel.CAM16_Q_Dim(ValidLoc))*1.05,11,[num2str((1-corrCoef^2)*100),'%'],'FontSize',16);
set(gca,'FontSize',16)
set(gca,'LineWidth',2)
box off
axis square;
UnexplainedVariance(1,count) = 1-corrCoef^2;
UnexplainedVarianceList{1,count} = 'Q - CAM16 (Dim)';


%% High Model
ValidLoc_Model = find(isnan(BrightnessModel.High)~=1);
ValidLoc = intersect(ValidLoc_Ranking,ValidLoc_Model);
count = count+1;
figure("Name",FigIdList{1,count},'NumberTitle','off');
hold on
for nPatch = 1:length(ValidLoc)
    plot(BrightnessModel.High(ValidLoc(nPatch)),CubeRanking_All(ValidLoc(nPatch)),'.','MarkerSize',28,'LineWidth',1.5,'Color',linearRGB(ValidLoc(nPatch),:).^(1/2.2));
end
[corrCoef,p_val] = corr(CubeRanking_All(ValidLoc),BrightnessModel.High(ValidLoc),'Type','Spearman');
xlabel('Model Prediction','FontSize',16)
ylabel('Rankings','FontSize',16);
title('High Model','FontSize',24);
text(min(BrightnessModel.High(ValidLoc))*1.05,11,[num2str((1-corrCoef^2)*100),'%'],'FontSize',16);
set(gca,'FontSize',16)
set(gca,'LineWidth',2)
box off
axis square;
UnexplainedVariance(1,count) = 1-corrCoef^2;
UnexplainedVarianceList{1,count} = 'High';

%% Farchild-Pirrotta Model
ValidLoc_Model = find(isnan(BrightnessModel.Farchild_Pirrotta)~=1);
ValidLoc = intersect(ValidLoc_Ranking,ValidLoc_Model);
count = count+1;
figure("Name",FigIdList{1,count},'NumberTitle','off');
hold on
for nPatch = 1:length(ValidLoc)
    plot(BrightnessModel.Farchild_Pirrotta(ValidLoc(nPatch)),CubeRanking_All(ValidLoc(nPatch)),'.','MarkerSize',28,'LineWidth',1.5,'Color',linearRGB(ValidLoc(nPatch),:).^(1/2.2));
end
[corrCoef,p_val] = corr(CubeRanking_All(ValidLoc),BrightnessModel.Farchild_Pirrotta(ValidLoc),'Type','Spearman');
xlabel('L^*^*','FontSize',16)
ylabel('Rankings','FontSize',16);
title('Farchild-Pirrotta Model','FontSize',24);
text(min(BrightnessModel.Farchild_Pirrotta(ValidLoc))*1.05,11,[num2str((1-corrCoef^2)*100),'%'],'FontSize',16);
set(gca,'FontSize',16)
set(gca,'LineWidth',2)
box off
axis square;
UnexplainedVariance(1,count) = 1-corrCoef^2;
UnexplainedVarianceList{1,count} = 'Farchild-Pirrotta';
%% Hellwig Model
ValidLoc_Model = find(isnan(BrightnessModel.HellwigHK_CAM16_Q_Dim)~=1);
ValidLoc = intersect(ValidLoc_Ranking,ValidLoc_Model);
count = count+1;
figure("Name",FigIdList{1,count},'NumberTitle','off');
hold on
for nPatch = 1:length(ValidLoc)
    plot(BrightnessModel.HellwigHK_CAM16_Q_Dim(ValidLoc(nPatch)),CubeRanking_All(ValidLoc(nPatch)),'.','MarkerSize',28,'LineWidth',1.5,'Color',linearRGB(ValidLoc(nPatch),:).^(1/2.2));
end
[corrCoef,p_val] = corr(CubeRanking_All(ValidLoc),BrightnessModel.HellwigHK_CAM16_Q_Dim(ValidLoc),'Type','Spearman');
xlabel('Model Prediction','FontSize',16)
ylabel('Rankings','FontSize',16);
title('Hellwig Model','FontSize',24);
text(min(BrightnessModel.HellwigHK_CAM16_Q_Dim(ValidLoc))*1.05,11,[num2str((1-corrCoef^2)*100),'%'],'FontSize',16);
set(gca,'FontSize',16)
set(gca,'LineWidth',2)
box off
axis square;
UnexplainedVariance(1,count) = 1-corrCoef^2;
UnexplainedVarianceList{1,count} = 'Hellwig';

%% In Park's paper
ValidLoc_Model = find(isnan(BrightnessModel.Park_Dim)~=1);
ValidLoc = intersect(ValidLoc_Ranking,ValidLoc_Model);
count = count+1;
figure("Name",FigIdList{1,count},'NumberTitle','off');
hold on
for nPatch = 1:length(ValidLoc)
    plot(BrightnessModel.Park_Dim(ValidLoc(nPatch)),CubeRanking_All(ValidLoc(nPatch)),'.','MarkerSize',28,'LineWidth',1.5,'Color',linearRGB(ValidLoc(nPatch),:).^(1/2.2));
end
[corrCoef,p_val] = corr(CubeRanking_All(ValidLoc),BrightnessModel.Park_Dim(ValidLoc),'Type','Spearman');
ylabel('Rankings','FontSize',16);
xlabel('Q','FontSize',16)
title('Park Model','FontSize',24);
text(min(BrightnessModel.Park_Dim(ValidLoc))*1.05,11,[num2str((1-corrCoef^2)*100),'%'],'FontSize',16);
set(gca,'FontSize',16)
set(gca,'LineWidth',2)
box off
axis square;
UnexplainedVariance(1,count) = 1-corrCoef^2;
UnexplainedVarianceList{1,count} = 'Park';

%% In Kim's 2025 paper
ValidLoc_Model = find(isnan(BrightnessModel.J_Dim_Kim_Original)~=1);
ValidLoc = intersect(ValidLoc_Ranking,ValidLoc_Model);
count = count+1;
figure("Name",FigIdList{1,count},'NumberTitle','off');
hold on
for nPatch = 1:length(ValidLoc)
    plot(BrightnessModel.J_Dim_Kim_Original(ValidLoc(nPatch)),CubeRanking_All(ValidLoc(nPatch)),'.','MarkerSize',28,'LineWidth',1.5,'Color',linearRGB(ValidLoc(nPatch),:).^(1/2.2));
end
[corrCoef,p_val] = corr(CubeRanking_All(ValidLoc),BrightnessModel.J_Dim_Kim_Original(ValidLoc),'Type','Spearman');
ylabel('Rankings','FontSize',16);
xlabel('J','FontSize',16)
title('Kim Model','FontSize',24);
text(min(BrightnessModel.J_Dim_Kim_Original(ValidLoc))*1.05,11,[num2str((1-corrCoef^2)*100),'%'],'FontSize',16);
set(gca,'FontSize',16)
set(gca,'LineWidth',2)
box off
axis square;
UnexplainedVariance(1,count) = 1-corrCoef^2;
UnexplainedVarianceList{1,count} = 'J-Kim';

%% In the sUCS and sCAM papers
ValidLoc_Model = find(isnan(BrightnessModel.Lightess_sUCS_sRGB)~=1);
ValidLoc = intersect(ValidLoc_Ranking,ValidLoc_Model);
count = count+1;
figure("Name",FigIdList{1,count},'NumberTitle','off');
hold on
for nPatch = 1:length(ValidLoc)
    plot(BrightnessModel.Lightess_sUCS_sRGB(ValidLoc(nPatch)),CubeRanking_All(ValidLoc(nPatch)),'.','MarkerSize',28,'LineWidth',1.5,'Color',linearRGB(ValidLoc(nPatch),:).^(1/2.2));
end
[corrCoef,p_val] = corr(CubeRanking_All(ValidLoc),BrightnessModel.Lightess_sUCS_sRGB(ValidLoc),'Type','Spearman');
xlabel('Lightness','FontSize',16);
ylabel('Rankings','FontSize',16);
title('sUCS','FontSize',24);  %%% in sUCS they used lightness, no brightness
text(min(BrightnessModel.Lightess_sUCS_sRGB(ValidLoc))*1.05,11,[num2str((1-corrCoef^2)*100),'%'],'FontSize',16);
set(gca,'FontSize',16)
set(gca,'LineWidth',2)
box off
axis square;
UnexplainedVariance(1,count) = 1-corrCoef^2;
UnexplainedVarianceList{1,count} = 'sUCS';

ValidLoc_Model = find(isnan(BrightnessModel.Q_sCAM_sRGB)~=1);
ValidLoc = intersect(ValidLoc_Ranking,ValidLoc_Model);
count = count+1;
figure("Name",FigIdList{1,count},'NumberTitle','off');
hold on
for nPatch = 1:length(ValidLoc)
    plot(BrightnessModel.Q_sCAM_sRGB(ValidLoc(nPatch)),CubeRanking_All(ValidLoc(nPatch)),'.','MarkerSize',28,'LineWidth',1.5,'Color',linearRGB(ValidLoc(nPatch),:).^(1/2.2));
end
[corrCoef,p_val] = corr(CubeRanking_All(ValidLoc),BrightnessModel.Q_sCAM_sRGB(ValidLoc),'Type','Spearman');
xlabel('Brightness','FontSize',16);
ylabel('Rankings','FontSize',16);
title('sCAM','FontSize',24); %%% in sCAM they used Q
text(min(BrightnessModel.Q_sCAM_sRGB(ValidLoc))*1.05,11,[num2str((1-corrCoef^2)*100),'%'],'FontSize',16);
set(gca,'FontSize',16)
set(gca,'LineWidth',2)
box off
axis square;
UnexplainedVariance(1,count) = 1-corrCoef^2;
UnexplainedVarianceList{1,count} = 'sCAM';

%% In the Liao et al papers, based on CAM16
ValidLoc_Model = find(isnan(BrightnessModel.L_star_byLiao)~=1);
ValidLoc = intersect(ValidLoc_Ranking,ValidLoc_Model);
count = count+1;
figure("Name",FigIdList{1,count},'NumberTitle','off');
hold on
for nPatch = 1:length(ValidLoc)
    plot(BrightnessModel.L_star_byLiao(ValidLoc(nPatch)),CubeRanking_All(ValidLoc(nPatch)),'.','MarkerSize',28,'LineWidth',1.5,'Color',linearRGB(ValidLoc(nPatch),:).^(1/2.2));
end
[corrCoef,p_val] = corr(CubeRanking_All(ValidLoc),BrightnessModel.L_star_byLiao(ValidLoc),'Type','Spearman');
xlabel('L^*','FontSize',16);
ylabel('Rankings','FontSize',16);
title('Liao et al Model (2024)','FontSize',24);  %%% in sUCS they used lightness, no brightness
text(min(BrightnessModel.L_star_byLiao(ValidLoc))*1.05,11,[num2str((1-corrCoef^2)*100),'%'],'FontSize',16);
set(gca,'FontSize',16)
set(gca,'LineWidth',2)
box off
axis square;
UnexplainedVariance(1,count) = 1-corrCoef^2;
UnexplainedVarianceList{1,count} = 'L* - Liao et al';

ValidLoc_Model = find(isnan(BrightnessModel.J_HK_byLiao)~=1);
ValidLoc = intersect(ValidLoc_Ranking,ValidLoc_Model);
count = count+1;
figure("Name",FigIdList{1,count},'NumberTitle','off');
hold on
for nPatch = 1:length(ValidLoc)
    plot(BrightnessModel.J_HK_byLiao(ValidLoc(nPatch)),CubeRanking_All(ValidLoc(nPatch)),'.','MarkerSize',28,'LineWidth',1.5,'Color',linearRGB(ValidLoc(nPatch),:).^(1/2.2));
end
[corrCoef,p_val] = corr(CubeRanking_All(ValidLoc),BrightnessModel.J_HK_byLiao(ValidLoc),'Type','Spearman');
xlabel('J(HK) ','FontSize',16);
ylabel('Rankings','FontSize',16);
title('Liao et al Model (2024)','FontSize',24);  %%% in sUCS they used lightness, no brightness
text(min(BrightnessModel.J_HK_byLiao(ValidLoc))*1.05,11,[num2str((1-corrCoef^2)*100),'%'],'FontSize',16);
set(gca,'FontSize',16)
set(gca,'LineWidth',2)
box off
axis square;
UnexplainedVariance(1,count) = 1-corrCoef^2;
UnexplainedVarianceList{1,count} = 'J - Liao et al';
%% Luminance
ValidLoc_Model = find(isnan(BrightnessModel.Luminance)~=1);
ValidLoc = intersect(ValidLoc_Ranking,ValidLoc_Model);
count = count+1;
figure("Name",FigIdList{1,count},'NumberTitle','off');
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
UnexplainedVariance(1,count) = 1-corrCoef^2;
UnexplainedVarianceList{1,count} = 'Luminance';
%% Radiance
ValidLoc_Model = find(isnan(BrightnessModel.Radiance)~=1);
ValidLoc = intersect(ValidLoc_Ranking,ValidLoc_Model);
count = count+1;
figure("Name",FigIdList{1,count},'NumberTitle','off');
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
UnexplainedVariance(1,count) = 1-corrCoef^2;
UnexplainedVarianceList{1,count} = 'Radiance';

%% Hunt
ValidLoc_Model = find(isnan(BrightnessModel.Hunt_Q_Norm)~=1);
ValidLoc = intersect(ValidLoc_Ranking,ValidLoc_Model);
count = count+1;
figure("Name",FigIdList{1,count},'NumberTitle','off');
hold on
for nPatch = 1:length(ValidLoc)
    plot(BrightnessModel.Hunt_Q_Norm(ValidLoc(nPatch)),CubeRanking_All(ValidLoc(nPatch)),'.','MarkerSize',28,'LineWidth',1.5,'Color',linearRGB(ValidLoc(nPatch),:).^(1/2.2));
end
[corrCoef,p_val] = corr(CubeRanking_All(ValidLoc),BrightnessModel.Hunt_Q_Norm(ValidLoc)','Type','Spearman');
ylabel('Rankings','FontSize',16);
xlabel('Model Prediction','FontSize',16)
title('Hunt Model','FontSize',24);
text(min(BrightnessModel.Hunt_Q_Norm(ValidLoc))*1.05,11,[num2str((1-corrCoef^2)*100),'%'],'FontSize',16);
set(gca,'FontSize',16)
set(gca,'LineWidth',2)
box off
axis square;
UnexplainedVariance(1,count) = 1-corrCoef^2;
UnexplainedVarianceList{1,count} = 'Hunt';
%% Nayatani Brightness
ValidLoc_Model = find(isnan(BrightnessModel.Nayatani_Brightness)~=1);
ValidLoc = intersect(ValidLoc_Ranking,ValidLoc_Model);
count = count+1;
figure("Name",FigIdList{1,count},'NumberTitle','off');
hold on
for nPatch = 1:length(ValidLoc)
    plot(BrightnessModel.Nayatani_Brightness(ValidLoc(nPatch)),CubeRanking_All(ValidLoc(nPatch)),'.','MarkerSize',28,'LineWidth',1.5,'Color',linearRGB(ValidLoc(nPatch),:).^(1/2.2));
end
[corrCoef,p_val] = corr(CubeRanking_All(ValidLoc),BrightnessModel.Nayatani_Brightness(ValidLoc)','Type','Spearman');
xlabel('Model Prediction','FontSize',16);
ylabel('Rankings','FontSize',16);
title('Nayatani Brightness','FontSize',24);
text(min(BrightnessModel.Nayatani_Brightness(ValidLoc))*1.05,11,[num2str((1-corrCoef^2)*100),'%'],'FontSize',16);
set(gca,'FontSize',16)
set(gca,'LineWidth',2)
box off
axis square;
UnexplainedVariance(1,count) = 1-corrCoef^2;
UnexplainedVarianceList{1,count} = 'Nayatani Brightness';
%% L*
ValidLoc_Model = find(isnan(BrightnessModel.Lstar)~=1);
ValidLoc = intersect(ValidLoc_Ranking,ValidLoc_Model);
count = count+1;
figure("Name",FigIdList{1,count},'NumberTitle','off');
hold on
for nPatch = 1:length(ValidLoc)
    plot(BrightnessModel.Lstar(ValidLoc(nPatch)),CubeRanking_All(ValidLoc(nPatch)),'.','MarkerSize',28,'LineWidth',1.5,'Color',linearRGB(ValidLoc(nPatch),:).^(1/2.2));
end
[corrCoef,p_val] = corr(CubeRanking_All(ValidLoc),BrightnessModel.Lstar(ValidLoc)','Type','Spearman');
xlabel('L^*','FontSize',16);
ylabel('Rankings','FontSize',16);
title('L*','FontSize',24);
text(min(BrightnessModel.Lstar(ValidLoc))*1.05,11,[num2str((1-corrCoef^2)*100),'%'],'FontSize',16);
set(gca,'FontSize',16)
set(gca,'LineWidth',2)
box off
axis square;
UnexplainedVariance(1,count) = 1-corrCoef^2;
UnexplainedVarianceList{1,count} = 'L*';

%% Guth
ValidLoc_Model = find(isnan(BrightnessModel.Guth_Luminance)~=1);
ValidLoc = intersect(ValidLoc_Ranking,ValidLoc_Model);
count = count+1;
figure("Name",FigIdList{1,count},'NumberTitle','off');
hold on
for nPatch = 1:length(ValidLoc)
    plot(BrightnessModel.Guth_Luminance(ValidLoc(nPatch)),CubeRanking_All(ValidLoc(nPatch)),'.','MarkerSize',28,'LineWidth',1.5,'Color',linearRGB(ValidLoc(nPatch),:).^(1/2.2));
end
[corrCoef,p_val] = corr(CubeRanking_All(ValidLoc),BrightnessModel.Guth_Luminance(ValidLoc)','Type','Spearman');
xlabel('Model Prediction','FontSize',16);
ylabel('Rankings','FontSize',16);
title('Guth Model','FontSize',24);
text(min(BrightnessModel.Guth_Luminance(ValidLoc))*1.05,11,[num2str((1-corrCoef^2)*100),'%'],'FontSize',16);
set(gca,'FontSize',16)
set(gca,'LineWidth',2)
box off
axis square;
UnexplainedVariance(1,count) = 1-corrCoef^2;
UnexplainedVarianceList{1,count} = 'Guth';

%% CIE Brightness Matching (2 deg) Ikeda
ValidLoc_Model = find(isnan(BrightnessModel.CIEBrightnessMatching2Deg)~=1);
ValidLoc = intersect(ValidLoc_Ranking,ValidLoc_Model);
count = count+1;
figure("Name",FigIdList{1,count},'NumberTitle','off');
hold on
for nPatch = 1:length(ValidLoc)
    plot(BrightnessModel.CIEBrightnessMatching2Deg(ValidLoc(nPatch)),CubeRanking_All(ValidLoc(nPatch)),'.','MarkerSize',28,'LineWidth',1.5,'Color',linearRGB(ValidLoc(nPatch),:).^(1/2.2));
end
[corrCoef,p_val] = corr(CubeRanking_All(ValidLoc),BrightnessModel.CIEBrightnessMatching2Deg(ValidLoc),'Type','Spearman');
xlabel('Model Prediction','FontSize',16);
ylabel('Rankings','FontSize',16);
xlabel('Model Prediction','FontSize',16)
title('CIE Brightness Matching','FontSize',24);
text(min(BrightnessModel.CIEBrightnessMatching2Deg(ValidLoc))*1.05,11,[num2str((1-corrCoef^2)*100),'%'],'FontSize',16);
set(gca,'FontSize',16)
set(gca,'LineWidth',2)
box off
axis square;
UnexplainedVariance(1,count) = 1-corrCoef^2;
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

figure("Name",FigIdList{1,end},'NumberTitle','off');
b = bar(1:length(SortUV),SortUV*100,0.8,...
    'FaceColor','flat',...
    'EdgeColor',[0,0,0],...
    'LineWidth',2);
b.CData = repmat([1 1 1],length(SortUV),1);
box off;
% Find indices
idxLum = find(strcmp(SortUVList,'Luminance'));
idxRad = find(strcmp(SortUVList,'Radiance'));
idxMax = find(strcmp(SortUVList,'wMaxRGB'));
% Set colors
if ~isempty(idxLum)
    b.CData(idxLum,:) = [0 0 0];        % black
end

if ~isempty(idxRad)
    b.CData(idxRad,:) = [0.5 0.5 0.5];  % mid gray
end

if ~isempty(idxMax)
    b.CData(idxMax,:) = [1 0 0];        % red
end
xlim([0,length(find(SortUV<0.4))+0.5])
xticks(1:length(SortUV));
xticklabels(SortUVList)
ylim([0,40])
ylabel('Unexplained Variance (%)'); 
set(gca,'FontSize',18); 
set(gcf,'Position',[0,0,2000,800])
set(gca,'LineWidth',2);
set(gca,'FontSize',24)
hold on;
if ~isempty (TestRetest_UV)
    title('Model Prediction (High Saturation)','FontSize',18)
    line([0,length(SortUV)+0.5],[TestRetest_UV,TestRetest_UV],'Color','black','LineStyle','--');
    text(length(SortUV)+0.5,TestRetest_UV,'Test-Rest','FontSize',12);
else
    title('Model Prediction (with Chroma Variation)','FontSize',18)
end
end

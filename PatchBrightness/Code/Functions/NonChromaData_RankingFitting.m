function NonChromaData_RankingFitting(path,SubjectValidId,RankingPlotTitle,LabOrProlific)
%% Remove the low catch trial accuracy participants
load (['./Results/nonChromaVariationExperiment/',path,'/AllSub.mat']);
if LabOrProlific==1
    SubjectID = cellfun(@str2double,AllSub.Name);
    ValidSubjectID = intersect(SubjectID,SubjectValidId);
    [InvalidSubjectID,InvalidSubject] = setdiff(SubjectID,ValidSubjectID);
else
    SubjectID = 1:length(AllSub.Name);
    [InvalidSubjectID,InvalidSubject] = setdiff(SubjectID,SubjectValidId);
end

AllSub.Name(InvalidSubject) = [];
AllSub.CatchTrialAcc(InvalidSubject) = [];
AllSub.RGBList(InvalidSubject,:,:,:) = [];
AllSub.RGBList(:,10:10:60,:,:) = [];
ValidSubjectNumber = length(AllSub.CatchTrialAcc);
% save (['./Results/nonChromaVariationExperiment/',path,'/AllSub_CatchTrialPassed.mat'],"AllSub");

%% Corrected RGB of 144 color patches in Piloting Display's space
load (['./ColorPatchMetric/AllCubes_144.mat']); %% The LinearRGB of 144 color patches
GAMMAS = [2.1452 2.1489 2.0831]; % MT 20/1/20
rgamma = GAMMAS(1);ggamma=GAMMAS(2);bgamma=GAMMAS(3);

corrRGB(:,:,1) = uint8(AllCubes(:,:,1).^(1/rgamma).*255);
corrRGB(:,:,2) = uint8(AllCubes(:,:,2).^(1/ggamma).*255);
corrRGB(:,:,3) = uint8(AllCubes(:,:,3).^(1/bgamma).*255);  
corrRGB_reshaped = reshape(corrRGB, [], 3);  % Now A_reshaped is a 144x3 matrix

%% Align the patches in each trial to 144 array
for Subject = 1:ValidSubjectNumber
    RGBList = squeeze(AllSub.RGBList(Subject,:,:,:));
    PatchRanking = cell(144,1);
    for nTrial = 1:size(RGBList,1)
        ThisTrialRGB = squeeze(RGBList(nTrial,:,:));
        [isInA, location] = ismember(ThisTrialRGB, corrRGB_reshaped, 'rows');
        for nPatch = 1:12
            PatchRanking{location(nPatch)} = [PatchRanking{location(nPatch)},13-nPatch];
        end
    end
    ThisParticipantRanking = reshape(cellfun(@mean,PatchRanking),[12,12]);
    AllSub.PatchRanking_allParticipant(Subject,:) = ThisParticipantRanking(:); 
    %%%% One patch wasnt tested, so we interpolated the rankings of it %%%%
    LeftRatio = ThisParticipantRanking(4,2)/ThisParticipantRanking(5,2);
    RightRatio = ThisParticipantRanking(6,2)/ThisParticipantRanking(5,2);
    ThisParticipantRanking(5,1) = (ThisParticipantRanking(4,1)/LeftRatio+ThisParticipantRanking(6,1)/RightRatio)/2;
    AllSub.PatchRanking_allParticipant_InterPolate(Subject,:) = ThisParticipantRanking(:);
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
end
save (['./Results/nonChromaVariationExperiment/',path,'/AllSub_CatchTrialPassed.mat'],"AllSub");


%% Averaged Rankings
MeanRanking  = mean(AllSub.PatchRanking_allParticipant_InterPolate)';
MeanRanking_reshaped = reshape(MeanRanking,[12,12]);
%% Plot Ranking
if ismember(path,['LaboratoryTest','LaboratoryRetest','HomeTest','ProlificTest'])
    figure;
    hold on
    for nInt = 1:12
        plot(1:12,squeeze(MeanRanking_reshaped(:,nInt)),'-','Color',[0.7,0.7,0.7],'LineWidth',1)
        for nHue = 1:12
            plot(nHue,MeanRanking_reshaped(nHue,nInt),'s','MarkerSize',18,'MarkerFaceColor',squeeze(corrRGB(nHue,nInt,:)),'MarkerEdgeColor',squeeze(corrRGB(nHue,nInt,:)))
        end
    end
    box off;
    xlim([0,13])
    ylim([1,12])
    xticks([]);
    ylabel('Mean Ranking');
    title(RankingPlotTitle)
    set(gca,'FontSize',18);
    set(gca,'LineWidth',2);
    set(gcf,'Position',[0,0,400,400])
end

%% DNN plots
if strcmp(path,'LaboratoryTest')
    DNNpath = ['./Results/nonChromaVariationExperiment/',path,'/DNN'];
    DNN_Fig(DNNpath,MeanRanking,corrRGB);
end

%% load OLED color appearance
load (['./OLEDparas/oled_weights.mat']); %% RGB contribution to luminance and radiance
load (['./OLEDparas/oled_gammas.mat']);
load (['./OLEDparas/oled_rgb_mode.mat']);

%% Align the corrRGB to OledRGB
OledRGB.cube(:,:,1) = (double(corrRGB(:,:,1))/255).^oled_gammas(1);
OledRGB.cube(:,:,2) = (double(corrRGB(:,:,2))/255).^oled_gammas(2);
OledRGB.cube(:,:,3) = (double(corrRGB(:,:,3))/255).^oled_gammas(3);
cubeRGBs4Fitting = OledRGB.cube;
save (['./Results/nonChromaVariationExperiment/',path,'/OledRGB.mat'],"OledRGB");

%% FitWeights
if exist(['./Results/nonChromaVariationExperiment/',path,'/WeightFitting.mat']) ~=2
    WeightFitting = FitWeights(cubeRGBs4Fitting,MeanRanking,AllSub.PatchRanking_allParticipant_InterPolate,RankingPlotTitle);
    save (['./Results/nonChromaVariationExperiment/',path,'/WeightFitting.mat'],"WeightFitting");
else
    RGB_weights_rad = round(oled_weights.RadWeight*100);
    RGB_weights_lum = round(oled_weights.LumWeight*100);
    load (['./Results/nonChromaVariationExperiment/',path,'/WeightFitting.mat'])
      Allweight = 0:0.02:5;
    nsteps = length(Allweight);
    count = 0;
    for  g= 1:nsteps
        for b = 1:nsteps
            count = count + 1;
            wG = Allweight(g);
            wB = Allweight(b);
            WeightList(count,:) = [1,wG,wB];
        end
    end
    WeightMat = WeightFitting.meanFit.MaxWeightMap;
    OptimalWeight_individual = WeightFitting.individualFit.OptimalMaxWeight;
    OptimalWeight_mean = WeightFitting.meanFit.OptimalMaxWeight;
    if strcmp(path,'LaboratoryTest')
        WeightHeatMap(['Max-Weighted Map (',RankingPlotTitle,')'],Allweight,WeightList,WeightMat,OptimalWeight_individual,OptimalWeight_mean,RGB_weights_rad,RGB_weights_lum);
    end
end

%% Fit the weights of Minkovski metric
if strcmp(path,'LaboratoryTest')
    FitExponent(cubeRGBs4Fitting,MeanRanking,WeightFitting.meanFit.OptimalMaxWeight);
end

%% Comparison across Displays
if strcmp(path,'LaboratoryTest')
    caliPath = ['../RawData/nonChromaVariationExperiment/Displays/'];
    DisplayComparison(corrRGB,caliPath,oled_weights,cubeRGBs4Fitting,WeightFitting.meanFit.OptimalSumWeight,WeightFitting.meanFit.OptimalMaxWeight,AllSub.Name);
end

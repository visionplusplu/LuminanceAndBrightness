function ChromaData_RankingFitting(path,SubjectValidId,RankingPlotTitle,LabOrProlific)
%% Remove the low catch trial accuracy participants
load (['./Results/ChromaVariationExperiment/',path,'/AllSub.mat']);
if LabOrProlific==1
    SubjectID = AllSub.Name;
    ValidSubjectID = intersect(SubjectID,SubjectValidId);
    [InvalidSubjectID,InvalidSubject] = setdiff(SubjectID,ValidSubjectID);
else
    SubjectID = 1:length(AllSub.Name);
    [InvalidSubjectID,InvalidSubject] = setdiff(SubjectID,SubjectValidId);
end

AllSub.Name(InvalidSubject) = [];
AllSub.CatchTrialAcc(InvalidSubject) = [];
AllSub.RGBList(InvalidSubject,:,:,:) = [];
ValidSubjectNumber = length(AllSub.CatchTrialAcc);
% save (['./Results/ChromaVariationExperiment/',path,'/AllSub_CatchTrialPassed.mat'],"AllSub");

%% Corrected RGB of 732 color patches in Piloting Display's space
load (['./ColorPatchMetric/AllCubes_732.mat']); %% The LinearRGB of 864 color patches
GAMMAS = [2.2 2.2 2.2]; % MT 20/1/20
rgamma = GAMMAS(1);ggamma=GAMMAS(2);bgamma=GAMMAS(3);

corrRGB(:,1) = uint8(AllCubes(:,1).^(1/rgamma).*255);
corrRGB(:,2) = uint8(AllCubes(:,2).^(1/ggamma).*255);
corrRGB(:,3) = uint8(AllCubes(:,3).^(1/bgamma).*255);  
corrRGB_reshaped = corrRGB;  % Now A_reshaped is a 864x3 matrix

%% Align the patches in each trial to 732 array
idx_allPair = [];
for Subject = 1:ValidSubjectNumber
    RGBList = squeeze(AllSub.RGBList(Subject,:,:,:));
    PatchRanking = cell(12,12,6);
    for nTrial = 1:size(RGBList,1)
        for nPatch = 1:12
            ThisPatchRGB = squeeze(RGBList(nTrial,nPatch,:))';
            [isInA, location] = ismember(ThisPatchRGB, corrRGB_reshaped, 'rows');
            ChromaList = AllCubes_HueIntCh(location,3);
            HueList = AllCubes_HueIntCh(location,1);
            IntList = AllCubes_HueIntCh(location,2);
            PatchRanking{HueList,IntList,ChromaList+1} = [PatchRanking{HueList,IntList,ChromaList+1},13-nPatch];
        end
        if strcmp(path,'LaboratoryTest')  %% Then making choice in to pairs, and caculate the each patch's equi-bright gray
            PairsComb = nchoosek(1:12,2);
            [IsIncluded, idx] = ismember(squeeze(RGBList(nTrial,:,:)), corrRGB_reshaped, 'rows');
            idx_List = idx(PairsComb);
            idx_allPair = [idx_allPair;idx_List];
        end
    end
    ThisParticipantRanking = cellfun(@nanmean,PatchRanking);
    AllSub.PatchRanking_allParticipant(Subject,:,:,:) = ThisParticipantRanking;
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
end
save (['./Results/ChromaVariationExperiment/',path,'/AllSub_CatchTrialPassed.mat'],"AllSub");


%% Averaged Rankings
MeanRanking  = squeeze(nanmean(AllSub.PatchRanking_allParticipant));
MeanRanking_reshaped = MeanRanking;

%% Plot Ranking
if strcmp(path,'LaboratoryTest')
    figure;
    hold on
    countX = 0;
    for nChroma = 1:6
        countX = countX+3;
        if nChroma == 1
            for nInt = 1:12
                [isInA, locationRGB] = ismember([1,nInt,nChroma-1], AllCubes_HueIntCh, 'rows');
                plot(countX,MeanRanking_reshaped(1,nInt,nChroma),'s','MarkerSize',12,'MarkerFaceColor',squeeze(double(corrRGB_reshaped(locationRGB,:)))/255,'MarkerEdgeColor',[0,0,0]);
            end
        else
            for nInt = 1:12
                plot(countX:countX+11,squeeze(MeanRanking_reshaped(:,nInt,nChroma)),'-','Color',[0.7,0.7,0.7],'LineWidth',1)
                for nHue = 1:12
                    [isInA, locationRGB] = ismember([nHue,nInt,nChroma-1], AllCubes_HueIntCh, 'rows');
                    plot(countX+nHue-1,MeanRanking_reshaped(nHue,nInt,nChroma),'s','MarkerSize',12,'MarkerFaceColor',squeeze(double(corrRGB_reshaped(locationRGB,:)))/255,'MarkerEdgeColor',squeeze(double(corrRGB_reshaped(locationRGB,:)))/255)
                end
            end
        end
        if nChroma ==1
            countX = countX+1;
        else
            countX = countX+12;
        end
    end
    box off;
    ylim([1,12])
    xticks([]);
    xlabel('Increased Chroma');
    ylabel('Mean Ranking');
    title(RankingPlotTitle)
    set(gca,'FontSize',18);
    set(gca,'LineWidth',2);
    set(gcf,'Position',[0,0,2400,400])
end

%% load OLED color appearance
load (['./OLEDparas/oled_weights.mat']); %% RGB contribution to luminance and radiance
load (['./OLEDparas/oled_gammas.mat']);
load (['./OLEDparas/oled_rgb_mode.mat']);

%% Align the corrRGB to OledRGB
OledRGB.cube(:,1) = (double(corrRGB(:,1))/255).^oled_gammas(1);
OledRGB.cube(:,2) = (double(corrRGB(:,2))/255).^oled_gammas(2);
OledRGB.cube(:,3) = (double(corrRGB(:,3))/255).^oled_gammas(3);
cubeRGBs4Fitting = OledRGB.cube;
save (['./Results/ChromaVariationExperiment/',path,'/OledRGB.mat'],"OledRGB");

%% Calculate the relative Gray
PatchLum= cubeRGBs4Fitting*oled_weights.LumWeight';
if strcmp(path,'LaboratoryTest')  %% Then making choice in to pairs, and caculate the each patch's equi-bright gray
    if exist(['./Results/ChromaVariationExperiment/',path,'/PSE_gray.mat']) == 2
        load (['./Results/ChromaVariationExperiment/',path,'/PSE_gray.mat']);
        load (['./Results/ChromaVariationExperiment/',path,'/GrayFitPara.mat']);
        [GrayFitPara,PSE_gray] = CompareRankingRelativeGray(idx_allPair,AllCubes_HueIntCh,MeanRanking,corrRGB,PatchLum,PSE_gray,GrayFitPara);
    else
        [GrayFitPara,PSE_gray] = CompareRankingRelativeGray(idx_allPair,AllCubes_HueIntCh,MeanRanking,corrRGB,PatchLum,[],[]);
        save (['./Results/ChromaVariationExperiment/',path,'/PSE_gray.mat'],"PSE_gray");
        save (['./Results/ChromaVariationExperiment/',path,'/GrayFitPara.mat'],"GrayFitPara");
    end
end


%% FitWeights
if exist(['./Results/ChromaVariationExperiment/',path,'/WeightFitting.mat'])~=2
    WeightFitting = FitWeights(cubeRGBs4Fitting,MeanRanking,AllSub.PatchRanking_allParticipant,RankingPlotTitle);
    save (['./Results/ChromaVariationExperiment/',path,'/WeightFitting.mat'],"WeightFitting");
else
    RGB_weights_rad = round(oled_weights.RadWeight*100);
    RGB_weights_lum = round(oled_weights.LumWeight*100);
    load (['./Results/ChromaVariationExperiment/',path,'/WeightFitting.mat']);
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
OptimalMaxLoc = find(WeightFitting.meanFit.MaxWeightMap == max(WeightFitting.meanFit.MaxWeightMap));

if strcmp(path,'LaboratoryTest')
    ThisChromaPatch = find(AllCubes_HueIntCh(:,3) == 0);
    PatchLum = cubeRGBs4Fitting(ThisChromaPatch,:)*oled_weights.LumWeight';
    PatchRad = cubeRGBs4Fitting(ThisChromaPatch,:)*oled_weights.RadWeight';
    ThisMeanRanking = MeanRanking_reshaped(1,:,1);
    PatchLum(1:12),ThisMeanRanking(:)
    [corrCoef,p_val] = corr(PatchLum(1:12),ThisMeanRanking(:),'Type','Spearman');
    Corr2.Lum(1) = corrCoef;
    [corrCoef,p_val] = corr(PatchRad(1:12),ThisMeanRanking(:),'Type','Spearman');
    Corr2.Rad(1) = corrCoef;
    Corr2.MaxWeighted_R2(1) = Corr2.Lum(1);
    for nChroma = 1:5
        ThisChromaPatch = find(AllCubes_HueIntCh(:,3) == nChroma);
        PatchLum= cubeRGBs4Fitting(ThisChromaPatch,:)*oled_weights.LumWeight';
        PatchRad = cubeRGBs4Fitting(ThisChromaPatch,:)*oled_weights.RadWeight';
        ThisMeanRanking = MeanRanking_reshaped(:,:,nChroma+1);
        PermuteThisMeanRanking = ThisMeanRanking';
        PermuteThisMeanRanking = PermuteThisMeanRanking(:);
        ValidLoc = find(isnan(PermuteThisMeanRanking)~=1);
        PatchLum = PatchLum(:);
        PatchRad = PatchRad(:);
        if exist(['./Results/ChromaVariationExperiment/',path,'/WeightFitting_5Chromas.mat'])~=2
            WeightFitting_5Chromas(1,nChroma) = FitWeights(cubeRGBs4Fitting(ThisChromaPatch,:),ThisMeanRanking,AllSub.PatchRanking_allParticipant(:,:,:,nChroma+1),strcat(RankingPlotTitle,' Chroma:',num2str(nChroma)));
        else
            load (['./Results/ChromaVariationExperiment/',path,'/WeightFitting_5Chromas.mat']);
        end
        [corrCoef,p_val] = corr(PatchLum(ValidLoc),PermuteThisMeanRanking(ValidLoc),'Type','Spearman')
        Corr2.Lum(nChroma+1) = corrCoef;
        [corrCoef,p_val] = corr(PatchRad(ValidLoc),PermuteThisMeanRanking(ValidLoc),'Type','Spearman');
        Corr2.Rad(nChroma+1) = corrCoef;
        Corr2.MaxWeighted_R2(nChroma+1) = WeightFitting_5Chromas(1,nChroma).meanFit.MaxWeightMap(OptimalMaxLoc(1));
        OptimalMaxWeight_5Chromas(nChroma,:) = WeightFitting_5Chromas(1,nChroma).meanFit.OptimalMaxWeight;
    end
    Corr = Corr2;
    save (['./Results/ChromaVariationExperiment/',path,'/WeightFitting_5Chromas.mat'],"WeightFitting_5Chromas","Corr");


    %%%%%%%%%%%%%%% Plot %%%%%%%%%%%%%%%
    LumColor = [62,145,77]/255;
    RadColor = [31,52,188]/255;
    MWColor = [255,0,0]/255;
    figure;
    hold on
    plot(1:6,(1-Corr.Lum.^2)*100,'o-','Color',LumColor,'MarkerEdgeColor',LumColor,'MarkerFaceColor',LumColor,'MarkerSize',16,'LineWidth',3)
    xlim([0.5,6.5])
    xticks([])
    ylim([0 50])
    ylabel('Unexplained Variance (%)');
    xlabel('Chroma Increasing');
    set(gca,'FontSize',20);
    set(gca,'LineWidth',3);
    set(gcf,'Position',[0,0,500,400])
    box off;
    plot(1:6,(1-Corr.Rad.^2)*100,'o-','Color',RadColor,'MarkerEdgeColor',RadColor,'MarkerFaceColor',RadColor,'MarkerSize',16,'LineWidth',3)
    plot(1:6,(1-Corr.MaxWeighted_R2)*100,'o-','Color',MWColor,'MarkerEdgeColor',MWColor,'MarkerFaceColor',MWColor,'MarkerSize',16,'LineWidth',3)
    legend({'Luminance','Radiance','Max-weighted RGB'},'Box','off','FontSize',16)
    %%%%%%%%%%%%%%% Plot MaxWeight Triangle %%%%%%%%%%%%%
    dot_colors = [
        1, 0.8, 1;
        1, 0.6, 1;
        1, 0.4, 1;
        1, 0.2, 1;
        1, 0, 1];
    labels = {
        'Chroma 1',
        'Chroma 2',
        'Chroma 3',
        'Chroma 4',
        'Chroma 5'};
    WeightTrianglePlot(oled_weights.LumWeight,oled_weights.RadWeight,OptimalMaxWeight_5Chromas,dot_colors,labels);
end


% % % % %% Fit the weights of Minkovski metric
% % % % if strcmp(path,'LaboratoryTest')
% % % %     FitExponent(cubeRGBs4Fitting,MeanRanking,WeightFitting.meanFit.OptimalMaxWeight);
% % % % end

%% Comparison across Displays
if strcmp(path,'LaboratoryTest')
    caliPath = ['../RawData/ChromaVariationExperiment/Displays/'];
    DisplayComparison(corrRGB,caliPath,oled_weights,cubeRGBs4Fitting,WeightFitting.meanFit.OptimalSumWeight,WeightFitting.meanFit.OptimalMaxWeight,AllSub.Name);
end

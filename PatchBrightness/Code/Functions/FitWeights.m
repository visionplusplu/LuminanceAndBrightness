function WeightFitting = FitWeights(cubeRGBs4Fitting,MeanRanking,IndividualRanking,PlotTitle)
%% Weight Fitting
Allweight= 0:0.02:5;
nsteps = length(Allweight);
count = 0;
for  g= 1:nsteps
    for b = 1:nsteps
        count = count + 1;
        wG = Allweight(g);
        wB = Allweight(b);
        WeightList(count,:) = [1,wG,wB];
        weights = [1,wG,wB]
        if length(size(cubeRGBs4Fitting)) == 3   %%% Non-chroma Variation Experiment
            MwRGB_temp(1,:,:) = squeeze(cubeRGBs4Fitting(:,:,1)*weights(1));
            MwRGB_temp(2,:,:) = squeeze(cubeRGBs4Fitting(:,:,2)*weights(2));
            MwRGB_temp(3,:,:) = squeeze(cubeRGBs4Fitting(:,:,3)*weights(3));
            MwRGB = squeeze(max(squeeze(MwRGB_temp)));
            SwRGB = squeeze(cubeRGBs4Fitting(:,:,1)*weights(1)+cubeRGBs4Fitting(:,:,2)*weights(2)+cubeRGBs4Fitting(:,:,3)*weights(3));
        elseif length(size(cubeRGBs4Fitting)) == 2 %%% Chroma Variation Experiment
            MwRGB_temp(1,:) = squeeze(cubeRGBs4Fitting(:,1)*weights(1));
            MwRGB_temp(2,:) = squeeze(cubeRGBs4Fitting(:,2)*weights(2));
            MwRGB_temp(3,:) = squeeze(cubeRGBs4Fitting(:,3)*weights(3));
            MwRGB = squeeze(max(squeeze(MwRGB_temp)))';
            SwRGB = squeeze(cubeRGBs4Fitting(:,1)*weights(1)+cubeRGBs4Fitting(:,2)*weights(2)+cubeRGBs4Fitting(:,3)*weights(3));
        end

        %%%%%%%%%%%%%%%%% Fit individual participant %%%%%%%%%%%%%%%%%%%%%%
        for Subject = 1:size(IndividualRanking,1)
            if length(size(cubeRGBs4Fitting)) == 3   %%% Non-chroma Variation Experiment
                Ranking  = squeeze(IndividualRanking(Subject,:))';

                %%%% sum-weighted RGB
                [corrCoef,p_val] = corr(Ranking,SwRGB(:),'Type','Spearman');
                Corr_SumWeighted(Subject,count) = corrCoef;

                %%%% max-weighted RGB
                [corrCoef,p_val] = corr(Ranking,MwRGB(:),'Type','Spearman');
                Corr_MaxWeighted(Subject,count) = corrCoef;


            elseif length(size(cubeRGBs4Fitting)) == 2 %%% Chroma Variation Experiment
                Ranking  = squeeze(IndividualRanking(Subject,:,:,:));
                Ranking_permuted = permute(Ranking, [3, 2, 1]);
                Ranking_permuted  = Ranking_permuted(:);
                ValidLoc = find(~isnan(Ranking_permuted));

                %%%% sum-weighted RGB
                [corrCoef,p_val] = corr(Ranking_permuted(ValidLoc),SwRGB(ValidLoc),'Type','Spearman');
                Corr_SumWeighted(Subject,count) = corrCoef;

                %%%% max-weighted RGB
                [corrCoef,p_val] = corr(Ranking_permuted(ValidLoc),MwRGB(ValidLoc),'Type','Spearman');
                Corr_MaxWeighted(Subject,count) = corrCoef;
            end
        end
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

        %%%%%%%%%%%%%%%%%%%%%%%%%% Fit mean %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        if length(size(cubeRGBs4Fitting)) == 3   %%% Non-chroma Variation Experiment
            %%%% sum-weighted RGB
            [corrCoef,p_val] = corr(MeanRanking,SwRGB(:),'Type','Spearman');
            Corr_SumWeighted_meanRanking(count) = corrCoef;

            %%%% max-weighted RGB
            [corrCoef,p_val] = corr(MeanRanking,MwRGB(:),'Type','Spearman');
            Corr_MaxWeighted_meanRanking(count) = corrCoef;
        elseif length(size(cubeRGBs4Fitting)) == 2 %%% Chroma Variation Experiment
            MeanRanking_permuted = permute(MeanRanking, [3, 2, 1]);
            MeanRanking_permuted  = MeanRanking_permuted(:);
            ValidLoc = find(~isnan(MeanRanking_permuted));
            %%%% sum-weighted RGB
            [corrCoef,p_val] = corr(MeanRanking_permuted(ValidLoc),SwRGB(ValidLoc),'Type','Spearman');
            Corr_SumWeighted_meanRanking(count) = corrCoef;

            %%%% max-weighted RGB
            [corrCoef,p_val] = corr(MeanRanking_permuted(ValidLoc),MwRGB(ValidLoc),'Type','Spearman');
            Corr_MaxWeighted_meanRanking(count) = corrCoef;
        end
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    end
end

%%%%%%%%%%%%%%%%% Individual optimal weights %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
for Subject = 1:size(IndividualRanking,1)
    SumWeighted_List = Corr_SumWeighted(Subject,:).^2; %% Sum-weight
    MaxWeighted_List = Corr_MaxWeighted(Subject,:).^2; %% Max-weight
    [SumWeighted_High,Loc1] = max(SumWeighted_List); %% Sum-weight
    [MaxWeighted_High,Loc2] = max(MaxWeighted_List); %% Max-weight
    WeightFitting.individualFit.Corr_SumWeightRGB(Subject) = SumWeighted_High; %% Sum-weight
    WeightFitting.individualFit.Corr_MaxWeightRGB(Subject) = MaxWeighted_High; %% Max-weight
    WeightFitting.individualFit.OptimalSumWeight(Subject,:) = WeightList(Loc1,:); %% Sum-weight
    WeightFitting.individualFit.OptimalMaxWeight(Subject,:) = WeightList(Loc2,:); %% Max-weight
end

%%%%%%%%%%%%%%%%% Population Optimal Weights %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
MeanCorr1 = Corr_SumWeighted_meanRanking.^2; %% Sum-weight
MeanCorr2 = Corr_MaxWeighted_meanRanking.^2; %% Max-weight
[SumWeighted_High,Loc1] = max(MeanCorr1); %% Sum-weight
[MaxWeighted_High,Loc2] = max(MeanCorr2); %% Max-weight
WeightFitting.meanFit.Corr_SumWeightRGB = SumWeighted_High;%% Sum-weight
WeightFitting.meanFit.Corr_MaxWeightRGB = MaxWeighted_High; %% Max-weight
WeightFitting.meanFit.OptimalSumWeight = WeightList(Loc1,:); %% Sum-weight
WeightFitting.meanFit.OptimalMaxWeight = WeightList(Loc2,:); %% Max-weight
WeightFitting.meanFit.SumWeightMap = MeanCorr1; %% Sum-weight
WeightFitting.meanFit.MaxWeightMap = MeanCorr2; %% Max-weight


%% Make A heatmap plot
load ./OLEDparas/oled_weights.mat;
RGB_weights_rad = round(oled_weights.RadWeight*100);
RGB_weights_lum = round(oled_weights.LumWeight*100);
WeightMat = WeightFitting.meanFit.MaxWeightMap;
OptimalWeight_individual = WeightFitting.individualFit.OptimalMaxWeight;
OptimalWeight_mean = WeightFitting.meanFit.OptimalMaxWeight;
WeightHeatMap(['Max-Weighted Map (',PlotTitle,')'],Allweight,WeightList,WeightMat,OptimalWeight_individual,OptimalWeight_mean,RGB_weights_rad,RGB_weights_lum);
end
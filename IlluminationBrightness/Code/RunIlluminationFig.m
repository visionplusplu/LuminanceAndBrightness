clear;clc

%% Load Data
load  ../RawData/LightingData.mat;

%% Set Paras
wavelength = 380:780;

%% Convert to an RGB tripartition (482.65 nm, 565.43 nm)
% Followed Koenderink, J., Doorn, A. v. & Gegenfurtner, K. Colors and things (2020)
AreaBlue = find(wavelength<482.65);
AreaGreen = intersect(find(wavelength<565.43),find(wavelength>482.65));
AreaRed = find(wavelength>565.43);

LightingData.linearRGB(:,:,:,1) = sum(LightingData.spectra(:,:,:,AreaBlue),4);
LightingData.linearRGB(:,:,:,2) = sum(LightingData.spectra(:,:,:,AreaGreen),4);
LightingData.linearRGB(:,:,:,3) = sum(LightingData.spectra(:,:,:,AreaRed),4);

%% Calculate Luminance, Radiance, Melanopsin Excitation
load ./Paras/PhotoreceptorSpectralSensitivity.mat;
[wavelengthCIE x_bar y_bar z_bar]=textread('./Paras/ciexyz31_1.txt', '', 'delimiter', ',');
wavelengthTarget = [find(wavelengthCIE == wavelength(1)):find(wavelengthCIE == wavelength(end))];

LightingData.radiance = squeeze(sum(LightingData.spectra,4))*1000;
LightingData.melanopsin = sum(LightingData.spectra.*reshape(PhotoreceptorSpectralSensitivity(:,6),1,1,1,401),4)*1000;
LightingData.luminance = sum(LightingData.spectra.*reshape(y_bar(wavelengthTarget),1,1,1,401),4)*683;


%% Optimal Weight Fitting
Allweight= 0:0.02:5;
nsteps = length(Allweight);

if exist('MaxWeights') ~= 1
    count = 0;
    for g= 1:nsteps
        for b = 1:nsteps
            count = count + 1;
            wG = Allweight(g);
            wB = Allweight(b);
            [1,wG,wB]
            weightList(count,:) = [1,wG,wB];
            weights = repmat([1,wG,wB],size(LightingData.linearRGB,2),1);

            for subject = 1:size(LightingData.linearRGB,1)
                RGB_a = squeeze(LightingData.linearRGB(subject,:,1,:));
                RGB_b = squeeze(LightingData.linearRGB(subject,:,2,:));
                Resp = LightingData.choice(subject,:);%%1:Left -1:Right
                Resp(find(Resp==-1)) = 2;

                RGB_withWeights_a = RGB_a.*weights;
                RGB_withWeights_b = RGB_b.*weights;

                %%%%%%%%%%%%%%%%%%%%%%%%%%%%% Fit MaxWeight %%%%%%%%%%%%%%%
                MaxWeight_a = max(RGB_withWeights_a')';
                MaxWeight_b = max(RGB_withWeights_b')';

                MaxWeight_diff = MaxWeight_a-MaxWeight_b;

                Diff_AB = [MaxWeight_diff];
                Direction = Diff_AB./abs(Diff_AB);
                CorrectAnswer = -Direction*0.5+1.5;
                NanLoc = find(isnan(CorrectAnswer(:,1)));
                NanNum = length(NanLoc);
                CorrectAnswer(NanLoc(1:round(NanNum/2)),1) = 1;
                CorrectAnswer(NanLoc(round(NanNum/2)+1:end),1) = 2;
                Diff = CorrectAnswer(:,1)-Resp';
                Acc_MaxWeighted(subject,count) = length(find(Diff==0))./length(Diff);
                %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

                %%%%%%%%%%%%%%%%%%%%%%%%%%%%% Fit SumWeight %%%%%%%%%%%%%%%
                SumWeight_a = sum(RGB_withWeights_a')';
                SumWeight_b = sum(RGB_withWeights_b')';

                SumWeight_diff = SumWeight_a-SumWeight_b;

                Diff_AB = [SumWeight_diff];
                Direction = Diff_AB./abs(Diff_AB);
                CorrectAnswer = -Direction*0.5+1.5;
                NanLoc = find(isnan(CorrectAnswer(:,1)));
                NanNum = length(NanLoc);
                CorrectAnswer(NanLoc(1:round(NanNum/2)),1) = 1;
                CorrectAnswer(NanLoc(round(NanNum/2)+1:end),1) = 2;
                Diff = CorrectAnswer(:,1)-Resp';
                Acc_SumWeighted(subject,count) = length(find(Diff==0))./length(Diff);
                %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            end
            MeanAcc_MaxWeighted(count) = mean(Acc_MaxWeighted(:,count));
            MeanAcc_SumWeighted(count) = mean(Acc_SumWeighted(:,count));

        end
    end
    [MaxWeighted_Acc,Loc] = max(MeanAcc_MaxWeighted);
    MaxWeights = weightList(Loc,:); %% The optimal weights
    LightingData.MaxWeightRGB(:,:,1) = max(cat(4,squeeze(LightingData.linearRGB(:,:,1,1))*MaxWeights(1),squeeze(LightingData.linearRGB(:,:,1,2))*MaxWeights(2),squeeze(LightingData.linearRGB(:,:,1,3))*MaxWeights(3)),[],4);
    LightingData.MaxWeightRGB(:,:,2) = max(cat(4,squeeze(LightingData.linearRGB(:,:,2,1))*MaxWeights(1),squeeze(LightingData.linearRGB(:,:,2,2))*MaxWeights(2),squeeze(LightingData.linearRGB(:,:,2,3))*MaxWeights(3)),[],4);
    LightingData.WeightFitting.MaxWeights = MaxWeights;

    LightingData.MaxRGB = max(LightingData.linearRGB,[],4);

    [SumWeighted_Acc,Loc] = max(MeanAcc_SumWeighted);
    SumWeights = weightList(Loc,:); %% The optimal weights
    LightingData.SumWeightRGB(:,:,1) = squeeze(LightingData.linearRGB(:,:,1,1))*SumWeights(1)+squeeze(LightingData.linearRGB(:,:,1,2))*SumWeights(2)+squeeze(LightingData.linearRGB(:,:,1,3))*SumWeights(3);
    LightingData.SumWeightRGB(:,:,2) = squeeze(LightingData.linearRGB(:,:,2,1))*SumWeights(1)+squeeze(LightingData.linearRGB(:,:,2,2))*SumWeights(2)+squeeze(LightingData.linearRGB(:,:,2,3))*SumWeights(3);
    LightingData.WeightFitting.SumWeights = SumWeights;

    LightingData.SumRGB = sum(LightingData.linearRGB,4);

    save ../RawData/LightingData.mat LightingData MaxWeights SumWeights;
end




%% Plot Conflicting Pairs Choice
DimName = {'Radiance','Max-weighted','Melanopsin','Sum-weighted RGB','SumRGB','MaxRGB'};
for subject = 1:size(LightingData.linearRGB,1)
    luminanceDiff = squeeze(LightingData.luminance(subject,:,1)-LightingData.luminance(subject,:,2));
    radianceDiff = squeeze(LightingData.radiance(subject,:,1)-LightingData.radiance(subject,:,2));
    mwDiff = squeeze(LightingData.MaxWeightRGB(subject,:,1)-LightingData.MaxWeightRGB(subject,:,2));
    melanopsinDiff = squeeze(LightingData.melanopsin(subject,:,1)-LightingData.melanopsin(subject,:,2));
    swDiff = squeeze(LightingData.SumWeightRGB(subject,:,1)-LightingData.SumWeightRGB(subject,:,2));
    SumRGBDiff = squeeze(LightingData.SumRGB(subject,:,1)-LightingData.SumRGB(subject,:,2));
    MaxRGBDiff = squeeze(LightingData.MaxRGB(subject,:,1)-LightingData.MaxRGB(subject,:,2));
    for nPair = 1:6
        switch nPair
            case 1
                AllCompare = luminanceDiff.*radianceDiff;
            case 2
                AllCompare = luminanceDiff.*mwDiff;
            case 3
                AllCompare = luminanceDiff.*melanopsinDiff;
            case 4
                AllCompare = luminanceDiff.*swDiff;
            case 5
                AllCompare = luminanceDiff.*SumRGBDiff;
            case 6
                AllCompare = luminanceDiff.*MaxRGBDiff;
        end
        TargetTrial = find(AllCompare<0);
        ChoosingLeft = find(LightingData.choice(subject,:)==1);
        luminanceHigherLeft = find(luminanceDiff>0);
        ChoosingRight = find(LightingData.choice(subject,:)==-1);
        luminanceHigherRight = find(luminanceDiff<0);
        ChoosingLuminance = [intersect(ChoosingLeft,luminanceHigherLeft), intersect(ChoosingRight,luminanceHigherRight)];
        ChoosingLuminance_conflictingTrial(nPair,subject) = length(intersect(ChoosingLuminance,TargetTrial))/length(TargetTrial);
    end
end



figure(100);
for nPair = 1:6
    subplot(2,3,nPair);
    ConflicChoice = 100-squeeze(ChoosingLuminance_conflictingTrial(nPair,:)*100);
    plot(1:size(LightingData.linearRGB,1),ConflicChoice,'o','MarkerSize',10,'LineWidth',1.5,'MarkerEdgeColor',[0 0.4470 0.7410],'MarkerFaceColor',[0 0.4470 0.7410]);
    Loc = find(ConflicChoice>50);
    LuminanceChoice = 100-round(length(Loc)/size(LightingData.linearRGB,1)*100);
    hold on
    plot(Loc,ConflicChoice(Loc),'o','MarkerSize',10,'LineWidth',1.5,'MarkerEdgeColor',[0.9290 0.6940 0.1250],'MarkerFaceColor',[0.9290 0.6940 0.1250]);
    ylim([0,100]);
    xlim([0,size(LightingData.linearRGB,1)+1])
    line([0,size(LightingData.linearRGB,1)+1],[50,50],'Color','k','LineStyle','--','LineWidth',1.5)
    if LuminanceChoice > 50
        lgd = legend({['Luminance wins for ',num2str(LuminanceChoice),'% observers'],[DimName{1,nPair}, ' wins']},'Box','off', 'Location','northoutside','FontSize',14)
    else
        lgd = legend({['Luminance wins'],[DimName{1,nPair}, ' wins for ', num2str(100-LuminanceChoice),'% observers']},'Box','off', 'Location','northoutside','FontSize',14)
    end
    lgd.NumColumns = 1;
    xlabel('Observers','FontSize',20, 'FontWeight', 'bold')
    xticks([]);
    xticklabels([])
    box off
    set(gca,'FontSize',12)
    set(gca,'LineWidth',1.5)

end

% Add a single ylabel in the middle of the figure
han = axes(figure(100), 'Visible', 'off');
han.YLabel.Visible = 'on';
ylabel(han, {'Trials choosing','non-luminance (%)',''}, 'FontSize', 16, 'FontWeight', 'bold');
set(gcf,'Position',[0,0,1800,300])
function [GrayFitPara,PSE_gray] = CompareRankingRelativeGray(idx_allPair,AllCubes_HueIntCh,MeanRanking,corrRGB,PatchLum,PSE_gray,GrayFitPara)
corrRGB = double(corrRGB);

if isempty(PSE_gray)
    GrayIdx = find(AllCubes_HueIntCh(:,3)==0);
    GrayIntensity = AllCubes_HueIntCh(GrayIdx,2);
    GrayPair = [];
    for WhichSide = 1:2
        [IsIncluded, GrayPair_temp] = ismember(idx_allPair(:,WhichSide),GrayIdx,'rows');
        GrayPair = [GrayPair;find(IsIncluded==1)];
    end
    idx_withGray = idx_allPair(GrayPair,:);
    PatchNoGray = setdiff(1:size(AllCubes_HueIntCh,1),GrayIdx);
    IntensityList = linspace(0.2,1,12)';

    for nPatch = 1:length(PatchNoGray)
        ThisPatch = PatchNoGray(nPatch);
        Hue = AllCubes_HueIntCh(ThisPatch,1);
        Int = AllCubes_HueIntCh(ThisPatch,2);
        Chroma = AllCubes_HueIntCh(ThisPatch,3);
        for GrayInt = 1:12
            GrayNo =  intersect(find(AllCubes_HueIntCh(:,3)==0),find(AllCubes_HueIntCh(:,2)==GrayInt));
            GrayNo = GrayNo(1);
            ChromaHigher = length(intersect(find(idx_withGray(:,1)==ThisPatch),find(idx_withGray(:,2)==GrayNo))); %% Non-gray patches were ranked as brighter
            GrayHigher = length(intersect(find(idx_withGray(:,2)==ThisPatch),find(idx_withGray(:,1)==GrayNo))); %% gray patches were ranked as brighter
            if (ChromaHigher+GrayHigher)>0
                GrayPercentage(Hue,Int,Chroma,GrayInt) = GrayHigher/(ChromaHigher+GrayHigher);
            else
                GrayPercentage(Hue,Int,Chroma,GrayInt) = NaN;
            end
        end

        %%%%% Fitting
        ThisX = IntensityList;
        ThisY = squeeze(GrayPercentage(Hue,Int,Chroma,:));
        ValidLoc = find(isnan(ThisY)==0);
        
        typ = fittype('1./(1+exp((-k)*(x-x0)))', 'coeff',{'k','x0'});
        if length(ValidLoc)>=2
            [fitobject,gof] = fit(ThisX(ValidLoc), ThisY(ValidLoc), typ);
            ci = coeffvalues(fitobject);
            k = ci(1); x0 = ci(2);
            x = linspace(IntensityList(1),IntensityList(end),100);
            fun=1./(1+exp((-k)*(x-x0)));
            GrayFitPara(Hue,Int,Chroma,:) = [k,x0];
        else
            GrayFitPara(Hue,Int,Chroma,:) = [nan,nan];
        end

        %%%%% Find the PSE
        if ~ isnan(GrayFitPara(Hue,Int,Chroma,1))
            if ~ isempty(find(abs(fun-0.5)<0.02))
                PSE_gray(Hue,Int,Chroma) = x(find(abs(fun-0.5)==min(abs(fun-0.5))));
            else
                PSE_gray(Hue,Int,Chroma) = nan;
            end
        else
            PSE_gray(Hue,Int,Chroma) = nan;
        end
    end

    for nPatch = 1:length(PatchNoGray)
        ThisPatch = PatchNoGray(nPatch);
        Hue = AllCubes_HueIntCh(ThisPatch,1);
        Int = AllCubes_HueIntCh(ThisPatch,2);
        Chroma = AllCubes_HueIntCh(ThisPatch,3);
        k = GrayFitPara(Hue,Int,Chroma,1);
        x0 = GrayFitPara(Hue,Int,Chroma,2);
        x = linspace(IntensityList(1),IntensityList(end),100);
        fun=1./(1+exp((-k)*(x-x0)));
    end
end
%% Calculated The Correlation with rankings
MinVal = min(min(min(MeanRanking)));
MaxVal = max(max(max(MeanRanking)));
MeanRankings_rescale = (MeanRanking-MinVal)/(MaxVal-MinVal);
PSE_realign = [];
MeanRankings_realign = [];
corrRGB_realign = [];
for Hi = 1:12
    for Ii = 1:12
        PSE_realign = [PSE_realign;squeeze(PSE_gray(Hi,Ii,:))];
        MeanRankings_realign = [MeanRankings_realign;squeeze(MeanRankings_rescale(Hi,Ii,2:6))];
        [isInA, locationRGB] = ismember([Hi,Ii,1;Hi,Ii,2;Hi,Ii,3;Hi,Ii,4;Hi,Ii,5], AllCubes_HueIntCh, 'rows');
        corrRGB_realign = [corrRGB_realign;corrRGB(locationRGB,:)];
    end
end
ValidPatch = find(isnan(PSE_realign)==0);
MeanRankings_realign = MeanRankings_realign(ValidPatch);
corrRGB_realign = corrRGB_realign(ValidPatch,:);
PSE_realign = PSE_realign(ValidPatch);
figure;
hold on;
for nPatch = length(ValidPatch):-1:1
    plot(PSE_realign(nPatch),MeanRankings_realign(nPatch),'.','MarkerSize',30,'LineWidth',1.5,'Color',corrRGB_realign(nPatch,:)/255);
end
xlabel('PSE (to Gray)','FontSize',16);
ylabel('Scaled Rankings','FontSize',16);
title(['Corrleation:',32,num2str(corr(MeanRankings_realign,PSE_realign))]);
xlim([0,1]);
ylim([0,1]);
box off
axis square;
set(gca,'FontSize',16);
set(gca,'LineWidth',1.5);


%% Plot Relative Gray
% Hue angle distribution (circular layout)
angle = linspace(0, 2*pi, 13);
xlist = sin(angle);
ylist = cos(angle);
MeanPSE_12Hue = nanmean(nanmean(PSE_gray,3),2);

figure; hold on
r = 0.5; % Radius of the circle
theta = linspace(0, 2*pi, 100); % Angle from 0 to 2π
x = r * cos(theta); % X-coordinates
y = r * sin(theta); % Y-coordinates
fill(x, y, [0.5, 0.5, 0.5], 'FaceAlpha', 0.3, 'EdgeColor', [1, 1, 1], 'LineWidth', 1.5); % Gray fill with transparency
axis equal; % Keep aspect ratio
for Hi = 1:12
    [isInA, locationRGB] = ismember([Hi,12,5], AllCubes_HueIntCh, 'rows');
    Luminance_12Hue(Hi,1) = PatchLum(locationRGB);
    plot(MeanPSE_12Hue(Hi)*xlist(Hi), MeanPSE_12Hue(Hi)*ylist(Hi), 'o', ...
        'MarkerFaceColor', double(corrRGB(locationRGB,:))/255,'MarkerEdgeColor', 'k', 'MarkerSize', 16, 'LineWidth', 1.5);
end

Luminance_12Hue = Luminance_12Hue/max(Luminance_12Hue)/2.5;%% Fit in to the figure range
plot([Luminance_12Hue;Luminance_12Hue(1)]'.*xlist(1,:),[Luminance_12Hue;Luminance_12Hue(1)]'.*ylist(1,:), 'k-', 'LineWidth', 2);
plot(0, 0, 'ko', 'MarkerFaceColor', 'k', 'MarkerSize', 16); % Black
xlim([-0.6,0.6])
ylim([-0.6,0.6])
xticks([-0.5:0.5:0.5])
yticks([-0.5:0.5:0.5])
set(gca,'FontSize',16)
set(gca,'LineWidth',1.5)
title(sprintf('Grayscale Brightness \n'),'FontSize',18);
axis square

%% Helmholtz–Kohlrausch effect
figure;hold on
for Hi = 1:12
%     figure;hold on
%     xlim([0,87])
    for Ii = 1:12
        [isInA, locationRGB] = ismember([Hi,Ii,5], AllCubes_HueIntCh, 'rows');
        LumThisPatch = PatchLum(locationRGB);
        for Ci = 1:6
            [isInA, locationRGB] = ismember([Hi,12,Ci-1], AllCubes_HueIntCh, 'rows');
            LumHighInt = PatchLum(locationRGB);
            [isInA, locationRGB] = ismember([Hi,1,Ci-1], AllCubes_HueIntCh, 'rows');
            LumLowInt = PatchLum(locationRGB);
            ThisPatchId = (LumThisPatch-LumLowInt)/(LumHighInt-LumLowInt)*11+1;
            if ThisPatchId > 0
                UpLevel = ceil(ThisPatchId);
                DownLevel = floor(ThisPatchId);

                if DownLevel ~= 0
                    EstimatedRanking(Ii,Ci) = (ThisPatchId-DownLevel)*(MeanRanking(Hi,UpLevel,Ci)-MeanRanking(Hi,DownLevel,Ci))+MeanRanking(Hi,DownLevel,Ci);
                    [isInA, locationRGB] = ismember([Hi,round(ThisPatchId),Ci-1], AllCubes_HueIntCh, 'rows');
                    EstimatedRGB = corrRGB(locationRGB,:)/255;
                else
                    EstimatedRanking(Ii,Ci) = LumThisPatch/LumLowInt*MeanRanking(Hi,1,Ci);
                    [isInA, locationRGB] = ismember([Hi,1,Ci-1], AllCubes_HueIntCh, 'rows');
                    EstimatedRGB = corrRGB(locationRGB,:)/255*LumThisPatch/LumLowInt;
                end
            else
                EstimatedRanking(Ii,Ci) = LumThisPatch/LumLowInt*MeanRanking(Hi,1,Ci);
                [isInA, locationRGB] = ismember([Hi,1,Ci-1], AllCubes_HueIntCh, 'rows');
                EstimatedRGB = corrRGB(locationRGB,:)/255*LumThisPatch/LumLowInt;
            end
            plot(Ci-1+(Hi-1)*7+2,EstimatedRanking(Ii,Ci),'s','MarkerEdgeColor',EstimatedRGB,'MarkerFaceColor',EstimatedRGB,'MarkerSize',12);
        end
        X = 0:5;
        plot(X(find(isnan(EstimatedRanking(Ii,:))==0))+(Hi-1)*7+2,EstimatedRanking(Ii,find(isnan(EstimatedRanking(Ii,:))==0)),'-','Color',[0.7,0.7,0.7],'LineWidth',1);
    end
    EstimatedRanking_all(Hi,:,:) = EstimatedRanking;
    xticks([]);
    xticklabels([]);
    ylim([0,12])
    xlabel('Increased Chroma');
    title('Estimated Rankings at Equiluminant Level');
    set(gca,'FontSize',16)
    set(gca,'LineWidth',1.5)
    set(gcf,'Position',[0,0,2400,400])
end
end
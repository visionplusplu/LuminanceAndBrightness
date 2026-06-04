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
        [fitobject,gof] = fit(ThisX(ValidLoc), ThisY(ValidLoc), typ);
        ci = coeffvalues(fitobject);
        k = ci(1); x0 = ci(2);
        x = linspace(IntensityList(1),IntensityList(end),100);
        fun=1./(1+exp((-k)*(x-x0)));
        GrayFitPara(Hue,Int,Chroma,:) = [k,x0];

        %%%%% Find the PSE
        if ~ isempty(find(abs(fun-0.5)<0.02))
            PSE_gray(Hue,Int,Chroma) = x(find(abs(fun-0.5)==min(abs(fun-0.5))));
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


%% Helmholtz–Kohlrausch effect
MeanRanking(2:end,:,1) = repmat(MeanRanking(1,:,1),11,1);

figure("Name","fig. S4F",'NumberTitle','off');hold on
HueList = [1,5,9];
for H_No = 1:3
    Hi = HueList(H_No);
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
            plot(Ci-1+(H_No-1)*7+2,EstimatedRanking(Ii,Ci),'s','MarkerEdgeColor',EstimatedRGB,'MarkerFaceColor',EstimatedRGB,'MarkerSize',12);
        end
        X = 0:5;
        plot(X(find(isnan(EstimatedRanking(Ii,:))==0))+(H_No-1)*7+2,EstimatedRanking(Ii,find(isnan(EstimatedRanking(Ii,:))==0)),'-','Color',[0.7,0.7,0.7],'LineWidth',1);
    end
    EstimatedRanking_all(Hi,:,:) = EstimatedRanking;
    xticks([]);
    xticklabels([]);
    xlim([0,24]);
    ylim([0,12])
    xlabel('Increased Chroma');
    ylabel('Estimated Rankings');
    title('Estimated Rankings (Equiluminant)');
    set(gca,'FontSize',16)
    set(gca,'LineWidth',1.5)
    set(gcf,'Position',[0,0,1000,400])
end


figure("Name","fig. S4E",'NumberTitle','off');hold on
HueList = [1,5,9];
for H_No = 1:3
    Hi = HueList(H_No);
    for Ii = 1:12
        for Ci = 1:6
            [isInA, locationRGB] = ismember([Hi,Ii,Ci-1], AllCubes_HueIntCh, 'rows');
            thisRGB= squeeze(corrRGB(locationRGB,:));
            if Ci == 1
                plot(Ci-1+(H_No-1)*7+2,MeanRanking(Hi,Ii,Ci),'s','MarkerEdgeColor',[0,0,0],'MarkerFaceColor',thisRGB/255,'MarkerSize',12);
            else
                plot(Ci-1+(H_No-1)*7+2,MeanRanking(Hi,Ii,Ci),'s','MarkerEdgeColor',thisRGB/255,'MarkerFaceColor',thisRGB/255,'MarkerSize',12);
            end
        end
        X = 0:5;
        plot(X+(H_No-1)*7+2,squeeze(MeanRanking(Hi,Ii,:)),'-','Color',[0.7,0.7,0.7],'LineWidth',1);
    end
    xticks([]);
    xticklabels([]);
    ylim([0,12])
    xlim([0,24]);
    xlabel('Increased Chroma');
    ylabel('Rankings')
    title('Mean Rankings');
    set(gca,'FontSize',16)
    set(gca,'LineWidth',1.5)
    set(gcf,'Position',[0,0,1000,400])
end


end
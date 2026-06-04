function [UV_mean]= RankingConsistency(PatchRanking1,PatchRanking2,DataName1, DataName2, FigureTitle, FigId, linearRGB, Type)


    if length(size(PatchRanking1)) == 2
        CubeRanking1 = mean(PatchRanking1)';
        CubeRanking2 = mean(PatchRanking2)';
    elseif length(size(PatchRanking1)) == 4
        CubeRanking1 = squeeze(nanmean(PatchRanking1));
        CubeRanking1 = permute(CubeRanking1, [3, 2, 1]);
        CubeRanking1 = CubeRanking1(:);

        CubeRanking2 = squeeze(nanmean(PatchRanking2));
        CubeRanking2 = permute(CubeRanking2, [3, 2, 1]);
        CubeRanking2 = CubeRanking2(:);
    end

    ValidLoc1 = find(isnan(CubeRanking1)~=1);
    ValidLoc2 = find(isnan(CubeRanking2)~=1);
    ValidLoc = intersect(ValidLoc1,ValidLoc2);

    figure("Name",FigId,'NumberTitle','off');
    hold on
    for nPatch = 1:length(ValidLoc)
        plot(CubeRanking1(ValidLoc(nPatch)),CubeRanking2(ValidLoc(nPatch)),'.','MarkerSize',28,'LineWidth',1.5,'Color',linearRGB(ValidLoc(nPatch),:).^(1/2.2));
    end
    [corrCoef,p_val] = corr(CubeRanking1(ValidLoc),CubeRanking2(ValidLoc),'Type','Spearman');
    xlabel(['Ranking (',DataName1,')'],'FontSize',16);
    ylabel(['Ranking (',DataName2,')'],'FontSize',16);
    xlim([1,12]);
    ylim([1,12]);
    title(FigureTitle,'FontSize',24);
    UV_mean = (1-corrCoef^2)*100; %% by percentage
    text(4,3,['Unexplained variance:',num2str(UV_mean),'%'],'FontSize',12);
    set(gca,'FontSize',16)
    set(gca,'LineWidth',2)
    box off
    axis square;

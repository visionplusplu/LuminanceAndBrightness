function RankingConsistency(PatchRanking1,PatchRanking2,DataName1, DataName2, FigureTitle, linearRGB, Type)


if strcmp(Type,'Mean')
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

    figure;
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
    text(4,3,['Unexplained variance:',num2str((1-corrCoef^2)*100),'%'],'FontSize',12);
    set(gca,'FontSize',16)
    set(gca,'LineWidth',2)
    box off
    axis square;
elseif strcmp(Type,'Individual')
    for nSub = 1:size(PatchRanking1,1);
        if length(size(PatchRanking1)) == 2
            CubeRanking1 = PatchRanking1(nSub,:)';
            CubeRanking2 = PatchRanking2(nSub,:)';
        elseif length(size(PatchRanking1)) == 4
            CubeRanking1 = squeeze(PatchRanking1(nSub,:,:,:));
            CubeRanking1 = permute(CubeRanking1, [3, 2, 1]);
            CubeRanking1 = CubeRanking1(:);

            CubeRanking2 = squeeze(PatchRanking2(nSub,:,:,:));
            CubeRanking2 = permute(CubeRanking2, [3, 2, 1]);
            CubeRanking2 = CubeRanking2(:);
        end

        ValidLoc1 = find(isnan(CubeRanking1)~=1);
        ValidLoc2 = find(isnan(CubeRanking2)~=1);
        ValidLoc = intersect(ValidLoc1,ValidLoc2);
        [corrCoef,p_val] = corr(CubeRanking1(ValidLoc),CubeRanking2(ValidLoc),'Type','Spearman');
        UnexplainedVariance_allSub(nSub) = (1-corrCoef^2)*100;
    end
    ColorScheme = [0.3,0.3,0.9];
    figure
    hold on;
    violin(UnexplainedVariance_allSub','facecolor',ColorScheme(1,:),'edgecolor',[],'facealpha',0.2,'medc',[0,0,0],'mc',[]);
    swarmchart(ones(size(UnexplainedVariance_allSub',1),1),UnexplainedVariance_allSub',24,'filled','MarkerFaceAlpha',0.5,'MarkerEdgeAlpha',0.5,'MarkerFaceColor',ColorScheme(1,:))
    xlim([0 2])
    ylim([0 50])
    ylabel('Unexplained variance (%)')
    title(FigureTitle,'FontSize',24);
    set(gca,'XTick',[])
    box off
    set(gcf,'Position',[200,200,200,400])
    set(gca,'FontSize',16)
    set(gca,'LineWidth',2)

end

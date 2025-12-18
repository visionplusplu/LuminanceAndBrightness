function DisplayComparison(corrRGB,caliPath,oled_weights,cubeRGBs4Fitting,OptimalSumWeight,OptimalMaxWeight,AllSub_Name)
corrRGB = double(corrRGB);

%% OledPara
if length(size(cubeRGBs4Fitting)) == 3 %%% Non-chroma Variation Experiment
    Oled_Luminance = cubeRGBs4Fitting(:,:,1)*oled_weights.LumWeight(1)+cubeRGBs4Fitting(:,:,2)*oled_weights.LumWeight(2)+cubeRGBs4Fitting(:,:,3)*oled_weights.LumWeight(3);
    Oled_Radiance =cubeRGBs4Fitting(:,:,1)*oled_weights.RadWeight(1)+cubeRGBs4Fitting(:,:,2)*oled_weights.RadWeight(2)+cubeRGBs4Fitting(:,:,3)*oled_weights.RadWeight(3);
    OledRGB.SwRGB = squeeze(cubeRGBs4Fitting(:,:,1)*OptimalSumWeight(1)+cubeRGBs4Fitting(:,:,2)*OptimalSumWeight(2)+cubeRGBs4Fitting(:,:,3)*OptimalSumWeight(3));
    temp(1,:,:) = squeeze(cubeRGBs4Fitting(:,:,1)*OptimalMaxWeight(1));
    temp(2,:,:) = squeeze(cubeRGBs4Fitting(:,:,2)*OptimalMaxWeight(2));
    temp(3,:,:) = squeeze(cubeRGBs4Fitting(:,:,3)*OptimalMaxWeight(3));
    OledRGB.MwRGB= squeeze(max(temp));
elseif length(size(cubeRGBs4Fitting)) == 2 %%% Chroma Variation Experiment
    Oled_Luminance = cubeRGBs4Fitting(:,1)*oled_weights.LumWeight(1)+cubeRGBs4Fitting(:,2)*oled_weights.LumWeight(2)+cubeRGBs4Fitting(:,3)*oled_weights.LumWeight(3);
    Oled_Radiance =cubeRGBs4Fitting(:,1)*oled_weights.RadWeight(1)+cubeRGBs4Fitting(:,2)*oled_weights.RadWeight(2)+cubeRGBs4Fitting(:,3)*oled_weights.RadWeight(3);
    OledRGB.SwRGB = squeeze(cubeRGBs4Fitting(:,1)*OptimalSumWeight(1)+cubeRGBs4Fitting(:,2)*OptimalSumWeight(2)+cubeRGBs4Fitting(:,3)*OptimalSumWeight(3));
    temp(1,:) = squeeze(cubeRGBs4Fitting(:,1)*OptimalMaxWeight(1));
    temp(2,:) = squeeze(cubeRGBs4Fitting(:,2)*OptimalMaxWeight(2));
    temp(3,:) = squeeze(cubeRGBs4Fitting(:,3)*OptimalMaxWeight(3));
    OledRGB.MwRGB= squeeze(max(temp));
end


Oled_Luminance = Oled_Luminance(:);
Pairs = nchoosek(1:length(Oled_Luminance),2);
OledPair_Luminance = Oled_Luminance(Pairs);
Oled_LuminanceChoice = sign(OledPair_Luminance(:,1)-OledPair_Luminance(:,2));

Oled_Radiance = Oled_Radiance(:);
OledPair_Radiance = Oled_Radiance(Pairs);
Oled_RadianceChoice = sign(OledPair_Radiance(:,1)-OledPair_Radiance(:,2));

Oled_SwRGB = OledRGB.SwRGB(:);
OledPair_SwRGB = Oled_SwRGB(Pairs);
Oled_SwRGBChoice = sign(OledPair_SwRGB(:,1)-OledPair_SwRGB(:,2));

Oled_MwRGB = OledRGB.MwRGB(:);
OledPair_MwRGB = Oled_MwRGB(Pairs);
Oled_MwRGBChoice = sign(OledPair_MwRGB(:,1)-OledPair_MwRGB(:,2));


%% Load Individual Monitors
AllFile_calib = dir(strcat([caliPath,'*_calib.mat']));
AllFile_calibName = {AllFile_calib.name};
SubjectN = 0;
SubjectNo = size(AllSub_Name,2);
for Subject = 1:SubjectNo
    %% load participant's monitor data and calculate the radiance & luminance
    ThisSubNo = strcat(cell2mat(AllSub_Name(1,Subject)),'_cali');
    X = ~cellfun('isempty',strfind(AllFile_calibName,ThisSubNo)); %%% Id:23 hasn't been measured
    if length(find(X~=0)) > 0
        SubjectN = SubjectN+1;
        calibName = AllFile_calibName{1,find(X~=0)};
        load(strcat([caliPath,calibName]));

        laptop_gammas = g;
        RedLum = xyz(9,2);
        GreenLum = xyz(17,2);
        BlueLum = xyz(25,2);
        gamut = xyy([9,17,25],:);
        whitePoint = xyy(26,:);

        RedRad = rs;
        GreenRad = gs;
        BlueRad = bs;

        AllLaptops_participants.LuminanceWeight(SubjectN,:) = [RedLum,GreenLum,BlueLum]/(RedLum+GreenLum+BlueLum);
        AllLaptops_participants.RadianceWeight(SubjectN,:) = [sum(RedRad),sum(GreenRad),sum(BlueRad)]/([sum(RedRad)+sum(GreenRad)+sum(BlueRad)]);

        AllLaptops_participants.Name{SubjectN,1} = str2num(ThisSubNo);
        AllLaptops_participants.gammas(SubjectN,:) = laptop_gammas;
        AllLaptops_participants.gamut(SubjectN,:,:) = gamut;
        AllLaptops_participants.whitePoint(SubjectN,:) = whitePoint;
        if length(size(cubeRGBs4Fitting)) == 3 %%% Non-chroma Variation Experiment
            AllLaptops_participants.cube(SubjectN,:,:,1) = (corrRGB(:,:,1)/255).^laptop_gammas(1);
            AllLaptops_participants.cube(SubjectN,:,:,2) = (corrRGB(:,:,2)/255).^laptop_gammas(2);
            AllLaptops_participants.cube(SubjectN,:,:,3) = (corrRGB(:,:,3)/255).^laptop_gammas(3);

            AllLaptops_participants.Luminance(SubjectN,:,:) = squeeze(AllLaptops_participants.cube(SubjectN,:,:,1)*RedLum+AllLaptops_participants.cube(SubjectN,:,:,2)*GreenLum+AllLaptops_participants.cube(SubjectN,:,:,3)*BlueLum);
            ThisLuminance = squeeze(AllLaptops_participants.Luminance(SubjectN,:,:));

            AllLaptops_participants.Radiance(SubjectN,:,:) = squeeze(AllLaptops_participants.cube(SubjectN,:,:,1)*sum(RedRad)+AllLaptops_participants.cube(SubjectN,:,:,2)*sum(GreenRad)+AllLaptops_participants.cube(SubjectN,:,:,3)*sum(BlueRad));
            ThisRadiance = squeeze(AllLaptops_participants.Radiance(SubjectN,:,:));

            AllLaptops_participants.SwRGB(SubjectN,:,:) = squeeze(AllLaptops_participants.cube(SubjectN,:,:,1)*OptimalSumWeight(1)+AllLaptops_participants.cube(SubjectN,:,:,2)*OptimalSumWeight(2)+AllLaptops_participants.cube(SubjectN,:,:,3)*OptimalSumWeight(3));
            ThisSwRGB = squeeze(AllLaptops_participants.SwRGB(SubjectN,:,:));

            temp(1,:,:) = squeeze(AllLaptops_participants.cube(SubjectN,:,:,1)*OptimalMaxWeight(1));
            temp(2,:,:) = squeeze(AllLaptops_participants.cube(SubjectN,:,:,2)*OptimalMaxWeight(2));
            temp(3,:,:) = squeeze(AllLaptops_participants.cube(SubjectN,:,:,3)*OptimalMaxWeight(3));
            AllLaptops_participants.MwRGB(SubjectN,:,:) = squeeze(max(temp));
            ThisMwRGB = squeeze(AllLaptops_participants.MwRGB(SubjectN,:,:));
        elseif length(size(cubeRGBs4Fitting)) == 2 %%% Chroma Variation Experiment
            AllLaptops_participants.cube(SubjectN,:,:,1) = (corrRGB(:,1)/255).^laptop_gammas(1);
            AllLaptops_participants.cube(SubjectN,:,:,2) = (corrRGB(:,2)/255).^laptop_gammas(2);
            AllLaptops_participants.cube(SubjectN,:,:,3) = (corrRGB(:,3)/255).^laptop_gammas(3);

            AllLaptops_participants.Luminance(SubjectN,:) = squeeze(AllLaptops_participants.cube(SubjectN,:,1)*RedLum+AllLaptops_participants.cube(SubjectN,:,2)*GreenLum+AllLaptops_participants.cube(SubjectN,:,3)*BlueLum);
            ThisLuminance = squeeze(AllLaptops_participants.Luminance(SubjectN,:,:));

            AllLaptops_participants.Radiance(SubjectN,:) = squeeze(AllLaptops_participants.cube(SubjectN,:,1)*sum(RedRad)+AllLaptops_participants.cube(SubjectN,:,2)*sum(GreenRad)+AllLaptops_participants.cube(SubjectN,:,3)*sum(BlueRad));
            ThisRadiance = squeeze(AllLaptops_participants.Radiance(SubjectN,:,:));

            AllLaptops_participants.SwRGB(SubjectN,:) = squeeze(AllLaptops_participants.cube(SubjectN,:,1)*OptimalSumWeight(1)+AllLaptops_participants.cube(SubjectN,:,2)*OptimalSumWeight(2)+AllLaptops_participants.cube(SubjectN,:,3)*OptimalSumWeight(3));
            ThisSwRGB = squeeze(AllLaptops_participants.SwRGB(SubjectN,:,:));

            temp(1,:) = squeeze(AllLaptops_participants.cube(SubjectN,:,1)*OptimalMaxWeight(1));
            temp(2,:) = squeeze(AllLaptops_participants.cube(SubjectN,:,2)*OptimalMaxWeight(2));
            temp(3,:) = squeeze(AllLaptops_participants.cube(SubjectN,:,3)*OptimalMaxWeight(3));
            AllLaptops_participants.MwRGB(SubjectN,:) = squeeze(max(temp));
            ThisMwRGB = squeeze(AllLaptops_participants.MwRGB(SubjectN,:));
        end

       
        This_Luminance = ThisLuminance(:);
        ThisPair_Luminance = This_Luminance(Pairs);
        This_LuminanceChoice = sign(ThisPair_Luminance(:,1)-ThisPair_Luminance(:,2));
        Consistency_Luminance(SubjectN) = length(find(Oled_LuminanceChoice-This_LuminanceChoice==0))./length(Oled_LuminanceChoice);
   
        This_Radiance = ThisRadiance(:);
        ThisPair_Radiance = This_Radiance(Pairs);
        This_RadianceChoice = sign(ThisPair_Radiance(:,1)-ThisPair_Radiance(:,2));
        Consistency_Radiance(SubjectN) = length(find(Oled_RadianceChoice-This_RadianceChoice==0))./length(Oled_RadianceChoice);

        This_SwRGB = ThisSwRGB(:);
        ThisPair_SwRGB = This_SwRGB(Pairs);
        This_SwRGBChoice = sign(ThisPair_SwRGB(:,1)-ThisPair_SwRGB(:,2));
        Consistency_SwRGB(SubjectN) = length(find(Oled_SwRGBChoice-This_SwRGBChoice==0))./length(Oled_SwRGBChoice);

        This_MwRGB = ThisMwRGB(:);
        ThisPair_MwRGB = This_MwRGB(Pairs);
        This_MwRGBChoice = sign(ThisPair_MwRGB(:,1)-ThisPair_MwRGB(:,2));
        Consistency_MwRGB(SubjectN) = length(find(Oled_MwRGBChoice-This_MwRGBChoice==0))./length(Oled_MwRGBChoice);
    end
end

%% Plot Gamut
figure;
lasso = csvread(strcat([caliPath,'xyYcoordsWrgb.csv']));
s = scatter(lasso(:, 1), lasso(:, 2), [], squeeze(lasso(:, 3:end)),'filled');
s.SizeData = 130;
axis square;
hold on
set(gca,'color','none')
for MonitorNumber = 1:size(AllLaptops_participants.gamut,1)
    plot(AllLaptops_participants.gamut(MonitorNumber,[1:3,1],1),AllLaptops_participants.gamut(MonitorNumber,[1:3,1],2),'-','Color',[0.6,0.6,0.6],'LineWidth',1);
    hold on;
end
load (['./OLEDparas/oled_gamut.mat']);
plot(oled_gamut(1,[1:3,1]),oled_gamut(2,[1:3,1]),'k-','LineWidth',3);
xlim([0,0.8]);
ylim([0,0.9]);
xlabel('x');
ylabel('y')
set(gca,'FontSize',18);

%% Pair Ranking Consitency predicted by models

if length(size(cubeRGBs4Fitting)) == 3 %%% Non-chroma Variation Experiment
    subfigureNo = 4;
    ColorScheme(1,:) = [0,0.6,0];
    ColorScheme(2,:) = [0,0,0.8];
    ColorScheme(3,:) = [0.918,0.459,0.110];
    ColorScheme(4,:) = [1,0,0];
elseif length(size(cubeRGBs4Fitting)) == 2 %%% Chroma Variation Experiment
    subfigureNo = 3;
    ColorScheme(1,:) = [0,0.6,0];
    ColorScheme(2,:) = [0,0,0.8];
    ColorScheme(3,:) = [1,0,0];
end


figure;
subplot(1,subfigureNo,1)
hold on;
violin(Consistency_Luminance','facecolor',ColorScheme(1,:),'edgecolor',[],'facealpha',0.2,'medc',ColorScheme(1,:),'mc',[]);
swarmchart(ones(size(Consistency_Luminance',1),1),Consistency_Luminance',16,'filled','MarkerFaceAlpha',0.5,'MarkerEdgeAlpha',0.5,'MarkerFaceColor',ColorScheme(1,:))
xlim([0 2])
ylim([0.8 1])
ylabel('Luminance Ranking Consistency')
text(0,0.82,strcat('Median: ', num2str(median(Consistency_Luminance'))));
set(gca,'XTick',[])
box off

subplot(1,subfigureNo,2)
violin(Consistency_Radiance','facecolor',ColorScheme(2,:),'edgecolor',[],'facealpha',0.2,'medc',ColorScheme(2,:),'mc',[]);
swarmchart(ones(size(Consistency_Radiance',1),1),Consistency_Radiance',16,'filled','MarkerFaceAlpha',0.5,'MarkerEdgeAlpha',0.5,'MarkerFaceColor',ColorScheme(2,:))
xlim([0 2])
ylim([0.8 1])
ylabel('Radiance Ranking Consistency')
text(0,0.82,strcat('Median: ', num2str(median(Consistency_Radiance'))));
set(gca,'XTick',[])
box off

if length(size(cubeRGBs4Fitting)) == 3 %%% Non-chroma Variation Experiment
    subplot(1,subfigureNo,3)
    violin(Consistency_SwRGB','facecolor',ColorScheme(3,:),'edgecolor',[],'facealpha',0.2,'medc',ColorScheme(3,:),'mc',[]);
    swarmchart(ones(size(Consistency_SwRGB',1),1),Consistency_SwRGB',16,'filled','MarkerFaceAlpha',0.5,'MarkerEdgeAlpha',0.5,'MarkerFaceColor',ColorScheme(3,:))
    xlim([0 2])
    ylim([0.8 1])
    ylabel('Sum-weighted Ranking Consistency')
    text(0,0.82,strcat('Median: ', num2str(median(Consistency_SwRGB'))));
    set(gca,'XTick',[])
    box off
    subplot(1,subfigureNo,4)
    violin(Consistency_MwRGB','facecolor',ColorScheme(4,:),'edgecolor',[],'facealpha',0.2,'medc',ColorScheme(4,:),'mc',[]);
    swarmchart(ones(size(Consistency_MwRGB',1),1),Consistency_MwRGB',16,'filled','MarkerFaceAlpha',0.5,'MarkerEdgeAlpha',0.5,'MarkerFaceColor',ColorScheme(4,:))
elseif length(size(cubeRGBs4Fitting)) == 2 %%% Chroma Variation Experiment
    subplot(1,subfigureNo,3)
    violin(Consistency_MwRGB','facecolor',ColorScheme(3,:),'edgecolor',[],'facealpha',0.2,'medc',ColorScheme(3,:),'mc',[]);
    swarmchart(ones(size(Consistency_MwRGB',1),1),Consistency_MwRGB',16,'filled','MarkerFaceAlpha',0.5,'MarkerEdgeAlpha',0.5,'MarkerFaceColor',ColorScheme(3,:))
end
xlim([0 2])
ylim([0.8 1])
ylabel('Max-weighted Ranking Consistency')
text(0,0.82,strcat('Median: ', num2str(median(Consistency_MwRGB'))));
set(gca,'XTick',[])
box off
set(gcf,'Position',[0,0,500,300])

%% Plot weights on a triangle plot
%%%%%%%%%%%%%%%%%%%%%%%%% LuminanceWeight
% Define the vertices of the equilateral triangle
triangle_x = [0, 1, 0.5, 0];         % X-coordinates of the main triangle
triangle_y = [0, 0, sqrt(3)/2, 0];   % Y-coordinates (equilateral triangle height)

figure;
hold on;

% Define the distances a, b, c to the three sides (you can set these values)
wR = AllLaptops_participants.LuminanceWeight(:,1);  % Distance to the second side (LEFT)
wG = AllLaptops_participants.LuminanceWeight(:,2);  % Distance to the third side (BOTTOM)
wB = AllLaptops_participants.LuminanceWeight(:,3);  % Distance to the first side (RIGHT)

% Calculate the coordinates of the point using barycentric coordinates
x_dot = wB * triangle_x(1) + wR * triangle_x(2) + wG * triangle_x(3);
y_dot = wB * triangle_y(1) + wR * triangle_y(2) + wG * triangle_y(3);

% scatter(x_dot, y_dot, 10, 'filled', 'MarkerFaceColor', [0.6,0.6,0.6], 'MarkerEdgeColor', [0.6,0.6,0.6], 'LineWidth', 1);
scatter(x_dot, y_dot, 10, 'MarkerEdgeColor', [0.6,0.6,0.6], 'LineWidth', 1);

LuminanceWeight = oled_weights.LumWeight;
Luminance_x = LuminanceWeight(3) * triangle_x(1) + LuminanceWeight(1) * triangle_x(2) + LuminanceWeight(2) * triangle_x(3);
Luminance_y = LuminanceWeight(3) * triangle_y(1) + LuminanceWeight(1) * triangle_y(2) + LuminanceWeight(2) * triangle_y(3);

lum_handle = plot(Luminance_x,Luminance_y,'o','MarkerEdgeColor', 'k','MarkerSize',10,'LineWidth',2)

%%%%%%%%%%%%%%%%%%%%%%%%% RadianceWeight

% Define the distances a, b, c to the three sides (you can set these values)
wR = AllLaptops_participants.RadianceWeight(:,1); % Distance to the second side (LEFT)
wG = AllLaptops_participants.RadianceWeight(:,2);  % Distance to the third side (BOTTOM)
wB = AllLaptops_participants.RadianceWeight(:,3);  % Distance to the first side (RIGHT)


% Calculate the coordinates of the point using barycentric coordinates
x_dot = wB * triangle_x(1) + wR * triangle_x(2) + wG * triangle_x(3);
y_dot = wB * triangle_y(1) + wR * triangle_y(2) + wG * triangle_y(3);

% scatter(x_dot, y_dot, 10, 'filled', 'MarkerFaceColor', [0.6,0.6,0.6], 'MarkerEdgeColor', [0.6,0.6,0.6], 'LineWidth', 1);
scatter(x_dot, y_dot, 10, 'v','filled','MarkerFaceColor',[0.6,0.6,0.6], 'MarkerEdgeColor', [0.6,0.6,0.6]);

RadianceWeight = oled_weights.RadWeight/sum(oled_weights.RadWeight);
Radiance_x = RadianceWeight(3) * triangle_x(1) + RadianceWeight(1) * triangle_x(2) + RadianceWeight(2) * triangle_x(3);
Radiance_y = RadianceWeight(3) * triangle_y(1) + RadianceWeight(1) * triangle_y(2) + RadianceWeight(2) * triangle_y(3);

Rad_handle = plot(Radiance_x,Radiance_y,'v', 'MarkerFaceColor', 'k','MarkerEdgeColor', 'k','MarkerSize',10,'LineWidth',0.5)

axis equal;
box off
xticks([]);
xticklabels([]);
yticks([]);
yticklabels([]);


% Draw the main white equilateral triangle
plot(triangle_x, triangle_y, 'k-', 'LineWidth', 2);

% Draw small Red, Green, and Blue triangles at the corners
% Blue triangle (bottom-left)
fill([0, 0.05, 0.025], [0, 0, 0.025 * sqrt(3)], 'b', 'EdgeColor', 'k', 'LineWidth', 2); 
% Red triangle (bottom-right)
fill([1, 0.95, 0.975], [0, 0, 0.025 * sqrt(3)], 'r', 'EdgeColor', 'k', 'LineWidth', 2); 
% Green triangle (top)
fill([0.5, 0.475, 0.525], [sqrt(3)/2, 0.95*sqrt(3)/2, 0.95*sqrt(3)/2], 'g', 'EdgeColor', 'k', 'LineWidth', 2); 



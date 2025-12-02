clear;clc

%% load weights
count = 0;

load ../PatchBrightness/Code/Results/nonChromaVariationExperiment/LaboratoryTest/WeightFitting.mat;
count = count+1;
weights(count,:) = WeightFitting.meanFit.OptimalMaxWeight;
DatasetLabel{count,1} = 'Fixed-chroma Test';

load ../PatchBrightness/Code/Results/nonChromaVariationExperiment/LaboratoryRetest/WeightFitting.mat;
count = count+1;
weights(count,:) = WeightFitting.meanFit.OptimalMaxWeight;
DatasetLabel{count,1} = 'Fixed-chroma Retest';

load ../PatchBrightness/Code/Results/nonChromaVariationExperiment/HomeTest/WeightFitting.mat;
count = count+1;
weights(count,:) = WeightFitting.meanFit.OptimalMaxWeight;
DatasetLabel{count,1} = 'Fixed-chroma Home Session';

load ../PatchBrightness/Code/Results/nonChromaVariationExperiment/ProlificTest/WeightFitting.mat;
count = count+1;
weights(count,:) = WeightFitting.meanFit.OptimalMaxWeight;
DatasetLabel{count,1} = 'Fixed-chroma Online Session (Black Background)';

load ../PatchBrightness/Code/Results/nonChromaVariationExperiment/ProlificTest_GrayBackground/WeightFitting.mat;
count = count+1;
weights(count,:) = WeightFitting.meanFit.OptimalMaxWeight;
DatasetLabel{count,1} = 'Fixed-chroma Online Session (Gray Background)';

load ../PatchBrightness/Code/Results/nonChromaVariationExperiment/ProlificTest_WhiteBackground/WeightFitting.mat;
count = count+1;
weights(count,:) = WeightFitting.meanFit.OptimalMaxWeight;
DatasetLabel{count,1} = 'Fixed-chroma Online Session (White Background)';

load ../PatchBrightness/Code/Results/ChromaVariationExperiment/LaboratoryTest/WeightFitting.mat;
count = count+1;
weights(count,:) = WeightFitting.meanFit.OptimalMaxWeight;
DatasetLabel{count,1} = 'Chroma-variation Laboratory Session';

load ../PatchBrightness/Code/Results/ChromaVariationExperiment/HomeTest/WeightFitting.mat;
count = count+1;
weights(count,:) = WeightFitting.meanFit.OptimalMaxWeight;
DatasetLabel{count,1} = 'Chroma-variation Home Session';

load ../PatchBrightness/Code/Results/ChromaVariationExperiment/ProlificTest/WeightFitting.mat;
count = count+1;
weights(count,:) = WeightFitting.meanFit.OptimalMaxWeight;
DatasetLabel{count,1} = 'Chroma-variation Online Session';

load ../IlluminationBrightness/RawData/LightingData.mat;
count = count+1;
weights(count,:) = MaxWeights;
DatasetLabel{count,1} = 'Real-world Lighting';

count = count+1;
weights(count,:) = [1, 1.02, 0.42];
DatasetLabel{count,1} = 'Brightness Ranking in SSVEP Experiment';

count = count+1;
weights(count,:) = [1, 0.68, 0.68];
DatasetLabel{count,1} = '3Hz SSVEP';

count = count+1;
weights(count,:) = [1, 4, 0.26];
DatasetLabel{count,1} = '15Hz SSVEP';

load ../PatchBrightness/Code/OLEDparas/oled_weights.mat;
count = count+1;
weights(count,:) = oled_weights.LumWeight/oled_weights.LumWeight(1);
DatasetLabel{count,1} = 'Luminance';

count = count+1;
weights(count,:) = oled_weights.RadWeight/oled_weights.RadWeight(1);
DatasetLabel{count,1} = 'Radiance';

count = count+1;
weights(count,:) = [1,1,1];
DatasetLabel{count,1} = 'Equipollent';




% Define dot colors based on categories
dot_colors = [
    0.2, 0.7, 0.2;   
    1, 0.5, 0;       
    1, 0, 0;         
    1, 0, 1;         
    0, 0, 1;        
    0.75, 0.00, 0.75;
    0, 1, 1;         
    1, 1, 0;         
    0.6, 0.3, 0.1;   
    0.6, 0.6, 1.00;  
    0, 0, 0;         
    0.5, 0.5, 0.5;   
    1,0.7,1];   


% Define the distances a, b, c to the three sides (you can set these values)
wR = weights(:,1)./sum(weights,2); % Distance to the second side (LEFT)
wG = weights(:,2)./sum(weights,2);  % Distance to the third side (BOTTOM)
wB = weights(:,3)./sum(weights,2);  % Distance to the first side (RIGHT)

% Define the vertices of the equilateral triangle
triangle_x = [0, 1, 0.5, 0];         % X-coordinates of the main triangle
triangle_y = [0, 0, sqrt(3)/2, 0];   % Y-coordinates (equilateral triangle height)

% Calculate the coordinates of the point using barycentric coordinates
x_dot = wB * triangle_x(1) + wR * triangle_x(2) + wG * triangle_x(3);
y_dot = wB * triangle_y(1) + wR * triangle_y(2) + wG * triangle_y(3);



figure;
hold on;

% Plot the dots inside the triangle
% Adjust the scatter plot to be included in the legend individually for each dot
for i = 1:length(DatasetLabel)-3
    scatter_handle(i) = scatter(x_dot(i), y_dot(i), 240, dot_colors(i, :), 'filled', 'MarkerEdgeColor', 'k', 'LineWidth', 1);
end


axis equal;
box off
xticks([]);
xticklabels([]);
yticks([]);
yticklabels([]);


%% Luminance
lum_handle = plot(x_dot(length(DatasetLabel)-2),y_dot(length(DatasetLabel)-2),'v', 'MarkerFaceColor', 'g','MarkerEdgeColor', 'g','MarkerSize',16,'LineWidth',0.5)

%% Radiance
rad_handle = plot(x_dot(length(DatasetLabel)-1),y_dot(length(DatasetLabel)-1),'v', 'MarkerFaceColor', 'b','MarkerEdgeColor', 'b','MarkerSize',16,'LineWidth',0.5);

%% Equipollent
eqp_handle = plot(x_dot(length(DatasetLabel)),y_dot(length(DatasetLabel)),'s', 'MarkerFaceColor', 'none','MarkerEdgeColor', 'k','MarkerSize',16,'LineWidth',2)

%% Add Legend
legend([scatter_handle lum_handle rad_handle eqp_handle], DatasetLabel)  % choose which handles to include

% legend(DatasetLabel, 'Location', 'EastOutside', 'FontSize', 12);

% Calculate distances to the three sides
d_bottom = abs(y_dot);  % Distance to the bottom side y = 0
d_left = abs(sqrt(3) * x_dot - y_dot) / 2;  
d_right = abs(sqrt(3) * x_dot + y_dot - sqrt(3)) / 2;  

% Draw the main white equilateral triangle
plot(triangle_x, triangle_y, 'k-', 'LineWidth', 2);

% Draw small Red, Green, and Blue triangles at the corners
% Blue triangle (bottom-left)
fill([0, 0.05, 0.025], [0, 0, 0.025 * sqrt(3)], 'b', 'EdgeColor', 'k', 'LineWidth', 2); 
% Red triangle (bottom-right)
fill([1, 0.95, 0.975], [0, 0, 0.025 * sqrt(3)], 'r', 'EdgeColor', 'k', 'LineWidth', 2); 
% Green triangle (top)
fill([0.5, 0.475, 0.525], [sqrt(3)/2, 0.95*sqrt(3)/2, 0.95*sqrt(3)/2], 'g', 'EdgeColor', 'k', 'LineWidth', 2);
set(gcf,'Position',[0,0,1600,1600])


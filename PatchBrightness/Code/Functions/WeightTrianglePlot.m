function WeightTrianglePlot(LuminanceWeight,RadianceWeight,weights,dot_colors,labels)

% Define the vertices of the equilateral triangle
triangle_x = [0, 1, 0.5, 0];         % X-coordinates of the main triangle
triangle_y = [0, 0, sqrt(3)/2, 0];   % Y-coordinates (equilateral triangle height)

figure;
hold on;


% Define the distances a, b, c to the three sides (you can set these values)
wR = weights(:,1)./sum(weights,2); % Distance to the second side (LEFT)
wG = weights(:,2)./sum(weights,2);  % Distance to the third side (BOTTOM)
wB = weights(:,3)./sum(weights,2);  % Distance to the first side (RIGHT)



% Calculate the coordinates of the point using barycentric coordinates
x_dot = wB * triangle_x(1) + wR * triangle_x(2) + wG * triangle_x(3);
y_dot = wB * triangle_y(1) + wR * triangle_y(2) + wG * triangle_y(3);


% Plot the dots inside the triangle
% Adjust the scatter plot to be included in the legend individually for each dot
for i = 1:length(dot_colors)
    scatter_handle(i) = scatter(x_dot(i), y_dot(i), 160, dot_colors(i, :), 'filled', 'MarkerEdgeColor', 'k', 'LineWidth', 1);
end


%% Luminance
Luminance_x = LuminanceWeight(3) * triangle_x(1) + LuminanceWeight(1) * triangle_x(2) + LuminanceWeight(2) * triangle_x(3);
Luminance_y = LuminanceWeight(3) * triangle_y(1) + LuminanceWeight(1) * triangle_y(2) + LuminanceWeight(2) * triangle_y(3);

lum_handle = plot(Luminance_x,Luminance_y,'v', 'MarkerFaceColor', 'g','MarkerEdgeColor', 'g','MarkerSize',16,'LineWidth',0.5)


%% Radiance
Radiance_x = RadianceWeight(3) * triangle_x(1) + RadianceWeight(1) * triangle_x(2) + RadianceWeight(2) * triangle_x(3);
Radiance_y = RadianceWeight(3) * triangle_y(1) + RadianceWeight(1) * triangle_y(2) + RadianceWeight(2) * triangle_y(3);

rad_handle = plot(Radiance_x,Radiance_y,'v', 'MarkerFaceColor', 'b','MarkerEdgeColor', 'b','MarkerSize',16,'LineWidth',0.5)


%% Equipollent
eqp_handle = plot(0.5,0.5/sqrt(3),'s', 'MarkerFaceColor', 'none','MarkerEdgeColor', 'k','MarkerSize',16,'LineWidth',2)

%% Add Legend
labels(end+1:end+3,1) =   {'Luminance';'Radiance';'Equipollent'};
legend(labels, 'Location', 'EastOutside', 'FontSize', 12);


axis equal;
box off
xticks([]);
xticklabels([]);
yticks([]);
yticklabels([]);

% Draw the main white equilateral triangle
plot(triangle_x, triangle_y, 'k-', 'LineWidth', 2, 'HandleVisibility', 'off');

% Draw small Red, Green, and Blue triangles at the corners
% Blue triangle (bottom-left)
fill([0, 0.05, 0.025], [0, 0, 0.025 * sqrt(3)], 'b', 'EdgeColor', 'k', 'LineWidth', 2, 'HandleVisibility', 'off'); 
% Red triangle (bottom-right)
fill([1, 0.95, 0.975], [0, 0, 0.025 * sqrt(3)], 'r', 'EdgeColor', 'k', 'LineWidth', 2, 'HandleVisibility', 'off'); 
% Green triangle (top)
fill([0.5, 0.475, 0.525], [sqrt(3)/2, 0.95*sqrt(3)/2, 0.95*sqrt(3)/2], 'g', 'EdgeColor', 'k', 'LineWidth', 2, 'HandleVisibility', 'off');

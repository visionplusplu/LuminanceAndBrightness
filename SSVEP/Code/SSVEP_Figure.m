% Produce the SSVEP figure from data 

%----------------------- Load data -----------------------%
% data from individual observers
load ../Data/ssvep_data_all_observers.mat;

%---------------- Monitor luminance & contrasts ----------%
lum_rgb = [16.5 59 8.7];                     % cd/m^2, [R G B]
contrast_levels = [0.125 0.25 0.375 0.5];    % 4 contrast steps

% Different colors (1-R, 2-G, 3-B, 4-RG, 5-RB, 6-GB, 7-RGB)
con_r     = contrast_levels * lum_rgb(1);
con_g     = contrast_levels * lum_rgb(2);
con_b     = contrast_levels * lum_rgb(3);
con_rg    = contrast_levels * sum(lum_rgb(1:2));
con_rb    = contrast_levels * sum(lum_rgb([1 3]));
con_gb    = contrast_levels * sum(lum_rgb(2:3));
con_white = contrast_levels * sum(lum_rgb);

% Same contrasts on 0¨C255 scale 
con_255 = contrast_levels * 255;

%-------------------- Aesthetics -------------------------%
text_x = -0.15; text_y = 1.1;                 % panel letters A/B/C
xrange_lum   = [0.7 50];
xrange_maxrg = [28 144];
yrange       = [-1 2.3];
tick_con_lum = [1 2.5 5 10 20 40 80];
tick_con_mrg = [32 64 96 128];

%---------------- Mean across observers -----------------%
% this is SSVEP response at 3 Hz
ssvep3_mean  = mean(ssvep_3Hz_all,  3);   % 7 x 4
% this is SSVEP response at 15 Hz
ssvep15_mean = mean(ssvep_15Hz_all, 3);   % 7 x 4

%========================================================%
hfig = figure;

%====================== Panel B =========================%
subplot(132);
set(gca,'FontSize',14);

xx = [con_r con_g con_b con_rg con_rb con_gb con_white];  % 1 x 28
yy = reshape(ssvep3_mean.', 1, []);                       % 1 x 28 (transpose then vectorize)

coeff = polyfit(log(xx), yy, 1);
xfit  = 1:0.1:50;
yfit  = polyval(coeff, log(xfit));
semilogx(xfit, yfit, '--', 'Color', [.7 .7 .7], 'LineWidth', 6); hold on;

[r_val, p_val] = corr(log(xx)', yy'); 
unexplained_var = round((1 - r_val^2) * 10000) / 100;   % percent
text(0.1, 0.95, ['unexplained: ' num2str(unexplained_var) '%'], ...
    'Units','normalized','FontSize',14,'Color',[.5 .5 .5],'FontAngle','italic');

h1 = semilogx(con_r,     ssvep3_mean(1,:), '-*', 'LineWidth',2, 'Color',[1 0 0]);  hold on;
h2 = semilogx(con_g,     ssvep3_mean(2,:), '-*', 'LineWidth',2, 'Color',[0 1 0]);
h3 = semilogx(con_b,     ssvep3_mean(3,:), '-*', 'LineWidth',2, 'Color',[0 0 1]);
h4 = semilogx(con_rg,    ssvep3_mean(4,:), '-*', 'LineWidth',2, 'Color',[1 1 0]);
h5 = semilogx(con_rb,    ssvep3_mean(5,:), '-*', 'LineWidth',2, 'Color',[1 0 1]);
h6 = semilogx(con_gb,    ssvep3_mean(6,:), '-*', 'LineWidth',2, 'Color',[0 1 1]);
h7 = semilogx(con_white, ssvep3_mean(7,:), '-*', 'LineWidth',2, 'Color',[0 0 0]);

title('3 Hz','FontSize',28);
xlabel('Luminance (cd/m^2)');
xlim(xrange_lum); ylim(yrange);
set(gca,'XTick',tick_con_lum,'XTickLabel',tick_con_lum,'YTick',-1:1:2);
text(text_x, text_y, 'B', 'Units','normalized', 'FontSize',25);
box off

%====================== Panel A =========================%
subplot(131);
set(gca,'FontSize',14);

xx = [con_r con_g con_b con_rg con_rb con_gb con_white];
yy = reshape(ssvep15_mean.', 1, []);

coeff = polyfit(log(xx), yy, 1);
xfit  = 1:0.1:50;
yfit  = polyval(coeff, log(xfit));
semilogx(xfit, yfit, '--', 'Color', [.7 .7 .7], 'LineWidth', 6); hold on;

[r_val, p_val] = corr(log(xx)', yy'); 
unexplained_var = round((1 - r_val^2) * 10000) / 100;
text(0.1, 0.95, ['unexplained: ' num2str(unexplained_var) '%'], ...
    'Units','normalized','FontSize',14,'Color',[.5 .5 .5],'FontAngle','italic');

h1 = semilogx(con_r,     ssvep15_mean(1,:), '-*', 'LineWidth',2, 'Color',[1 0 0]); hold on;
h2 = semilogx(con_g,     ssvep15_mean(2,:), '-*', 'LineWidth',2, 'Color',[0 1 0]);
h3 = semilogx(con_b,     ssvep15_mean(3,:), '-*', 'LineWidth',2, 'Color',[0 0 1]);
h4 = semilogx(con_rg,    ssvep15_mean(4,:), '-*', 'LineWidth',2, 'Color',[1 1 0]);
h5 = semilogx(con_rb,    ssvep15_mean(5,:), '-*', 'LineWidth',2, 'Color',[1 0 1]);
h6 = semilogx(con_gb,    ssvep15_mean(6,:), '-*', 'LineWidth',2, 'Color',[0 1 1]);
h7 = semilogx(con_white, ssvep15_mean(7,:), '-*', 'LineWidth',2, 'Color',[0 0 0]);

title('15 Hz','FontSize',28);
xlabel('Luminance (cd/m^2)'); ylabel('SSVEP amplitude (\muV)');
xlim(xrange_lum); ylim(yrange);
set(gca,'XTick',tick_con_lum,'XTickLabel',tick_con_lum,'YTick',-1:1:2);

text(text_x, text_y, 'A', 'Units','normalized', 'FontSize',25);

hL = legend([h1 h2 h3 h4 h5 h6 h7], 'R','G','B','RG','RB','GB','RGB');
set(hL,'Box','off','Location','southeast');
ap = get(hL,'Position'); set(hL,'Position',[ap(1)+0.07 ap(2)+0.06 ap(3:4)]);
box off

%====================== Panel C =========================%
subplot(133);
set(gca,'FontSize',14);

% Build MaxRGB
cvals = round(con_255);
con_cie = zeros(7,4);
for i = 1:4
    v = cvals(i);
    k1 = max([v 0 0]);  % R
    k2 = max([0 v 0]);  % G
    k3 = max([0 0 v]);  % B
    k4 = max([v v 0]);  % RG
    k5 = max([v 0 v]);  % RB
    k6 = max([0 v v]);  % GB
    k7 = max([v v v]);  % RGB
    con_cie(:,i) = [k1;k2;k3;k4;k5;k6;k7];
end

xx = reshape(con_cie.', 1, []);      % 1 x 28
yy = reshape(ssvep3_mean.', 1, []);  % 1 x 28

coeff = polyfit(log(xx), yy, 1);
xfit  = 30:0.1:140;
yfit  = polyval(coeff, log(xfit));
semilogx(xfit, yfit, '--', 'Color', [.7 .7 .7], 'LineWidth', 6); hold on;

[r_val, p_val] = corr(log(xx)', yy'); 
unexplained_var = round((1 - r_val^2) * 10000) / 100;
text(0.1, 0.95, ['unexplained: ' num2str(unexplained_var) '%'], ...
    'Units','normalized','FontSize',14,'Color',[.5 .5 .5],'FontAngle','italic');

% Series
semilogx(con_cie(1,:), ssvep3_mean(1,:), '-*', 'LineWidth',2, 'Color',[1 0 0]); hold on;
semilogx(con_cie(2,:), ssvep3_mean(2,:), '-*', 'LineWidth',2, 'Color',[0 1 0]);
semilogx(con_cie(3,:), ssvep3_mean(3,:), '-*', 'LineWidth',2, 'Color',[0 0 1]);
semilogx(con_cie(4,:), ssvep3_mean(4,:), '-*', 'LineWidth',2, 'Color',[1 1 0]);
semilogx(con_cie(5,:), ssvep3_mean(5,:), '-*', 'LineWidth',2, 'Color',[1 0 1]);
semilogx(con_cie(6,:), ssvep3_mean(6,:), '-*', 'LineWidth',2, 'Color',[0 1 1]);
semilogx(con_cie(7,:), ssvep3_mean(7,:), '-*', 'LineWidth',2, 'Color',[0 0 0]);

title('3 Hz','FontSize',28);
xlabel('MaxRGB');
xlim(xrange_maxrg); ylim(yrange);
set(gca,'XTick',tick_con_mrg,'XTickLabel',tick_con_mrg,'YTick',-1:1:2);
text(text_x, text_y, 'C', 'Units','normalized', 'FontSize',25);
box off

%------------------- Final sizing -----------------------%
set(hfig,'Position',[50 435 1362 393]);

% plot2svg('CIERGB_SSVEP_low_contrast.svg');  % if you need SVG export

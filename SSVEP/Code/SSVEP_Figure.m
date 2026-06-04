% Produce the SSVEP figure from data 

%----------------------- Load data -----------------------%
% data from individual observers
load ../Data/ssvep_data_all_observers.mat

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

%====================== Panel B =========================%
figure("Name",'Fig. 3B','NumberTitle','off');
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
box off
axis square

%====================== Panel A =========================%
figure("Name",'Fig. 3A','NumberTitle','off');
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
axis square

hL = legend([h1 h2 h3 h4 h5 h6 h7], 'R','G','B','RG','RB','GB','RGB');
set(hL,'Box','off','Location','southeast');
ap = get(hL,'Position'); set(hL,'Position',[ap(1)+0.07 ap(2)+0.06 ap(3:4)]);
box off

%====================== Panel C =========================%
figure("Name",'Fig. 3C','NumberTitle','off');
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
box off
axis square


%% Figure in Supplementary
%========================================================%
%====================== Panel F =========================%
% 15Hz with maxRGB
figure("Name","fig. S8F",'NumberTitle','off');
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
yy = reshape(ssvep15_mean.', 1, []);  % 1 x 28

coeff = polyfit(log(xx), yy, 1);
xfit  = 30:0.1:140;
yfit  = polyval(coeff, log(xfit));
semilogx(xfit, yfit, '--', 'Color', [.7 .7 .7], 'LineWidth', 6); hold on;

[r_val, p_val] = corr(log(xx)', yy'); 
unexplained_var = round((1 - r_val^2) * 10000) / 100;
text(0.1, 0.95, ['unexplained: ' num2str(unexplained_var) '%'], ...
    'Units','normalized','FontSize',14,'Color',[.5 .5 .5],'FontAngle','italic');

% Series
semilogx(con_cie(1,:), ssvep15_mean(1,:), '-*', 'LineWidth',2, 'Color',[1 0 0]); hold on;
semilogx(con_cie(2,:), ssvep15_mean(2,:), '-*', 'LineWidth',2, 'Color',[0 1 0]);
semilogx(con_cie(3,:), ssvep15_mean(3,:), '-*', 'LineWidth',2, 'Color',[0 0 1]);
semilogx(con_cie(4,:), ssvep15_mean(4,:), '-*', 'LineWidth',2, 'Color',[1 1 0]);
semilogx(con_cie(5,:), ssvep15_mean(5,:), '-*', 'LineWidth',2, 'Color',[1 0 1]);
semilogx(con_cie(6,:), ssvep15_mean(6,:), '-*', 'LineWidth',2, 'Color',[0 1 1]);
semilogx(con_cie(7,:), ssvep15_mean(7,:), '-*', 'LineWidth',2, 'Color',[0 0 0]);

title('15 Hz','FontSize',28);
xlabel('MaxRGB');
xlim(xrange_maxrg); ylim(yrange);
set(gca,'XTick',tick_con_mrg,'XTickLabel',tick_con_mrg,'YTick',-1:1:2);
box off
axis square


%==========================MaxDKL==============================%
NormalizedDKL = [0.0376073437962689,0.250000000000000,0.0712326120795356;
    0.0997927154278946,0.500000000000000,0.142465224159071;
    0.161978087059520,0.750000000000000,0.213697836238607;
    0.224163458691146,1,0.284930448318142;
    0.144803079656500,0.168236830970012,0.178767387920465;
    0.314184187148357,0.336473661940025,0.357534775840929;
    0.483565294640213,0.504710492910037,0.536302163761394;
    0.652946402132070,0.672947323880050,0.715069551681858;
    0,0.0817631690299876,0.250000000000000;
    0.0245780278353568,0.163526338059975,0.500000000000000;
    0.0491560556707137,0.245289507089963,0.750000000000000;
    0.0737340835060705,0.327052676119950,1;
    0.206988451288126,0.0817631690299876,0.250000000000000;
    0.438554930411608,0.163526338059975,0.500000000000000;
    0.670121409535090,0.245289507089963,0.750000000000000;
    0.901687888658573,0.327052676119950,1;
    0.0621853716316257,0.168236830970012,0.178767387920465;
    0.148948771098608,0.336473661940025,0.357534775840929;
    0.235712170565591,0.504710492910037,0.536302163761394;
    0.322475570032573,0.672947323880050,0.715069551681858;
    0.169381107491857,0.250000000000000,0.0712326120795356;
    0.363340242819070,0.500000000000000,0.142465224159071;
    0.557299378146284,0.750000000000000,0.213697836238607;
    0.751258513473497,1,0.284930448318142;
    0.231566479123482,0,0;0.487710986082322,0,0;
    0.743855493041161,7.57697407549186e-18,0;
    1,7.57697407549186e-18,0];

a=max(NormalizedDKL,[],2);
con_dkl = reshape(a,4,7)';

%====================== Panel G =========================%
% 15Hz with maxDKL
figure("Name","fig. S8G",'NumberTitle','off');
set(gca,'FontSize',14);

xx = reshape(con_dkl', 1, []);      % 1 x 28
yy = reshape(ssvep15_mean.', 1, []);  % 1 x 28

coeff = polyfit(log(xx), yy, 1);
xfit  = 0:0.1:1;
yfit  = polyval(coeff, log(xfit));
semilogx(xfit, yfit, '--', 'Color', [.7 .7 .7], 'LineWidth', 6); hold on;

[r_val, p_val] = corr(log(xx)', yy'); 
unexplained_var = round((1 - r_val^2) * 10000) / 100;
text(0.1, 0.95, ['unexplained: ' num2str(unexplained_var) '%'], ...
    'Units','normalized','FontSize',14,'Color',[.5 .5 .5],'FontAngle','italic');

% Series
semilogx(con_dkl(1,:), ssvep15_mean(1,:), '-*', 'LineWidth',2, 'Color',[1 0 0]); hold on;
semilogx(con_dkl(2,:), ssvep15_mean(2,:), '-*', 'LineWidth',2, 'Color',[0 1 0]);
semilogx(con_dkl(3,:), ssvep15_mean(3,:), '-*', 'LineWidth',2, 'Color',[0 0 1]);
semilogx(con_dkl(4,:), ssvep15_mean(4,:), '-*', 'LineWidth',2, 'Color',[1 1 0]);
semilogx(con_dkl(5,:), ssvep15_mean(5,:), '-*', 'LineWidth',2, 'Color',[1 0 1]);
semilogx(con_dkl(6,:), ssvep15_mean(6,:), '-*', 'LineWidth',2, 'Color',[0 1 1]);
semilogx(con_dkl(7,:), ssvep15_mean(7,:), '-*', 'LineWidth',2, 'Color',[0 0 0]);

title('15 Hz','FontSize',28);
xlabel('MaxDKL');
xlim([0.15 1.1]);
ylim(yrange);
set(gca,'XTick',0.2:0.2:0.8,'xticklabel',0.2:0.2:0.8,'YTick',-1:1:2);
axis square

box off

%====================== Panel H =========================%
% 3Hz with maxDKL
figure("Name","fig. S8H",'NumberTitle','off');
set(gca,'FontSize',14);

xx = reshape(con_dkl', 1, []);      % 1 x 28
yy = reshape(ssvep3_mean.', 1, []);  % 1 x 28

coeff = polyfit(log(xx), yy, 1);
xfit  = 0:0.1:1;
yfit  = polyval(coeff, log(xfit));
semilogx(xfit, yfit, '--', 'Color', [.7 .7 .7], 'LineWidth', 6); hold on;

[r_val, p_val] = corr(log(xx)', yy'); 
unexplained_var = round((1 - r_val^2) * 10000) / 100;
text(0.1, 0.95, ['unexplained: ' num2str(unexplained_var) '%'], ...
    'Units','normalized','FontSize',14,'Color',[.5 .5 .5],'FontAngle','italic');

% Series
semilogx(con_dkl(1,:), ssvep3_mean(1,:), '-*', 'LineWidth',2, 'Color',[1 0 0]); hold on;
semilogx(con_dkl(2,:), ssvep3_mean(2,:), '-*', 'LineWidth',2, 'Color',[0 1 0]);
semilogx(con_dkl(3,:), ssvep3_mean(3,:), '-*', 'LineWidth',2, 'Color',[0 0 1]);
semilogx(con_dkl(4,:), ssvep3_mean(4,:), '-*', 'LineWidth',2, 'Color',[1 1 0]);
semilogx(con_dkl(5,:), ssvep3_mean(5,:), '-*', 'LineWidth',2, 'Color',[1 0 1]);
semilogx(con_dkl(6,:), ssvep3_mean(6,:), '-*', 'LineWidth',2, 'Color',[0 1 1]);
semilogx(con_dkl(7,:), ssvep3_mean(7,:), '-*', 'LineWidth',2, 'Color',[0 0 0]);

title('3 Hz','FontSize',28);
xlabel('MaxDKL');
xlim([0.15 1.1]);
ylim(yrange);
set(gca,'XTick',0.2:0.2:0.8,'xticklabel',0.2:0.2:0.8,'YTick',-1:1:2);
box off
axis square

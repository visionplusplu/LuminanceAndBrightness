function DNN_Fig(DNNpath,MeanRanking,corrRGB)
%% --- Three-model 1x3 subplot (MATLAB 2007 compatible) ---

%======== Model config ========%

% --- First 3 baseline models ---
models(1).name   = 'ResNet-18';
models(1).start  = [DNNpath,'/standard_networks/predictions_resnet18'];
models(1).layers = {'block0','block1','block2','block3','block4','fc'};
models(1).iblock = 1;

models(2).name   = 'AlexNet';
models(2).start  = [DNNpath,'/standard_networks/predictions_alexnet'];
models(2).layers = {'feature0','feature1','feature12','classifier1','fc'};
models(2).iblock = 1;

models(3).name   = 'VGG-11';
models(3).start  = [DNNpath,'/standard_networks/predictions_vgg11'];
models(3).layers = {'feature0','feature1','feature20','classifier0'};
models(3).iblock = 2;

% --- Taskonomy models: get best block (lowest accuracy) per model ---
load ([DNNpath,'/taskonomy.mat']);  % must contain 'accuracy_table' (24x6)
[tmp, iblock_taskonomy] = min(accuracy_table, [], 2);   % 24x1 (values 1..6)
task_layers = {'block0','block1','block2','block3','block4','encoder'};

% Indices 4..27 correspond to taskonomy "itask" 1..24 in the order below.

% 1) class_object
models(4).name   = 'Taskonomy: class object';
models(4).start  = [DNNpath,'/taskonomy_networks/predictions_taskonomy_class_object'];
models(4).layers = task_layers;
models(4).iblock = iblock_taskonomy(1);

% 2) class_scene
models(5).name   = 'Taskonomy: class scene';
models(5).start  = [DNNpath,'/taskonomy_networks/predictions_taskonomy_class_scene'];
models(5).layers = task_layers;
models(5).iblock = iblock_taskonomy(2);

% 3) segment_semantic
models(6).name   = 'Taskonomy: segment semantic';
models(6).start  = [DNNpath,'/taskonomy_networks/predictions_taskonomy_segment_semantic'];
models(6).layers = task_layers;
models(6).iblock = iblock_taskonomy(3);

% 4) nonfixated_pose
models(7).name   = 'Taskonomy: nonfixated pose';
models(7).start  = [DNNpath,'/taskonomy_networks/predictions_taskonomy_nonfixated_pose'];
models(7).layers = task_layers;
models(7).iblock = iblock_taskonomy(4);

% 5) point_matching
models(8).name   = 'Taskonomy: point matching';
models(8).start  = [DNNpath,'/taskonomy_networks/predictions_taskonomy_point_matching'];
models(8).layers = task_layers;
models(8).iblock = iblock_taskonomy(5);

% 6) egomotion
models(9).name   = 'Taskonomy: egomotion';
models(9).start  = [DNNpath,'/taskonomy_networks/predictions_taskonomy_egomotion'];
models(9).layers = task_layers;
models(9).iblock = iblock_taskonomy(6);

% 7) fixated_pose
models(10).name   = 'Taskonomy: fixated pose';
models(10).start  = [DNNpath,'/taskonomy_networks/predictions_taskonomy_fixated_pose'];
models(10).layers = task_layers;
models(10).iblock = iblock_taskonomy(7);

% 8) curvature
models(11).name   = 'Taskonomy: curvature';
models(11).start  = [DNNpath,'/taskonomy_networks/predictions_taskonomy_curvature'];
models(11).layers = task_layers;
models(11).iblock = iblock_taskonomy(8);

% 9) edge_occlusion
models(12).name   = 'Taskonomy: edge occlusion';
models(12).start  = [DNNpath,'/taskonomy_networks/predictions_taskonomy_edge_occlusion'];
models(12).layers = task_layers;
models(12).iblock = iblock_taskonomy(9);

% 10) keypoints3d
models(13).name   = 'Taskonomy: keypoints3d';
models(13).start  = [DNNpath,'/taskonomy_networks/predictions_taskonomy_keypoints3d'];
models(13).layers = task_layers;
models(13).iblock = iblock_taskonomy(10);

% 11) depth_zbuffer
models(14).name   = 'Taskonomy: depth zbuffer';
models(14).start  = [DNNpath,'/taskonomy_networks/predictions_taskonomy_depth_zbuffer'];
models(14).layers = task_layers;
models(14).iblock = iblock_taskonomy(11);

% 12) segment_unsup25d
models(15).name   = 'Taskonomy: segment unsup25d';
models(15).start  = [DNNpath,'/taskonomy_networks/predictions_taskonomy_segment_unsup25d'];
models(15).layers = task_layers;
models(15).iblock = iblock_taskonomy(12);

% 13) normal
models(16).name   = 'Taskonomy: normal';
models(16).start  = [DNNpath,'/taskonomy_networks/predictions_taskonomy_normal'];
models(16).layers = task_layers;
models(16).iblock = iblock_taskonomy(13);

% 14) depth_euclidean
models(17).name   = 'Taskonomy: depth euclidean';
models(17).start  = [DNNpath,'/taskonomy_networks/predictions_taskonomy_depth_euclidean'];
models(17).layers = task_layers;
models(17).iblock = iblock_taskonomy(14);

% 15) reshading
models(18).name   = 'Taskonomy: reshading';
models(18).start  = [DNNpath,'/taskonomy_networks/predictions_taskonomy_reshading'];
models(18).layers = task_layers;
models(18).iblock = iblock_taskonomy(15);

% 16) vanishing_point
models(19).name   = 'Taskonomy: vanishing point';
models(19).start  = [DNNpath,'/taskonomy_networks/predictions_taskonomy_vanishing_point'];
models(19).layers = task_layers;
models(19).iblock = iblock_taskonomy(16);

% 17) room_layout
models(20).name   = 'Taskonomy: room layout';
models(20).start  = [DNNpath,'/taskonomy_networks/predictions_taskonomy_room_layout'];
models(20).layers = task_layers;
models(20).iblock = iblock_taskonomy(17);

% 18) keypoints2d
models(21).name   = 'Taskonomy: keypoints2d';
models(21).start  = [DNNpath,'/taskonomy_networks/predictions_taskonomy_keypoints2d'];
models(21).layers = task_layers;
models(21).iblock = iblock_taskonomy(18);

% 19) edge_texture
models(22).name   = 'Taskonomy: edge texture';
models(22).start  = [DNNpath,'/taskonomy_networks/predictions_taskonomy_edge_texture'];
models(22).layers = task_layers;
models(22).iblock = iblock_taskonomy(19);

% 20) jigsaw
models(23).name   = 'Taskonomy: jigsaw';
models(23).start  = [DNNpath,'/taskonomy_networks/predictions_taskonomy_jigsaw'];
models(23).layers = task_layers;
models(23).iblock = iblock_taskonomy(20);

% 21) autoencoding
models(24).name   = 'Taskonomy: autoencoding';
models(24).start  = [DNNpath,'/taskonomy_networks/predictions_taskonomy_autoencoding'];
models(24).layers = task_layers;
models(24).iblock = iblock_taskonomy(21);

% 22) denoising
models(25).name   = 'Taskonomy: denoising';
models(25).start  = [DNNpath,'/taskonomy_networks/predictions_taskonomy_denoising'];
models(25).layers = task_layers;
models(25).iblock = iblock_taskonomy(22);

% 23) segment_unsup2d
models(26).name   = 'Taskonomy: segment unsup2d';
models(26).start  = [DNNpath,'/taskonomy_networks/predictions_taskonomy_segment_unsup2d'];
models(26).layers = task_layers;
models(26).iblock = iblock_taskonomy(23);

% 24) inpainting
models(27).name   = 'Taskonomy: inpainting';
models(27).start  = [DNNpath,'/taskonomy_networks/predictions_taskonomy_inpainting'];
models(27).layers = task_layers;
models(27).iblock = iblock_taskonomy(24);

DNNs_144Patches = [];

%======== Shared data (loaded once) ========%
% Requires: human_ground_truth in workspace or file

human_ground_truth = csvread([DNNpath,'/pairs_human_ground_truth.csv']);

ValidLoc = find(isnan(MeanRanking)~=1);
Target_corrRGBList = double(reshape(corrRGB, [], 3));  % 144x3

%======== Figure ========%
hfig=figure('Color','w');
tl = tiledlayout(7,4,'TileSpacing','compact','Padding','compact');  % or 'none','tight'

%======== Loop over models ========%
for m = 1:length(models)
    fileNameStart = models(m).start;
    layers        = models(m).layers;
    iblock        = models(m).iblock;

    % Select layer and load corresponding predictions matrix
    layer = layers{iblock};
    filename = sprintf('%s_%s.csv', fileNameStart, layer);

    data = importdata(filename);
    preds_matrix = data.data;                        % [nPairs x nRuns]
    [tmp, nRuns] = size(preds_matrix);

    % Compute DNN win counts across colors for each run, then average
    nColors = 144;
    win_count = [];                                  % [nColors x nRuns]
    accuracies = zeros(1,nRuns);                     % kept for reference

    for run = 1:nRuns
        preds = preds_matrix(:, run);
        accuracies(run) = mean(preds == human_ground_truth);

        % Build winner-loser pairs according to preds
        pair_NUM = []; % rows: [winner loser]
        ii = 0;
        for iii = 1:(nColors-1)
            for jjj = (iii+1):nColors
                ii = ii + 1;
                if preds(ii,1) == 1
                    pair_NUM = [pair_NUM; [iii jjj]];
                else
                    pair_NUM = [pair_NUM; [jjj iii]];
                end
            end
        end

        % Win counts for this run
        wins = accumarray(pair_NUM(:,1), 1, [nColors 1]);
        win_count = [win_count, wins];
    end

    % Average win count ranking across runs
    win_count_ranking = mean(win_count, 2);
    
    DNNs_144Patches = [DNNs_144Patches; win_count_ranking'];
    %======== Subplot for this model ========%
    nexttile; hold on;

    for k = 1:length(ValidLoc)
        idx = ValidLoc(k);
        plot( win_count_ranking(idx), ...
              MeanRanking(idx), ...
              '.', 'MarkerSize', 28, 'LineWidth', 1.5, ...
              'Color', Target_corrRGBList(idx,:)/255 );
    end

    % Spearman correlation and unexplained variance
    [corrCoef, p_val] = corr(MeanRanking(ValidLoc), ...
                             win_count_ranking(ValidLoc), ...
                             'Type','Spearman');
    unexplained_var_this = (1 - corrCoef^2)*100;
    unexplained_var_this = round(10*unexplained_var_this)/10;

    % Axes cosmetics
    ylabel('Human','FontSize',9);
    xlabel('DNN','FontSize',9);
    set(gca,'FontSize',12,'LineWidth',1.5);
    box off; axis square;

    % Title + annotation (keep it brief to avoid overlap)
    title([models(m).name ' (' layer ')'], 'FontSize',11);

    xl = xlim; yl = ylim;
    text(0.85, 0.1, [num2str(unexplained_var_this) '%'], ...
    'Units','normalized', ...   % now relative to axes (0¨C1)
    'FontSize',10, 'FontWeight','bold');
end

% save DNNs_144Patches.mat DNNs_144Patches models
%set(hfig,'position',[398 -200 1500 1800])


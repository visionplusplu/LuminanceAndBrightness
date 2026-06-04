clear;clc
addpath('./Functions/')
%% Laboratory data output (with chroma variation)
Data.Test = ChromaData_sorted('LaboratoryTest',[]);
%% Home data output (with chroma variation)
Data.Home = ChromaData_sorted('HomeTest',[]);
%% Prolific data output (with chroma variation)
Data.Prolific = ChromaData_sorted('ProlificTest',['56a346dddbe850000cfd3116']);

%% Combined the participants ID and find the participants that have high catch trial accuracy in all three sessions
CatchTrialThreshold = 0.75;
TestName = Data.Test.Name;
HomeName = Data.Home.Name;
ProlificName = Data.Prolific.Name;

TestInvalidId = TestName(find(Data.Test.CatchTrialAcc<CatchTrialThreshold));
HomeInvalidId = HomeName(find(Data.Home.CatchTrialAcc<CatchTrialThreshold));
UnionInvalidId = union(TestInvalidId,HomeInvalidId);

ProlificValidId = find(Data.Prolific.CatchTrialAcc>=CatchTrialThreshold);
%%%%%%% find participants that finished dual testing (Laboratry & Home)
Subject2session = intersect(TestName,HomeName);

%%%%%%% Exclude Invalid Id
SubjectValidId =  Subject2session(~ismember(Subject2session, UnionInvalidId));

%% Rebuild the data with the participants that have high catch trial accuracy
ChromaData_RankingFitting('LaboratoryTest',SubjectValidId,'Test Session',1)
ChromaData_RankingFitting('HomeTest',SubjectValidId,'Home Session',1)
ChromaData_RankingFitting('ProlificTest',ProlificValidId,'Online Session',2)

%% Evaluate Brightness Metric（Using the laboratory test results）
load('./Results/ChromaVariationExperiment/LaboratoryTest/AllSub_CatchTrialPassed.mat');
PatchRanking = AllSub.PatchRanking_allParticipant; %% 864 patch rankings of all participants
load('./Results/ChromaVariationExperiment/LaboratoryTest/WeightFitting.mat');
OptimalWeights = WeightFitting.meanFit;
load('./Results/ChromaVariationExperiment/LaboratoryTest/WeightFitting_LMS.mat');
OptimalWeights_LMS = WeightFitting_LMS.meanFit;
load('./Results/ChromaVariationExperiment/LaboratoryTest/WeightFitting_DKL.mat');
OptimalWeights_DKL = WeightFitting_DKL.meanFit;
load('./Results/ChromaVariationExperiment/LaboratoryTest/OledRGB.mat');
linearRGB = reshape(OledRGB.cube, [], 3);  % a 864x3 matrix based on OLED
load('./ColorPatchMetric/BrightnessModel_864Patches.mat'); %% Get the values of BrightnessModel
FigIdList = {"fig. S5A", "fig. S5C", "fig. S5B", "fig. S5D","fig. S5G", "fig. S5N","fig. S5K","fig. S5O","fig. S5T","fig. S5U","fig. S5Q","fig. S5P",...
    "fig. S5S","fig. S5R","fig. S5E","fig. S5J","fig. S5M","fig. S5L","fig. S5F","fig. S5I","fig. S5H","fig. S6"};
BrightnessModelComparison(PatchRanking,OptimalWeights,OptimalWeights_LMS,OptimalWeights_DKL,linearRGB,BrightnessModel,[],FigIdList);

%% Compare the laboratory-home ranking
load('./Results/ChromaVariationExperiment/LaboratoryTest/AllSub_CatchTrialPassed.mat');
TestPatchRanking = AllSub.PatchRanking_allParticipant; %% patch rankings of all participants
TestParticipants = AllSub.Name;
load('./Results/ChromaVariationExperiment/HomeTest/AllSub_CatchTrialPassed.mat');
HomePatchRanking = AllSub.PatchRanking_allParticipant; %% patch rankings of all participants
HomeParticipants = AllSub.Name;
[OverlapParticipants,TestLoc,HomeLoc] = intersect(TestParticipants,HomeParticipants);
load('./Results/ChromaVariationExperiment/LaboratoryTest/OledRGB.mat');
linearRGB = reshape(OledRGB.cube, [], 3);  % a matrix based on OLED
%%%% Mean Ranking %%%%
RankingConsistency(TestPatchRanking(TestLoc,:,:,:),HomePatchRanking(HomeLoc,:,:,:),'Laboratory Experiment', 'Home Experiment', '', 'fig. S7A', linearRGB,'Mean');

%% Compare the laboratory-prolific ranking
load('./Results/ChromaVariationExperiment/ProlificTest/AllSub_CatchTrialPassed.mat');
ProlificPatchRanking = AllSub.PatchRanking_allParticipant; %% patch rankings of all participants
ProlificParticipants = AllSub.Name;
%%%% Mean Ranking %%%%
RankingConsistency(TestPatchRanking,ProlificPatchRanking,'Laboratory Experiment', 'Prolific Experiment', '', 'fig. S7B', linearRGB,'Mean');

%% Compare the home-prolific ranking
%%%% Mean Ranking %%%%
RankingConsistency(HomePatchRanking,ProlificPatchRanking,'Home Experiment', 'Prolific Experiment', '', 'fig. S7C', linearRGB,'Mean');


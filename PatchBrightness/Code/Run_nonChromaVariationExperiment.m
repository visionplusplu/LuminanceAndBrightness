clear;clc
addpath('./Functions/')
%% Laboratory data output (no chroma variation)
Data.Test = NonChromaData_sorted('LaboratoryTest',[2022],1);
%% Laboratory (Retest) data output (no chroma variation)
Data.Retest = NonChromaData_sorted('LaboratoryRetest',[],1);
%% Home data output (no chroma variation)
Data.Home = NonChromaData_sorted('HomeTest',[],1);
%% Prolific data output (no chroma variation, black background)
Data.Prolific = NonChromaData_sorted('ProlificTest',[],2);
%% Prolific data output (no chroma variation, gray background)
Data.Prolific_GrayBackground = NonChromaData_sorted('ProlificTest_GrayBackground',[],2);
%% Prolific data output (no chroma variation, white background)
Data.Prolific_WhiteBackground = NonChromaData_sorted('ProlificTest_WhiteBackground',[],2);


%% Combined the participants ID and find the participants that have high catch trial accuracy in all three sessions
CatchTrialThreshold = 0.75;
TestName = cellfun(@str2double,Data.Test.Name);
HomeName = cellfun(@str2double,Data.Home.Name);
RetestName = cellfun(@str2double,Data.Retest.Name);
ProlificName = Data.Prolific.Name;

TestInvalidId = TestName(find(Data.Test.CatchTrialAcc<CatchTrialThreshold));
RetestInvalidId = RetestName(find(Data.Retest.CatchTrialAcc<CatchTrialThreshold));
HomeInvalidId = HomeName(find(Data.Home.CatchTrialAcc<CatchTrialThreshold));
UnionInvalidId = union(union(TestInvalidId,RetestInvalidId),HomeInvalidId);

ProlificValidId = find(Data.Prolific.CatchTrialAcc>=CatchTrialThreshold);
Prolific_GrayBackground_ValidId = find(Data.Prolific_GrayBackground.CatchTrialAcc>=CatchTrialThreshold);
Prolific_WhiteBackground_ValidId = find(Data.Prolific_WhiteBackground.CatchTrialAcc>=CatchTrialThreshold);
%%%%%%% find participants that finished dual testing (Laboratry & Home)
Subject2session = intersect(TestName,HomeName);

%%%%%%% Exclude Invalid Id
SubjectValidId =  Subject2session(~ismember(Subject2session, UnionInvalidId));

%% Rebuild the data with the participants that have high catch trial accuracy
NonChromaData_RankingFitting('LaboratoryTest',SubjectValidId,'Test Session',1)
NonChromaData_RankingFitting('LaboratoryRetest',SubjectValidId,'Retest Session',1)
NonChromaData_RankingFitting('HomeTest',SubjectValidId,'Home Session',1)
NonChromaData_RankingFitting('ProlificTest',ProlificValidId,'Online Session',2)
NonChromaData_RankingFitting('ProlificTest_GrayBackground',Prolific_GrayBackground_ValidId,'Online Session (Gray Background)',2)
NonChromaData_RankingFitting('ProlificTest_WhiteBackground',Prolific_WhiteBackground_ValidId,'Online Session (White Background)',2)

%% Evaluate Brightness Metric（Using the laboratory test results）
load('./Results/nonChromaVariationExperiment/LaboratoryTest/AllSub_CatchTrialPassed.mat');
PatchRanking = AllSub.PatchRanking_allParticipant_InterPolate; %% 144 patch rankings of all participants
load('./Results/nonChromaVariationExperiment/LaboratoryTest/WeightFitting.mat');
OptimalWeights = WeightFitting.meanFit;
load('./Results/nonChromaVariationExperiment/LaboratoryTest/OledRGB.mat');
linearRGB = reshape(OledRGB.cube, [], 3);  % a 144x3 matrix based on OLED
load('./ColorPatchMetric/BrightnessModel_144Patches.mat'); %% Get the values of BrightnessModel
BrightnessModelComparison(PatchRanking,OptimalWeights,linearRGB,BrightnessModel);


%% Compare the test-retest ranking
load('./Results/nonChromaVariationExperiment/LaboratoryTest/AllSub_CatchTrialPassed.mat');
TestPatchRanking = AllSub.PatchRanking_allParticipant_InterPolate; %% 144 patch rankings of all participants
TestParticipants = cellfun(@str2double,AllSub.Name);
load('./Results/nonChromaVariationExperiment/LaboratoryRetest/AllSub_CatchTrialPassed.mat');
RetestPatchRanking = AllSub.PatchRanking_allParticipant_InterPolate; %% 144 patch rankings of all participants
RetestParticipants = cellfun(@str2double,AllSub.Name);
[OverlapParticipants,TestLoc,RetestLoc] = intersect(TestParticipants,RetestParticipants);
load('./Results/nonChromaVariationExperiment/LaboratoryTest/OledRGB.mat');
linearRGB = reshape(OledRGB.cube, [], 3);  % a 144x3 matrix based on OLED
%%%% Mean Ranking %%%%
RankingConsistency(TestPatchRanking(TestLoc,:),RetestPatchRanking(RetestLoc,:),'Test', 'Retest', 'Test-Retest', linearRGB,'Mean');
%%%% Individual Ranking %%%%
RankingConsistency(TestPatchRanking(TestLoc,:),RetestPatchRanking(RetestLoc,:),'Test', 'Retest', 'Test-Retest', linearRGB,'Individual');

%% Compare the laboratory-home ranking
load('./Results/nonChromaVariationExperiment/LaboratoryTest/AllSub_CatchTrialPassed.mat');
TestPatchRanking = AllSub.PatchRanking_allParticipant_InterPolate; %% 144 patch rankings of all participants
TestParticipants = cellfun(@str2double,AllSub.Name);
load('./Results/nonChromaVariationExperiment/HomeTest/AllSub_CatchTrialPassed.mat');
HomePatchRanking = AllSub.PatchRanking_allParticipant_InterPolate; %% 144 patch rankings of all participants
HomeParticipants = cellfun(@str2double,AllSub.Name);
[OverlapParticipants,TestLoc,HomeLoc] = intersect(TestParticipants,HomeParticipants);
load('./Results/nonChromaVariationExperiment/LaboratoryTest/OledRGB.mat');
linearRGB = reshape(OledRGB.cube, [], 3);  % a 144x3 matrix based on OLED
%%%% Mean Ranking %%%%
RankingConsistency(TestPatchRanking(TestLoc,:),HomePatchRanking(HomeLoc,:),'Test', 'Home', 'Laboratory-Home', linearRGB,'Mean');
%%%% Individual Ranking %%%%
RankingConsistency(TestPatchRanking(TestLoc,:),HomePatchRanking(HomeLoc,:),'Test', 'Home', 'Laboratory-Home', linearRGB,'Individual');


%% Compare the laboratory-online ranking
load('./Results/nonChromaVariationExperiment/LaboratoryTest/AllSub_CatchTrialPassed.mat');
TestPatchRanking = AllSub.PatchRanking_allParticipant_InterPolate; %% 144 patch rankings of all participants
TestParticipants = cellfun(@str2double,AllSub.Name);
load('./Results/nonChromaVariationExperiment/ProlificTest/AllSub_CatchTrialPassed.mat');
ProlificPatchRanking = AllSub.PatchRanking_allParticipant_InterPolate; %% 144 patch rankings of all participants
ProlificParticipants = AllSub.Name;
load('./Results/nonChromaVariationExperiment/LaboratoryTest/OledRGB.mat');
linearRGB = reshape(OledRGB.cube, [], 3);  % a 144x3 matrix based on OLED
%%%% Mean Ranking %%%%
RankingConsistency(TestPatchRanking(TestLoc,:),ProlificPatchRanking,'Test', 'Prolific', 'Laboratory-Online', linearRGB,'Mean');

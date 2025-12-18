function [AllSub] = ChromaData_sorted(path,WronglyOrderedPartcipantNo)

%% load RawData
AllFile = dir(['../RawData/ChromaVariationExperiment/',path,'/*Chroma.mat']);
OriginalSubjectNumber = size(AllFile,1);
PrefList = nchoosek(1:12,2);
SubjectCount = 0;

for Subject = 1:OriginalSubjectNumber
    Name = AllFile(Subject).name;
    load(['../RawData/ChromaVariationExperiment/',path,'/',Name]);
    TrialNo = length(data.TrialInBlock);
    if TrialNo >= 84
        SubjectCount = SubjectCount+1;
        for Trial = 1:TrialNo
            RGB_temp = [data.R(Trial,:);data.G(Trial,:);data.B(Trial,:)];
            RGBList = RGB_temp';
            if ismember(extractBefore(Name,'_'),WronglyOrderedPartcipantNo)
                RGBList = flip(RGBList);
            end
            AllSub.RGBList(SubjectCount,Trial,:,:) = RGBList;
            AllSub.Name{1,SubjectCount} = extractBefore(Name,'_');
        end
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        % Calculate the catch trial accuracy by making 12 patches into pairs
        CatchTrialNo = 0;
        CatchTrialCorrect = 0;
        for Trial = 10:10:70 %%% For each participants, 1 catch trial every 10 trials
            RGB_temp = [data.R(Trial+5,:);data.G(Trial+5,:);data.B(Trial+5,:)];
            RGBList = RGB_temp';
            if ismember(extractBefore(Name,'_'),WronglyOrderedPartcipantNo)
                RGBList = flip(RGBList);
            end

            for p = 1:size(PrefList,1)
                CatchTrialNo = CatchTrialNo+1;
                Opt_brighter = PrefList(p,1);
                Opt_darker = PrefList(p,2);
                if RGBList(Opt_brighter,1)>RGBList(Opt_darker,1)
                    CatchTrialCorrect = CatchTrialCorrect+1;
                end
            end
        end
        AllSub.CatchTrialAcc(SubjectCount) = CatchTrialCorrect/CatchTrialNo;
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    end
end
AllSub.RGBList(:,[1:5,15:10:75],:,:) = [];


save (['./Results/ChromaVariationExperiment/',path,'/AllSub.mat'],"AllSub");



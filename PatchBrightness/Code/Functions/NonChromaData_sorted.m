function [AllSub] = NonChromaData_sorted(path,WronglyOrderedPartcipantNo,LabOrProlific)

%% load RawData
AllFile = dir(['../RawData/nonChromaVariationExperiment/',path,'/*.mat']);
OriginalSubjectNumber = size(AllFile,1);
PrefList = nchoosek(1:12,2);
for Subject = 1:OriginalSubjectNumber
    Name = AllFile(Subject).name;
    load(['../RawData/nonChromaVariationExperiment/',path,'/',Name]);
    if exist('obj') == 1
        data = obj;
    elseif exist('data') == 1
        data.R = data.R(6:end,:); %%% Remove the first five practice trial
        data.G = data.G(6:end,:);
        data.B = data.B(6:end,:);
        data.TrialInBlock = data.TrialInBlock(1,6:end);
        data.TotalTrials = data.TotalTrials(1,6:end);
        data.BlockNumber = data.BlockNumber(1,6:end);
        data.ReactionTime = data.ReactionTime(1,6:end);
        data.SubjectName = data.SubjectName(6:end,:);
        data.StimType = data.StimType(6:end,:);
        data.RectangleIndex = data.RectangleIndex(6:end,:);
    end
    PairInfo = [];
    TrialNo = data.TrialInBlock(end)+1;
    for Trial = 1:TrialNo
        RGB_temp = [data.R(Trial,:);data.G(Trial,:);data.B(Trial,:)];
        RGBList = RGB_temp';
        if LabOrProlific == 1
            if str2num(Name([1:4])) == WronglyOrderedPartcipantNo
                RGBList = flip(RGBList);
            end
        end
        AllSub.RGBList(Subject,Trial,:,:) = RGBList;
        if LabOrProlific == 1
            AllSub.Name{1,Subject} = Name([1:4]);
        else
            AllSub.Name{1,Subject} = Name;
        end

        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        % Calculate the catch trial accuracy by making 12 patches into pairs
        CatchTrialNo = 0;
        CatchTrialCorrect = 0;
        if size(data.R,1) == 66
            for Trial = 10:10:60 %%% For each participants, 1 catch trial every 10 trials
                RGB_temp = [data.R(Trial,:);data.G(Trial,:);data.B(Trial,:)];
                RGBList = RGB_temp';
                if LabOrProlific == 1
                    if str2num(Name([1:4])) == WronglyOrderedPartcipantNo
                        RGBList = flip(RGBList);
                    end
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
            AllSub.CatchTrialAcc(Subject) = CatchTrialCorrect/CatchTrialNo;
        else
             AllSub.CatchTrialAcc(Subject) = 0;%% havent finish all the 66 trials, counted as catch Trial acc = 0
        end
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    end
end

save (['./Results/nonChromaVariationExperiment/',path,'/AllSub.mat'],"AllSub");



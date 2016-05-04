%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%      MAIN SCRIPT       %%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% this is the main script that implements a tree bagger for Kaggle contest


%% load the data
% the loadcvs function has bug so we import the data manually.

clear all; clc;
load('ml.mat');

% remove first row
data = data(2:size(data,1),:);
quiz = quiz(2:size(quiz,1),:);

%% start looping here. Parameters min_obs, n_predictors

% parameters to optimize: 
% min_obs: minimum number of observations in one category to create a dummy
% fm: 0-1. If the feature map order 2 is calculated x1^2, x1x2, x1x3...xn^2
% npred_l: number of predictors to sample to fit each tree

% loops
min_obs_l = [70];
fm_l = [0];
npred_l = [10];

% constants
k_folds = 5;
iter = 5;

%% loop
for min_obs=min_obs_l
    for fm= fm_l
        for npred=npred_l

            %% feature mat order2
            if (fm==1)
                disp('calculating feature map')

                % find numerical columns
                % inputed mannualy to have more control
                num_col = [2 7 16 17 19 22 23 25 26 27 28 29 37 40 41 43 44 48 49 50 51];

                feat = cell2mat(table2cell(data(:,strseq('VarName',num_col))));
                f2_ma = f2_map(feat);

                feat_q = cell2mat(table2cell(quiz(:,strseq('VarName',num_col))));
                f2_ma_q = f2_map(feat_q);

                % append columns
                data1 = [data array2table(f2_ma)];
                quiz1 = [quiz array2table(f2_ma_q)];

            else % when no feature map is calculated
                data1 = data ;
                quiz1 = quiz ;
            end

%% create dummy variables
% min number of obs in a cat
% min_obs = 60;
            disp('creating dummies')

            % delete variables with one unique value. These do not provide any
            % iformation

            data1.VarName18 =[];
            data1.VarName20 =[];
            data1.VarName21 =[];
            data1.VarName24 =[];

            quiz1.VarName18 =[];
            quiz1.VarName20 =[];
            quiz1.VarName21 =[];
            quiz1.VarName24 =[];

            % VarName1 dum
            [data1, quiz1] = create_dumm(data1,quiz1,'VarName1',min_obs);

            % VarName2 ok

            % VarName3 dum
            [data1, quiz1] = create_dumm(data1,quiz1,'VarName3',min_obs);

            % VarName4 convert to binary
            data1.VarName4 = double(cell2mat(table2cell(data1(:,'VarName4')))=='f');
            quiz1.VarName4 = double(cell2mat(table2cell(quiz1(:,'VarName4')))=='f');

            % VarName5 dum
            [data1, quiz1] = create_dumm(data1,quiz1,'VarName5',min_obs);

            % VarName6 dum
            [data1, quiz1] = create_dumm(data1,quiz1,'VarName6',min_obs);

            % VarName7 ok

            % VarName8 dum
            [data1, quiz1] = create_dumm(data1,quiz1,'VarName8',min_obs);

            % VarName4 convert to binary
            data1.VarName9 = double(cell2mat(table2cell(data1(:,'VarName9')))=='f');
            quiz1.VarName9 = double(cell2mat(table2cell(quiz1(:,'VarName9')))=='f');

            % VarName10  VarName11  VarName12  VarName13  VarName14  VarName15 dum
            [data1, quiz1] = create_dumm(data1,quiz1,'VarName10',min_obs);
            [data1, quiz1] = create_dumm(data1,quiz1,'VarName11',min_obs);
            [data1, quiz1] = create_dumm(data1,quiz1,'VarName12',min_obs);
            [data1, quiz1] = create_dumm(data1,quiz1,'VarName13',200);
            [data1, quiz1] = create_dumm(data1,quiz1,'VarName14',min_obs);
            [data1, quiz1] = create_dumm(data1,quiz1,'VarName15',min_obs);

            % VarName16  VarName17 ok / 
            % VarName18 delete / 
            % VarName19 ok / 
            % VarName20  VarName21 delete / 
            % VarName22  VarName23 ok / 
            % VarName24 delete / 
            % VarName25  VarName26 ok /

            % VarName27  VarName28  VarName29 create a new variable with fix2.
            [data1, quiz1] = fix_2(data1,quiz1,'VarName27',1);
            [data1, quiz1] = fix_2(data1,quiz1,'VarName28',1);
            [data1, quiz1] = fix_2(data1,quiz1,'VarName29',1);
            [data1, quiz1] = fix_2(data1,quiz1,'VarName30',1);
            [data1, quiz1] = fix_2(data1,quiz1,'VarName31',1);

            [data1, quiz1] = fix_2(data1,quiz1,'VarName32',1);
            [data1, quiz1] = fix_2(data1,quiz1,'VarName33',1);
            [data1, quiz1] = fix_2(data1,quiz1,'VarName34',1);
            [data1, quiz1] = fix_2(data1,quiz1,'VarName35',1);
            [data1, quiz1] = fix_2(data1,quiz1,'VarName36',1);
            [data1, quiz1] = fix_2(data1,quiz1,'VarName37',1);
            [data1, quiz1] = fix_2(data1,quiz1,'VarName38',1);
            [data1, quiz1] = fix_2(data1,quiz1,'VarName39',1);
            [data1, quiz1] = fix_2(data1,quiz1,'VarName40',1);

            % VarName41  VarName42  VarName43  VarName44 ok

            % VarName45  VarName46  VarName47 dummy
            [data1, quiz1] = create_dumm(data1,quiz1,'VarName45',min_obs);
            [data1, quiz1] = create_dumm(data1,quiz1,'VarName46',min_obs);
            [data1, quiz1] = create_dumm(data1,quiz1,'VarName47',200);

            % VarName48  VarName49  VarName50  VarName51  VarName52 ok (some are scaled
            % by the algorithm)

%%
            disp('preparing the data')

            % prepare the data1 for the tree bagger algorithm
            n_col_data = size(data1,2);
            labels1 = table2array(data1(:,35));
            data1 = table2array(data1(:,[1:34 36:n_col_data]));
            quiz1 = table2array(quiz1);

            %% call cv function
            disp('cross validating')
            [cv_error, sd_error] = cross_val('et', data1, labels1, k_folds, iter, npred);

            disp('writing file')
            % append rows to a file
            row_file = [k_folds, iter, min_obs ,fm, npred,...
                        sd_error,cv_error];
            dlmwrite('out_analysis_l.csv',row_file,'delimiter',',','-append');

            % end loop
        end 
    end 
end

%% run the best model
%ET
 ET = TreeBagger(350,data1,labels1,'Method','classification',...
     'NumPredictorsToSample',100);

%% predict quiz
labels = predict(ET,quiz1);
labels = str2num(char(labels));

%% save the file
c1 = 1:size(labels,1);
file_s = [c1' labels];
file_s = dataset({file_s 'Id','Prediction'});

filename = 'now.csv';
export(file_s,'file',filename,'Delimiter',',')

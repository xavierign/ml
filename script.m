%% load the data
% 0.95024  //min=75 // pred=150 // n=200 //f2map
% 0.95080  //min=60 // pred=150 // n=200 //f2map
% 0.95017  //min=45 // pred=150 // n=200 //f2map
% 0.95087  //min=60 // pred=120 // n=200 //f2map
% 0.95087 // min=60 // pred=100 // n=200 //f2map

clear all;
load('ml.mat');

%remove first row
data = data(2:size(data,1),:);
quiz = quiz(2:size(quiz,1),:);

%44 per cent class1 TODO parameters to play with: min_obs,10-100

%% crete dummy variables
%remove columns 18 20 21 24 

%min number of obs in a cat
min_obs = 60;

data.VarName18 =[];
data.VarName20 =[];
data.VarName21 =[];
data.VarName24 =[];

quiz.VarName18 =[];
quiz.VarName20 =[];
quiz.VarName21 =[];
quiz.VarName24 =[];

% VarName1
[data, quiz] = create_dumm(data,quiz,'VarName1',min_obs);

%2 ok

%3 dum
[data, quiz] = create_dumm(data,quiz,'VarName3',min_obs);

%4 convert to binary
data.VarName4 = double(cell2mat(table2cell(data(:,'VarName4')))=='f');
quiz.VarName4 = double(cell2mat(table2cell(quiz(:,'VarName4')))=='f');

%5 dum
[data, quiz] = create_dumm(data,quiz,'VarName5',min_obs);

%6 dum
[data, quiz] = create_dumm(data,quiz,'VarName6',min_obs);

%7 ok

%8 dum
[data, quiz] = create_dumm(data,quiz,'VarName8',min_obs);

%4 convert to binary
data.VarName9 = double(cell2mat(table2cell(data(:,'VarName9')))=='f');
quiz.VarName9 = double(cell2mat(table2cell(quiz(:,'VarName9')))=='f');

%10 11 12 13 14 15 dum
[data, quiz] = create_dumm(data,quiz,'VarName10',min_obs);
[data, quiz] = create_dumm(data,quiz,'VarName11',min_obs);
[data, quiz] = create_dumm(data,quiz,'VarName12',min_obs);
[data, quiz] = create_dumm(data,quiz,'VarName13',200);
[data, quiz] = create_dumm(data,quiz,'VarName14',min_obs);
[data, quiz] = create_dumm(data,quiz,'VarName15',min_obs);

%16 17 ok / %18 delete / %19 ok / %20 21 delete / %22 23 ok / %24 delete / %25 26 ok /

%27 28 29 create a new variable
[data, quiz] = fix_2(data,quiz,'VarName27',1);
[data, quiz] = fix_2(data,quiz,'VarName28',1);
[data, quiz] = fix_2(data,quiz,'VarName29',1);
[data, quiz] = fix_2(data,quiz,'VarName30',1);
[data, quiz] = fix_2(data,quiz,'VarName31',1);

[data, quiz] = fix_2(data,quiz,'VarName32',1);
[data, quiz] = fix_2(data,quiz,'VarName33',1);
[data, quiz] = fix_2(data,quiz,'VarName34',1);
[data, quiz] = fix_2(data,quiz,'VarName35',1);
[data, quiz] = fix_2(data,quiz,'VarName36',1);
[data, quiz] = fix_2(data,quiz,'VarName37',1);
[data, quiz] = fix_2(data,quiz,'VarName38',1);
[data, quiz] = fix_2(data,quiz,'VarName39',1);
[data, quiz] = fix_2(data,quiz,'VarName40',1);

%41 42 43 44 ok

%45 46 47 dummy
[data, quiz] = create_dumm(data,quiz,'VarName45',min_obs);
[data, quiz] = create_dumm(data,quiz,'VarName46',min_obs);
[data, quiz] = create_dumm(data,quiz,'VarName47',200);


%% tree bagger with numerical data (prepare the data)
n_col_data = size(data,2);
data1 = table2array(data(:,[1:34 36:n_col_data]));
labels1 = table2array(data(:,35));

quiz1 = table2array(quiz);


%% divide into train and test
%cut the dataset
%ids_1 = logical(randsample(0:1, size(data1,1), true, [0.3 0.7]));
%data1 = data1(ids_1,:);
train_ids = logical(randsample(0:1, size(data1,1), true, [0.0 1]));
data_train = data1(train_ids,:);
data_test = data1(~train_ids,:);

labels1_train = labels1(train_ids,:);
labels1_test = labels1(~train_ids,:);


%% tree bagger with numerical data (run the model)

for pred = [100]
ET = TreeBagger(200,data_train,labels1_train,... %'OOBPrediction','On',...
    'Method','classification','NumPrint',5,'NumPredictorsToSample',pred,...
    'MinLeafSize',1);
   % 'OOBPredictorImportance','On');

%oobErrorBaggedEnsemble = oobError(ET);
%plot(oobErrorBaggedEnsemble)

%labels1_pred = predict(ET,data_test) ;
%pred
%1-mean(str2num(char(labels1_pred))==labels1_test)
end 
%% analize the solution
var_imp = ET.OOBPermutedPredictorDeltaError;
[var_sor, ids] = sort(var_imp,'descend');

%% feature map of the 10 first collumns in importance
num_col = ids(1:10);
data1 = [data1 f2_map(data1(:,num_col))];
quiz1 = [quiz1 f2_map(quiz1(:,num_col))];

%% feature map of selected numerical data
%cat_col = [1 3 4 5 6 8 9 10 11 12 13 14 15 45 46 47];
%num_col = setdiff(1:52,cat_col);
num_col = [2 7 16 17 19 22 23 25 26 27 28 29 37 40 41 43 44 48 49 50 51];

feat = cell2mat(table2cell(data(:,strseq('VarName',num_col))));
f2_ma = f2_map(feat);

feat_q = cell2mat(table2cell(quiz(:,strseq('VarName',num_col))));
f2_ma_q = f2_map(feat_q);

%append columns
data = [data array2table(f2_ma)];
quiz = [quiz array2table(f2_ma_q)];


%%
%methods = {'AdaBoostM1','LogitBoost','GentleBoost','RobustBoost'};
met='Subspace';
for iter = [100] 
    tic
    Ensemble = fitensemble(data_train,'label',char(met),iter,'Discriminant','NPrint',50);
    met
    iter
    loss(Ensemble,data_train,'label')
    loss(Ensemble,data_test,'label')
    toc
end
%%
plot(resubLoss(Ensemble,'Mode','Cumulative'));


%% export the data
filename = 'data_pre.csv';
writetable(data,filename);

filename = 'quiz_pre.csv';
writetable(quiz,filename);

%% 48 49 scale to do

%% predict quiz
labels = predict(ET,quiz1);
labels = str2num(char(labels));


%% save the file
c1 = 1:size(labels,1);
file_s = [c1' labels];
file_s = dataset({file_s 'Id','Prediction'});

filename = 'now.csv';
export(file_s,'file',filename,'Delimiter',',')

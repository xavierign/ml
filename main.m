%%%%%%%%%%%%%%
%% HW2 MAIN %%
%%%%%%%%%%%%%%

%load the data
%load('spam_fixed.mat')


data1 = table2array(data_train(:,[1:34 36:605]));
labels1 = table2array(data_train(:,35));

%% train svm

SVMfit = fitcsvm(data1,labels1,'KernelFunction','polynomial',...
    'PolynomialOrder',2);

%label_svm = predict(SVMfit,quiz);

%% %cross val
folds = 4;

cross_val('ave',data1,labels1,folds)
cross_val('lr',data1,labels1,folds)
cross_val('lda',data1,labels1,folds)
cross_val('qda',data1,labels1,folds)
cross_val('ave',f2_map(data1),labels1,folds)
cross_val('lr',f2_map(data1),labels1,folds)

%train the linear model with the 100% of the training data. 
%train error
predlabels = ave_perceptron(data, labels,data);
1 - mean(predlabels==labels)

%test error
predlabels = ave_perceptron(data, labels, testdata);
1 - mean(predlabels==testlabels)

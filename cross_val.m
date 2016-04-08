%%%%%%%%%%%%%%%%%%%%%%
%% Cross Validation %%
%%%%%%%%%%%%%%%%%%%%%%
% arguments
% algo: { 'ave','lr','lda','qda'}

function cv_error = cross_val(algo, data, labels, folds)
    
    id_cross = randsample(1:folds, size(data,1),true);
    
    ids_fold={folds};
    for k=1:folds
        ids_fold{k}=id_cross==k;
    end
    
   
    %loop among the k-folds to learn and test
    k_error = zeros(1,folds);
    for k=1:folds
        k
        %separate the datasets into folds
        k_data = data(~ids_fold{k},:);
        k_labels = labels(~ids_fold{k},:);
        k_testdata = data(ids_fold{k},:);
        k_testlabels = labels(ids_fold{k},:);   
    
        if  strcmp(algo,'ave')
            %call the function AVE PERCEPTRON
            predlabels = ave_perceptron(k_data, k_labels, k_testdata);
            k_error(k) = mean(predlabels==k_testlabels);
            k_error(k)
        end

        if strcmp(algo,'lr')
            %call the function LOGISTIC REGRESSION
            labels_lr = k_labels;
            labels_lr (k_labels<0) =0;
            %fit the model
            b = glmfit(k_data,labels_lr,'binomial','link','logit');
               
            %test error in the k cv fold
            yfit = glmval(b,k_testdata,'logit');
            pred_labels = ones(size(k_testlabels));
            pred_labels(yfit<0.5)=-1;
            k_error(k) = mean(pred_labels==k_testlabels);
            k_error(k)
        end
        if strcmp(algo,'lda')
            %call the function Linnear discriminant
            lda = fitcdiscr(k_data,k_labels);
            predlabels = predict(lda,k_testdata);
            k_error(k) = mean(predlabels==k_testlabels);
        end
        if strcmp(algo,'qda')
            %call the function Linnear discriminant
            lda = fitcdiscr(k_data,k_labels,'DiscrimType','pseudoQuadratic');
            predlabels = predict(lda,k_testdata);
            k_error(k) = mean(predlabels==k_testlabels);
        end      
    end
    cv_error = 1-mean(k_error);    
end
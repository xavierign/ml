%%%%%%%%%%%%%%%%%%%%%%
%% Cross Validation %%
%%%%%%%%%%%%%%%%%%%%%%
% arguments
% algo: { 'et'} this version just works with tree bagger

function [cv_error, sd_error] = cross_val(algo, data, labels, folds,iter,npred)
    
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
      	
        disp('fitting the model')  

        ET = TreeBagger(iter,k_data,k_labels,'Method','classification',...
        'NumPredictorsToSample',npred);

        predlabels = predict(ET,k_testdata); 
        predlabels = str2num(char(predlabels));
	
        k_error(k) = mean(predlabels==k_testlabels)
       
    end
    cv_error = 1-mean(k_error); 
    sd_error = std(k_error);
end
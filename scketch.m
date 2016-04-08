%scketch
%labels_lr = labels;
%labels_lr (labels<0) =0;
%b = glmfit(f2_map(data),labels_lr,'binomial','link','logit');
%yfit = glmval(b,f2_map(data),'logit');
%pred_labels = ones(size(labels));
%pred_labels(yfit<0.5)=-1;
%1 - mean(pred_labels==labels)

%test the logistic regression

%call the function AVE PERCEPTRON
            predlabels = ave_perceptron(f2_map(data), labels,... 
            f2_map(testdata));
            1 - mean(predlabels==testlabels)
            
%call the function LOG REG
%call the function LOGISTIC REGRESSION
            labels_lr = labels;
            labels_lr (labels<0) =0;
            %fit the model
            b = glmfit(f2_map(data),labels_lr,'binomial','link','logit');
               
            %test error in the k cv fold
            yfit = glmval(b,f2_map(testdata),'logit');
            pred_labels = ones(size(testlabels));
            pred_labels(yfit<0.5)=-1;
            1- mean(pred_labels==testlabels)
            
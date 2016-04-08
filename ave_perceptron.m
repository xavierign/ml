%%%%%%%%%%%%%%%%%%%%%%
%% Aver. Perceptron %%
%%%%%%%%%%%%%%%%%%%%%%
% implementation taken from "a course in ML- Hal Daume"
function predlabels = ave_perceptron(data, labels, testdata)

    %number of pases
    iter = 64;

    %declare initial w
    w = zeros(1, size(data,2));
    u = zeros(1, size(data,2));
    b = 0;
    beta = 0;
    c = 1;

    for i=1:iter
        %sort randomply the rows
        i
        random_rows = randsample(size(data,1), size(data,1),false);
        %random_rows = (1:size(data,1))';
        
        %loop among the rows
        for n_row=random_rows'
            y = labels(n_row);
            x = data(n_row,:);
            if (y*(x*w' + b)<=0)
                w = w + y*x;
                b = b + y;
                u = u + y*c*x;
                beta = beta + y*c;
            end
            c = c+1;
        end
    end
    w_ret= w -1/c*u;
    b_ret= b -1/c*beta;

    %calculate predicted labels
    predlabels = ones(size(testdata,1),1);
    predlabels(testdata*w_ret'+b_ret<0) = -1;
end


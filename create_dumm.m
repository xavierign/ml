function [data, quiz] = create_dumm(data_in,quiz_in,var_name, min_num)
    %var_name= 'VarName5';
     %min_num = 50;
     %data_in=data;
     %quiz_in=quiz;
    
    %replace low frequency by 'other'
    col= tabulate(categorical(table2cell(data_in(:,var_name))));
    fie = col(cell2mat(col(:,2))>min_num,1);
    
    others_id = ~ismember(table2cell(data_in(:,var_name)),fie);
    if(sum(others_id)>0) 
        data_in(others_id,var_name)={'other'};
    end;
    others_id = ~ismember(table2cell(quiz_in(:,var_name)),fie);
    if(sum(others_id)>1) 
        quiz_in(others_id,var_name)={'other'};
    elseif (sum(others_id)>0)
        quiz_in(others_id,var_name)=cell2table({'other'});
    end;
    
    %create dummy in data
    col = table2cell(data_in(:,var_name));
    col= categorical(col);
    D1 = dummyvar(col);
    var_name
    size(D1,2)
    data_in = [data_in array2table(D1,'VariableNames',...
                                    strseq([var_name '_'],...
                                    1:size(D1,2)))];
    data_in(:,var_name) =[];
    data=data_in;

    %create dummy in quiz
    col = table2cell(quiz_in(:,var_name));
    col= categorical(col);
    D1 = dummyvar(col);
    quiz_in = [quiz_in array2table(D1,'VariableNames',...
                                    strseq([var_name '_'],...
                                    1:size(D1,2)))];
    
    quiz_in(:,var_name) =[];
    quiz=quiz_in;
     
end
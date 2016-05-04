function [data, quiz] = fix_2(data_in,quiz_in,var_name,create)
    
    % some variables have 0-1-2 as values. This is corrected to 0-1 and a
    % dummy variable with the obs with value 2 (if create=true).
 
    ind2 = cell2mat(table2cell(data_in(:,var_name)))==2;
    if (create)
        data_in(:,[var_name '_2']) = array2table(ind2+0);
    end
    data_in(ind2,var_name) = array2table(ones(sum(ind2),1));
    data= data_in;
    
    ind2 = cell2mat(table2cell(quiz_in(:,var_name)))==2;
    if (create)
        quiz_in(:,[var_name '_2']) = array2table(ind2+0);
    end
    quiz_in(ind2,var_name) = array2table(ones(sum(ind2),1));
    quiz= quiz_in;
    
end
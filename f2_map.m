%%%%%%%%%%%%%%%%%%%%%%
%% feature map      %%
%%%%%%%%%%%%%%%%%%%%%%
%creates a feature map order 2 of a given numeric dataset


function f2_map_data = f2_map(data_in)
    ncol = size(data_in,2);
    f2_map_data = [];
    for i=1:ncol
        for j=(i+1):ncol
            f2_map_data = [f2_map_data times(data_in(:,i),data_in(:,j))];
        end
    end
end
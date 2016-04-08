%%%%%%%%%%%%%%%%%%%%%%
%% feature map      %%
%%%%%%%%%%%%%%%%%%%%%%

function f2_map_data = f2_map(data)
    ncol = size(data,2);
    f2_map_data = data;
    for i=1:ncol
        for j=i:ncol
            f2_map_data = [f2_map_data times(data(:,i),data(:,j))];
        end
    end
end
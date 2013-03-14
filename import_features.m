function [F, ft_nm] = import_features(filename)
    fea = importdata(filename, '\n');
    % open features
    remain = fea(1);
    [~ , remain] = strtok(remain);
    count = 0;
    while 1
        [name , remain] = strtok(remain);
        name = char(strtrim(name));
        if size(name, 2) == 0
            break;
        end
        count = count + 1;
        ft_nm{count} = name;
    end
    for i = 2:size(fea,1)
        remain = fea(i);
        [~ , remain] = strtok(remain);
        F(i-1, :) = str2num(char(remain));
    end
end
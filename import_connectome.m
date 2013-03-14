function [node_arr, CIJ, hier_arr, leaf_idx, dmn] = import_connectome(fullname, hierarchy, connect, dmn_name)
    % open files
    ful = importdata(fullname, '\n');
    hier = importdata(hierarchy, '\n');
    con = importdata(connect, '\n');
    %temporary objects
    nodes = containers.Map('KeyType','char', 'ValueType', 'int32');
    leaf_idx = 1:(size(ful,1)-1);
    node_arr = [];
    hier_arr = [];
    CIJ = zeros(1);
    % open fullname
    for i = 2:size(ful,1)
        [abbr , remain] = strtok(ful(i));
        [fillcolor , remain] = strtok(remain);
        [linecolor , full] = strtok(remain);
        abbr = strtrim(char(abbr));
        fillcolor = str2num(strtrim(char(fillcolor)));
        linecolor = str2num(strtrim(char(linecolor)));
        full = strtrim(char(full));
        nodes(abbr) = i - 1;
        node_arr{i - 1} = struct('abbr', abbr, 'fillcolor', fillcolor, 'linecolor', linecolor, 'full', full);
    end
    % open hierarchy
    for i = 2:size(hier, 1)
        [s1 , s2] = strtok(hier(i));
        s2 = char(strtrim(s2));
        s1 = char(s1);
        n1 = nodes(s1);
        n2 = nodes(s2);
        leaf_idx(n1) = 0;
        hier_arr{i - 1} = struct('child', n2, 'parent', n1);
    end
    % open connectivity
    for i = 2:size(con,1)
        [s1 , s2] = strtok(con(i));
        s2 = char(strtrim(s2));
        s1 = char(s1);
        n1 = nodes(s1);
        n2 = nodes(s2);
        if (n1 <= size(CIJ,1) && n2 <= size(CIJ,2))
            CIJ(n1, n2) =  CIJ(n1, n2) + 1;
        else 
            CIJ(n1, n2) = 1;
        end
    end
    if (size(CIJ,1) < size(nodes, 1))
        CIJ(size(nodes, 1), 1) = 0;
    end
    if (size(CIJ,2) < size(nodes, 1))
        CIJ(1, size(nodes, 1)) = 0;
    end
    % open dmn
    if nargin >=4
        dmn_dat = importdata(dmn_name, '\n');
        remain = dmn_dat;
        i = 1;
        while 1
            [s1 , remain] = strtok(remain);
            s1 = char(strtrim(s1));
            if (size(s1, 2) == 0)
                break;
            end
            dmn(i) = nodes(s1);
            i = i + 1;
        end
        dmn = dmn';
    end
    % count leafs
    leaf_idx(leaf_idx == 0) = [];
end
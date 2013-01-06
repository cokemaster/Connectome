function nodes = addHierarchy(nodes, hierarchy)
    % create child-parent map object
    hier = containers.Map('KeyType','int32', 'ValueType', 'int32');
    for i = 1:size(hierarchy,2)
        hier(hierarchy{i}.child) = hierarchy{i}.parent;
    end
    % set hierarchy
    for i = 1:size(nodes,2)
        t = i;
        while(isKey(hier, t) && nodes(t) > nodes(hier(t)))
            nodes(hier(t)) = nodes(t);
            t = hier(t);
        end
    end
end
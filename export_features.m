function export_features(filename, nodes, F, ft_nm)
    %   filename    - full name of the output file
    %   nodes       - node name
    %   F           - features matrix
    %   ft_nm       - features name
    fileID = fopen(filename, 'w');
    fprintf(fileID, 'name\t');
    for j = 1:(size(ft_nm, 2)-1)
        fprintf(fileID, '%s\t', ft_nm{j});
    end
    fprintf(fileID, '%s\n', ft_nm{size(ft_nm, 2)});
    for i = 1:size(nodes, 2)
        fprintf(fileID, '%s\t', nodes{i}.abbr);
        for j = 1:(size(ft_nm, 2) - 1)
            fprintf(fileID, '%s\t', num2str(F(i, j)));
        end
        fprintf(fileID, '%s\n', num2str(F(i, size(ft_nm, 2))));
    end
    fclose(fileID);
end
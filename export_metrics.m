function export_metrics(filename, nodes, metric)
    fileID = fopen(filename, 'w');
    fprintf(fileID, 'name\t');
    for j = 1:(size(metric, 2) - 1);
        fprintf(fileID, '%s\t', metric(j).name);
    end
    fprintf(fileID, '%s\n', metric(size(metric, 2)).name);
    for i = 1:size(nodes, 2)
        fprintf(fileID, '%s\t', nodes{i}.abbr);
        for j = 1:(size(metric, 2) - 1)
            fprintf(fileID, '%s\t', int2str(metric(j).arr(i)));
        end
        fprintf(fileID, '%s\n', int2str(metric(size(metric, 2)).arr(i)));
    end
    fclose(fileID);
end
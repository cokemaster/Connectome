function attempts(folder)
    long_part = 'C:\Users\Acer\Documents\Мозги\';
    f_fullname = strcat(long_part, folder, '\fullname.txt');
    f_hierarchy = strcat(long_part, folder, '\hierarchy.txt');
    f_connectome = strcat(long_part, folder, '\connectome.txt');
    disp('importing connctome...');
    [nodes, CIJ, hier] = import_connectome(f_fullname, f_hierarchy, f_connectome);
    %degrees
    disp('calculating degrees...');
    [id, od] = degrees_dir(CIJ);
    id = sort(id);
    od = sort(od);
    subplot(2,2,1), plot(id);
    title('InDegree');
    subplot(2,2,2), plot(od);
    %delete empty nodes
    title('OutDegree');
    CIJ(:, id + od == 0) = [];
    CIJ(id + od == 0, :) = [];
    % Modularity
        disp('calculating clustering coefficient...');
        clust = clustering_coef_bd(CIJ);
        clust = sort(clust);
        subplot(2,2,3), plot(clust);
        title('Clustering Coefficient');
        %reordering matrix
        disp('reordering matrix...');
        [Mreordered] = reorder_matrix(CIJ, 'line', 1);
        [Ci, Q] = modularity_dir(Mreordered);
        [order, ModCIJ] = reorder_mod(Mreordered, Ci);
    
        HeatMap(CIJ);
        disp(sum(sum(CIJ) == 0))
        disp(sum(sum(CIJ') == 0))
        HeatMap(ModCIJ);
        HeatMap(Mreordered);
end
function compute_features(folder)
    long_part = 'C:\Users\Acer\Documents\Ìîçãè\';
    f_fullname = strcat(long_part, folder, '\fullname.txt');
    f_hierarchy = strcat(long_part, folder, '\hierarchy.txt');
    f_connectome = strcat(long_part, folder, '\connectome.txt');
    f_dmn = strcat(long_part, folder, '\DMN.txt');
    f_features = strcat(long_part, folder, '\features.txt');
    disp('importing connctome...');
    [nodes, CIJ, hier, leaf, dmn] = import_connectome(f_fullname, f_hierarchy, f_connectome, f_dmn);
    disp('analize connectome...');
    [F, ft_nm] = centrality_features(CIJ, leaf);
    disp('export_features...');
    export_features(f_features, nodes, F, ft_nm);
end
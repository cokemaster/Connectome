function metrics(folder)
    f_fullname = strcat('C:\Users\Acer\Documents\Мозги\', folder, '\fullname.txt');
    f_hierarchy = strcat('C:\Users\Acer\Documents\Мозги\', folder, '\hierarchy.txt');
    f_connectome = strcat('C:\Users\Acer\Documents\Мозги\', folder, '\connectome.txt');
    disp('importing connctome...');
    [nodes, CIJ, hier] = import_connectome(f_fullname, f_hierarchy, f_connectome);
    disp('calculating Kcore...');
    vect1 = KCore(CIJ);
    disp('calculating Knotty Centre...');
    [vect2, kc] = FindKnottyCentre(CIJ, 0);
    [vect3, kc] = FindKnottyCentre(CIJ, 1);
    disp('calculating Rich Club...');
    [r, n, e, vect4] = rich_club_bd(CIJ);
    disp('adding Hierarchy...');
    vect1 = addHierarchy(vect1, hier);
    vect2 = addHierarchy(vect2, hier);
    vect3 = addHierarchy(vect3, hier);
    vect4 = addHierarchy(vect4, hier);
    metric(1) = struct('name', 'kcore', 'arr', vect1);
    metric(2) = struct('name', 'knotty', 'arr', vect2);
    metric(3) = struct('name', 'compact_knotty', 'arr', vect3);
    metric(4) = struct('name', 'rich_club', 'arr', vect4);
    %export_metrics(strcat('C:\Users\Acer\Documents\Мозги\', folder, '\metrics.txt'), nodes, metric);
end
function [F, name] = centrality_features(CIJin, leafs)
    % CIJin   - is n x n binary, directed connection matrix
    % leafs - leaf indexes
    CIJ = CIJin(leafs, leafs);
    n = length(CIJ); % nodes amount
    k = 20;          % features amount
    F = zeros(k, n);
    % Betweenness centrality
    name{1} = 'Betweenness_centrality';
    disp('1. Betweenness centrality');
    F(1, leafs) = betweenness_bin(CIJ);

    % Eccentricity
    name{2}= 'Eccentricity';
    disp('2. Eccentricity');
    [~, D] = breadthdist(CIJ);
    [~, ~, F(2, leafs)] = charpath(D);

    % Clustering coefficient
    name{3} = 'Clustering_coefficient';
    disp('3. Clustering coefficient');
    F(3, leafs) = clustering_coef_bd(CIJ);

    % Eigenvector centrality
    name{4} = 'Eigenvector_centrality';
    disp('4. Eigenvector centrality');
    F(4, leafs) = eigenvector_centrality_und(CIJ + CIJ');

    % Flow coefficient
    name{5} = 'Flow_coefficient';
    disp('5. Flow coefficient');
    F(5, leafs) = flow_coef_bd(CIJ);

    % Kcoreness centrality
    name{6} = 'Kcoreness_centrality';
    disp('6. Kcoreness centrality');
    F(6, leafs) = kcoreness_centrality_bd(CIJ);

    % Knotty centre
    name{7} = 'Knotty_centre';
    disp('7. Knotty centre');
    F(7, leafs) = FindKnottyCentre(CIJ, 0);

    % Compact knotty centre
    name{8} = 'Compact_knotty_centre';
    disp('8. Compact knotty centre');
    F(8, leafs) = FindKnottyCentre(CIJ, 1);

    % PageRank centrality
    name{9} = 'PageRank_centrality';
    disp('9. PageRank centrality');
    F(9, leafs) = pagerank_centrality(CIJ, 0.85);

    % Rich club coefficient
    name{10} = 'Rich_club_coefficient';
    disp('10. Rich club coefficient');
    [~, ~, ~, F(10, leafs)] = rich_club_bd(CIJ);

    % Score centrality
    name{11} = 'Score_centrality';
    disp('11. Score centrality');
    s = mean(sum(CIJ + CIJ'))/2;  % not adequate
    [~, ~, F(11, leafs)] = score_wu(CIJ+CIJ', s);

    % Strength
    name{12} = 'Strength';
    disp('12. Strength');
    [~, ~, F(12, leafs)] = strengths_dir(CIJ);

    % Subgraph Centrality
    name{13} = 'Subgraph_Centrality';
    disp('13. Subgraph Centrality');
    F(13, leafs) = subgraph_centrality(CIJ);
    
    % Average neighbor degree
    name{14} = 'Average_neighbor_degree';
    disp('14. Average neighbor degree');
    [~, F(14, leafs)] = CCM_AvgNeighborDegree(CIJ);

    % Fault Tolerance
    name{15} = 'Fault_Tolerance';
    disp('15. Fault Tolerance');
    [~, F(15, leafs)] = CCM_FaultTol(CIJ);

    % Global Efficiency, Mean Shortest Path length
    name{16} = 'Global_Efficiency';
    name{17} = 'Mean_Shortest_Path_length';
    disp('16. Global Efficiency, 17. Mean Shortest Path length');
    [~, F(16, leafs), ~, F(17, leafs)] = CCM_GEfficiency(CIJ);

    % Local Efficiency
    name{18} = 'Local_Efficiency';
    disp('18. Local Efficiency');
    [~, F(18, leafs)] = CCM_LEfficiency(CIJ);

    % Random walk betweenness
    name{19} = 'Random_walk_betweenness';
    disp('19. Random walk betweenness');
    F(19, leafs) = CCM_RBetweenness(CIJ);

    % Vulnerability
    name{20} = 'Vulnerability';
    disp('20. Vulnerability');
    C = CIJ + CIJ';
    C(C ~= 0) = 1;
    F(20, leafs) = CCM_Vulnerability(C);

    F = F';
end
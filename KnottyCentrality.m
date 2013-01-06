function kc = KnottyCentrality(CIJ,nodes,compact,BC)
% Returns knotty-centrality of the subgraph of CIJ comprising only
% "nodes" and the associated connections
    if length(nodes) < 3
        kc = 0;
    else
        CIJ = (CIJ > 0).*1; % binarise matrix
        N = length(CIJ); % nodes in overall graph
        M = length(nodes); % nodes in subgraph
        BCtot = sum(BC(nodes));
        p = ((N-M)/N); % proportion of nodes not in subgraph
        RC = sum(sum(CIJ(nodes,nodes)))/(M*(M-1)); % density of subgraph
        if compact
            kc = p*BCtot*RC; % compact knotty-centrality
        else
            kc = BCtot*RC; % knotty-centrality
        end
    end
end
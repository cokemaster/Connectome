function [node_arr kc] = FindKnottyCentre(CIJ,compact)
% Attempts to find the sub-graph of CIJ with the highest value for
% knotty-centrality. Carries out a series of exhaustive searches on
% subsets of the nodes ranked by "indirect" betweenness centrality, then
% carries out a phase of hill-climbing to see whether the sub-graph can
% be improved by adding further nodes. Uses the Brain Connectivity
% Toolbox (Rubinov & Sporns, 2010) for betweenness centrality
%
% nodes = the sub-graph found
% kc = its knotty-centredness
% compact = 1 if compact knotty-centrality to be used, 0 otherwise
%
% Written by Murray Shanahan, October 2011
    %empty output weights
    node_arr = zeros(1, size(CIJ,1));
    N = length(CIJ);
    CIJ = (CIJ > 0).*1; % binarise matrix - all non-zero weights become 1s
    % Exhastive search phase
    Exh = 10; % number of nodes for exhaustive search (2^Exh combinations)
    Exh = min(Exh,N);
    BC = betweenness_bin(CIJ); % betweenness centralities (Rubinov & Sporns)
    BC = BC/sum(BC); % normalise wrt total betweenness centrality
    % Calculate indirect betweenness centrality
    BC2 = zeros(1,N);
    for i = 1:N
        BC2(i) = BC(i)+(sum(CIJ(i,:).*BC(i)))+(sum(CIJ(:,i)'.*BC(i)));
    end
 
    [~, IxBC] = sort(BC2,'descend'); % rank nodes
    nodes = [];
    improving = 1;
    while improving
       L = length(nodes);
       nodes_left = IxBC;
       nodes_left = nodes_left(~ismember(nodes_left,nodes));
       choices = nodes_left(1:min(Exh,end));
       [nodes kc] = BestPerm(nodes,choices,CIJ,compact,BC);
       node_arr(nodes) = kc; % remember kc
       improving = length(nodes) > L;
    end
 
 
    % Hill climbing phase
    nodes_left = 1:N;
    nodes_left = nodes_left(~ismember(nodes_left,nodes));
    improving = 1;
    while improving && ~isempty(nodes_left)
       best_kc = 0;
       for i = 1:length(nodes_left)
          node = nodes_left(i);
          nodes2 = [nodes, node];
          kc2 = KnottyCentrality(CIJ,nodes2,compact,BC);
          if kc2 > best_kc
             best_kc = kc2;
             best_node = node;
          end
          if kc2 > node_arr(node)
            node_arr(node) = kc2; % remember kc2
          end
       end
   
       if best_kc > kc
          kc = best_kc;
          nodes = [nodes, best_node];
          nodes_left = nodes_left(nodes_left ~= best_node);
       else
          improving = 0;
       end
    end
    node_arr(nodes) = kc;
    node_arr = (node_arr - min(node_arr))/(max(node_arr) - min(node_arr));
    node_arr = round(node_arr * 100);
end
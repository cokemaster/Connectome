function [nodes,kc] = BestPerm(given,choices,CIJ,compact,BC)
% Carries out exhaustive search to find a permutation of nodes in
% "choices" that when added to the nodes in "given" yields the highest
% value of knotty-centrality
 
    if ~isempty(choices)
        choices2 = choices(2:end);
        new = choices(1);
   
        [nodes1,kc1] = BestPerm([given, new],choices2,CIJ,compact,BC);
        [nodes2,kc2] = BestPerm(given,choices2,CIJ,compact,BC);
   
        if kc1 > kc2
          nodes = nodes1;
          kc = kc1;
        else
          nodes = nodes2;
          kc = kc2;
        end
    else
        nodes = given;
        kc = KnottyCentrality(CIJ,nodes,compact,BC);
    end
end
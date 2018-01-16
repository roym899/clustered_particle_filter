% This function generates a new random cluster and adds it to the set of
% current clusters.
% Inputs:
%           C                   Cell Array with the current set of clusters
%           type                What kind of new cluster to generate 
%           map                 Map used
% Outputs:
%           C               New set of clusters. Size = size(C)+1



function C = generate_new_cluster(C,type,map,number)

currParticles = sum(cellfun('length',C));

switch type
    case 'uniform'
        C{end+1} = generate_uniform_particle_set(map,number);
    case 'focused'
        C = find_sparse(C,map,17,number);
end

end


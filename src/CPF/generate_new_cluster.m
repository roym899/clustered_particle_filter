% This function generates a new random cluster and adds it to the set of
% current clusters.
% Inputs:
%           C                   Cell Array with the current set of clusters
%           type                What kind of new cluster to generate 
%           map                 Map used
%           sparseness          Used in find_spase. See find_sparse
%           number              Number of particles in the new cluster
% Outputs:
%           new_Cluster         New cluster. 



function new_cluster = generate_new_cluster(C,type,map,number,sparseness)

currParticles = sum(cellfun('length',C));

switch type
    case 'uniform'
        new_cluster = generate_uniform_particle_set(map,number);
    case 'focused'
        new_cluster = find_sparse(C,map,sparseness,number);
end


end


function [ S ] = merge_clusters( C )
%MERGE_CLUSTERS Merges all clusters together into one set of particles

S = [];

for i=1:length(C)
    S = [S; C{i}]; 
end

end


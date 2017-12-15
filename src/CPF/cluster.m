% This function should returns the set of particles as partitions based on
% clusters. Currently this is done by a variation of the Lloy's Algorithm
% for K-means clustering.
%
% Inputs:
%           S                   MX3 current particle set
%           iterations          1x1 number of iteration in meanshift       
% Outputs:
%           C                   cell array containing the partition of S into a number of sets based on clusters. 
function C = cluster(S,iterations)
 Sr = S; 
 Stemp = S;
r = 0,1; % This parameter decides what the radius of the func is.
for i = 1:iterations
    for p = 1:size(Sr,1)
    d = pdist2((Sr(p,:)),S);
    Stemp = S(S(S((d<r)&(d>0))),:);
    if(isempty(Stemp))
        Stemp = Sr(p,:);
    end
    Sr(p,:) = sum(Stemp,1)/size(Stemp,1);
    end
    Sr
    Sr = unique(Sr,'rows','stable')
end

dist = pdist2(S,Sr);
[~,idx] = min(dist,[],2);

clusters = size(unique(idx),1);
C = cell(1,clusters);

for i = 1:clusters
    C{i} = S(idx == i,:);
end

end
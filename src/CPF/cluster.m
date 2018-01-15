% This function should returns the set of particles as partitions based on
% clusters. Currently this is done by a variation of the Lloyd's Algorithm
% for K-means clustering.
%
% Inputs:
%           S                   MX3 current particle set
%           minEuclidian        1x1 maximal euclidian distance for neighbourhood   
%           minTheta            1x1 maximal angle distance for neighbourhood
%           minNeighbours       1x1 minim number of neighbours to be a core
% Outputs:
%           C                   cell array containing the partition of S into a number of sets based on clusters. 
function C = cluster(S,maxEuclidian,maxTheta,minNeighbours)
Cl = 0;
C = {};
points = zeros(size(S,1),1);
d_euclidean = pdist2((S(:,[1,2])),S(:,[1,2]));
angles = S(:,3);
d_angle = repmat(angles, 1, size(S,1))-transpose(repmat(angles, 1, size(S,1)));
d_angle = mod(d_angle,pi);
for p = 1:size(S,1)
    if ((points(p))) 
        continue;
    end
    
    ang = d_angle(p,:);
    
    exclude_me = ones(1,size(S,1));
    exclude_me(p) = 0;
    indx = find(not(points)'&((d_euclidean(p,:)<maxEuclidian)&(exclude_me)&(ang'<maxTheta)'));
    i = 1;
    M = size(indx,1);
    if(M<minNeighbours) 
        continue;
    end
    Cl = Cl +1;
    indx_duplicate = indx;
    points(p) = Cl;
    while(i<M+1)
        if(points(indx(i)))
            i=i+1;
            continue;
        end
        points(indx(i)) = Cl;
        ang = d_angle(indx(i),:);
        exclude_me = ones(1,size(S,1));
        exclude_me(indx(i)) = 0;
        log_idx = zeros(size(S,1),1);
        log_idx(indx) = 1;
        neigh = (d_euclidean(indx(i),:)<maxEuclidian)&exclude_me&~log_idx';
        if(size(find(neigh))>=minNeighbours)
            newIndx = find(neigh);
            indx_duplicate = [indx_duplicate setdiff(newIndx,indx_duplicate)];
            indx = [indx newIndx ];
            M = size(indx,2);
        end
        i = i+1;
    end
    size(indx)
    C{end+1} = S(indx_duplicate,:);
end


for n = 1:size(points)
    if(not(points(n)))
        C{end+1} = S(n,:);
    end
end


end	
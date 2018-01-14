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
for p = 1:size(S,1)
    if ((points(p))) 
        continue;
    end
    d = pdist2((S(p,[1,2])),S(:,[1,2]));
    ang = zeros(size(S,1),1);
    for v = 1:size(S,1)
       ang(v) = abs(angdiff(S(p,3),S(v,3)));  
    end
    indx = find(not(points)&((d<maxEuclidian)&(d>0)&(ang'<maxTheta))');
    N = S(indx,:);
    i = 1;
    M = size(N,1);
    if(M<minNeighbours) 
        continue;
    end
    Cl = Cl +1;
    points(p) = Cl;
    while(i<M+1)
        if(points(indx(i)))
            i=i+1;
            continue;
        end
        
        points(indx(i)) = Cl;
        d2 = pdist2(N(i,[1,2]),S(:,[1,2]));
        for v = 1:size(S,1)
            ang(v) = abs(angdiff(N(i,3),S(v,3)));  
        end
        neigh = points(((d2<maxEuclidian)&(ang'<maxTheta)))==0;
        if(size(neigh)>minNeighbours)
            N = unique([N;S(neigh,:)],'rows');
            indx = unique([indx find(neigh)]);
            M = size(N,1);
        end
        i = i+1;
    end
    
    C{end+1} = unique([N;S(p,:)],'rows');
    N = [];
end
for n = 1:size(points)
    if(not(points(n)))
        C{end+1} = S(n,:);
    end
end


end


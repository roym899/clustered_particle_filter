% This function finds an area with no particles in the 3d space.
% Inputs:
%           C                   Cell Array with the current set of clusters
%           map                 Map used 
%           sparsenessFactor    Measure of how sparse areas have to be to considered empty;
%           number              Number of particles in the new cluster 
%        
% Outputs:
%           new_cluster         Extra set

function new_cluster = find_sparse(C,map,sparsenessFactor,number)
Stemp = [];
xlength = map.limits(2) - map.limits(1);
ylength = map.limits(4) - map.limits(3);
zlength = 2*pi;
for i = 1:size(C,2)
    Stemp = [Stemp; C{i}];
end
[N,xed,yed] = histcounts2(Stemp(:,1),Stemp(:,2),[0:xlength/50:xlength],[0:ylength/50:ylength]);
binim = (conv2(N,ones(sparsenessFactor),'same'))==0;
[x y] = find(binim);
cord = [x y];
if(isempty(cord))
    return;
end
rnd = randi([1 size(cord,1)],number,1);
new_cluster = zeros(number,3);
for i = 1:number
        temp = cord(rnd(i),:);
        tx = temp(1);
        ty = temp(2);
        new_cluster(i,:) =rand(1, 3).*[xed(tx+1)-xed(tx)  yed(ty+1)-yed(ty) 2*pi] + [xed(tx), yed(ty), -pi];

end


end


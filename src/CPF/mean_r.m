%This function find the mean of a number of points at a distance r away
%from a given point
%
% Inputs:
%           S                   set of points
%           p                   point of interest
% Outputs:
%           m                   mean point

function m = mean_r(S,p)
% r distance
r = 0.5
points = S(S(S(pdist2(p,S)<r)),:);
m = sum(points,1)/size(points,1);

end
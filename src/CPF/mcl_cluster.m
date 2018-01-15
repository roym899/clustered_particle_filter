% This function performs one iteration of Clustered Monte Carlo Localization
% 
% Inputs:
%           C                   Cell array of N clusters each consisting
%           comprised of a MiX3 matrix representing the particles
%           R                   3X3 Motion noise
%           Q                   8X8 Measurement noise
%           z                   NX8 Measurements
%           u                   3X1
%           map                 struct
%           robot               struct
% Outputs:
%           S(t)                MX3
function S = mcl_cluster(C, R, Q, z, u, map, robot)
    % loop over the clusters and apply normal mcl inside each cluster
    for i=1:length(C)
        S = C{i};
        S_bar = motion_model(robot, S, u, R);
        W = weight(S_bar,Q,z,map,robot);
        S = multinomial_resample(S_bar, W);
        % quality measure of the clusters
        
        % adapt 
    end
end
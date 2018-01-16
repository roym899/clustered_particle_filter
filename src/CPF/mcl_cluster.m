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
%           adapt               float
%           W                   
% Outputs:
%           S(t)                MX3
function [C, W] = mcl_cluster(C, R, Q, z, u, map, robot, adapt_threshold, W, max_particles, adapt_particles)
    if nargin < 8
        adapt_threshold = 0;
    end

    % loop over the clusters and apply normal mcl inside each cluster
    for i=1:length(C)
        if adapt_threshold == 0 || ~adapt_particles
            S = C{i};
            S_bar = motion_model(robot, S, u, R);
            W{i} = weight(S_bar,Q,z,map,robot);
            C{i} = multinomial_resample(S_bar, W{i}); 
        else
            S = C{i};
            S_bar = motion_model(robot, S, u, R);
            [W{i}, unscaled_w] = weight(S_bar,Q,z,map,robot);
            W_original = W{i};
            if sum(unscaled_w) > adapt_threshold % enough particles already, reduce the number of particles
                idx = find(cumsum(unscaled_w) > sum(unscaled_w)-adapt_threshold, 1);
                W{i} = W{i}(idx:end, :);
                W{i} = W{i}./sum(W{i});
                S_bar = S_bar(idx:end,:);
            else % not enough particles, add particles until the set is good
                while sum(unscaled_w) < adapt_threshold && size(S_bar,1) < max_particles
                    new_particle = vanilla_resample(S, W_original,1);
                    new_particle_bar = motion_model(robot, new_particle, u, R);
                    [new_w, new_unscaled_w] = weight(new_particle_bar,Q,z,map,robot);
                    unscaled_w = [unscaled_w; new_unscaled_w];
                    W{i} = [W{i}; new_w];
                    W{i} = W{i}./sum(W{i});
                    S_bar = [S_bar; new_particle_bar];
                end
            end
            C{i} = multinomial_resample(S_bar, W{i}); 
        end
    end
end
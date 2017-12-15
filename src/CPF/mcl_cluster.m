% This function performs one iteration of Clustered Monte Carlo Localization
% 
% Inputs:
%           S(t-1)              MX3 Previous particle ser
%           R                   3X3 Motion noise
%           Q                   8X8 Measurement noise
%           z                   NX8 Measurements
%           u                   3X1 
%           t                   1X1 Timestep
%           map                 struct
%           robot               struct
% Outputs:
%           S(t)                MX3
function S = mcl_cluster(C,S,R,Q,z,u,t,map,robot)
S_bar = motion_model(S,R,u,map,robot);
S_bar = weight(S_bar,Q,z,map,robot);
S = multinomial_resample(S_bar);

end
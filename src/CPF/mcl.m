% This function should perform one iteration of Monte Carlo Localization
% normal
% Inputs:
%           S(t-1)              MX3 Previous particle ser
%           R                   3X3 Motion noise
%           Q                   8X8 Measurement noise
%           z                   1X8 Measurements
%           u                   1X2 Controls 
%           map                 struct
%           robot               struct
% Outputs:
%           S(t)                MX3
function S = mcl(S, R, Q, z, u, map, robot)
S_bar = motion_model(robot, S, u, R);
W = weight(S_bar,Q,z,map,robot);
S = multinomial_resample(S_bar, W);

end
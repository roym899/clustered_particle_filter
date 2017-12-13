% This function should perform one iteration of Monte Carlo Localization
% normal
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
function S = mcl(S,R,Q,z,u,t,map,robot)
S_bar = motion_model(S,R,u,map,robot);
S_bar = weight(S_bar,Q,z,map,robot);
S = multinomial_resample(S_bar);

end
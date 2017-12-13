% function [S_bar] = predict(S,u,R)
% This function should perform the prediction step of MCL
% Inputs:
%           S(t-1)              4XM
%           v(t)                1X1
%           omega(t)            1X1
%           R                   3X3
%           delta_t             1X1
% Outputs:
%           S_bar(t)            4XM
function [S_bar] = predict(S,v,omega,R,delta_t)
M = size(S, 2);
u = [v*delta_t*cos(S(3,:)); v*delta_t*sin(S(3,:)); delta_t*repmat(omega, 1, M); zeros(1, M)];
S_bar = S+u+[sqrt(R)*randn(3, M); zeros(1, M)];
end
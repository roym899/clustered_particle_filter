% function W = weight(S_bar,z)
% Calculates new weights
%           S_bar:              MX3
%           Q:                  8X8 diagonal
%           z:                  1x8
%           map                 struct
%           robot               struct
% Outputs: 
%           W:                  MX1
function W = weight(S_bar,Q,z,map,robot)
% n = size(z, 1);
% M = size(S_bar, 1);
% nu = zeros(2, M);
% Psi = zeros(1,n,M);
% for i=1:n
%     nu(:, :) = observation_model(robot, map, S_bar)-z(:,i);
%     nu(2,:) = mod(nu(2, :)+pi,2*pi)-pi;
%     likelihood = transpose(1/(2*pi*sqrt(det(Q))) * exp(-1/2 * suzm(nu(:, :)'*inv(z).*nu(:, :)', 2)));
%     Psi(1, i, :) = transpose(max(likelihood, [], 2));
% end
% W(1,:) = prod(Psi, 2);

nu = observation_model(robot, map, S_bar)-z;
likelihood = prod(normpdf(nu,0,Q),2);
W = likelihood./sum(likelihood);
end 

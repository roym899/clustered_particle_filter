% function [outlier,Psi] = associate_known(S_bar,z,W,Lambda_psi,Q,known_associations)
%           S_bar(t)            4XM
%           z(t)                2Xn
%           W                   2XN
%           Lambda_psi          1X1
%           Q                   2X2
%           known_associations  1Xn
% Outputs: 
%           outlier             1Xn
%           Psi(t)              1XnXM
function [outlier,Psi] = associate_known(S_bar,z,W,Lambda_psi,Q,known_associations)
n = size(z, 2);
M = size(S_bar, 2);

nu = zeros(2, M, n);

for j=1:n
    nu(:, :, j) = observation_model(S_bar, W, known_associations(j));
end

%BE SURE THAT YOUR innovation 'nu' has its second component in [-pi, pi]
nu(:,2, :) =mod(nu(:, 2, :)+pi,2*pi)-pi;

Psi = 1/(2*pi*sqrt(det(Q))) * exp(-1/2 * nu(:, :, :)'*inv(Q)*nu(:, :, :));

outlier = 1/M.*sum(Psi, 3) < Lambda_psi;

end

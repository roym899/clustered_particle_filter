    % function [outlier,Psi] = associate(S_bar,z,W,Lambda_psi,Q)
%           S_bar(t)            4XM
%           z(t)                2Xn
%           W                   2XN
%           Lambda_psi          1X1
%           Q                   2X2
% Outputs: 
%           outlier             1Xn
%           Psi(t)              1XnXM
function [outlier,Psi] = associate(S_bar,z,W,Lambda_psi,Q)
n = size(z, 2);
N = size(W, 2);
M = size(S_bar, 2);

nu = zeros(2, M);
Psi = zeros(1,n,M);
likelihood = zeros(M,N);

for i=1:n
    for j=1:N
        nu(:, :) = observation_model(S_bar, W, j)-z(:,i);
        %BE SURE THAT YOUR innovation 'nu' has its second component in [-pi, pi]
        nu(2,:) =mod(nu(2, :)+pi,2*pi)-pi;
        likelihood(:,j) = transpose(1/(2*pi*sqrt(det(Q))) * exp(-1/2 * sum(nu(:, :)'*inv(Q).*nu(:, :)', 2)));
    end
    Psi(1, i, :) = transpose(max(likelihood, [], 2));
end

outlier = 1/M.*sum(Psi, 3) < Lambda_psi;

end
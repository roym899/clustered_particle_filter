% function S = multinomial_resample(S_bar,W)
% This function performs systematic re-sampling
% Inputs:   
%           S_bar(t):       MX3
%           W:              MX1
% Outputs:
%           S(t):           MX3
function S = multinomial_resample(S_bar,W)
M = size(S_bar,1);
cdf = cumsum(W);
r = rand(1, M);
S = zeros(M,3);
for i=1:M
    idx = find(cdf>r(i), 1);
    S(i,:) = S_bar(idx,:);
end
end
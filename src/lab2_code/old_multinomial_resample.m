% function S = multinomial_resample(S_bar)
% This function performs systematic re-sampling
% Inputs:   
%           S_bar(t):       4XM
% Outputs:
%           S(t):           4XM
function S = multinomial_resample(S_bar)
M = size(S_bar, 2);
cdf = cumsum(S_bar(4,:));
r = rand(1, M);
S = zeros(4, M);
for i=1:M
    idx = find(cdf>r(i), 1);
    S(:,i) = S_bar(:, idx);
end
S(4,:) = 1/M;
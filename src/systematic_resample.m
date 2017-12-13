% function S = systematic_resample(S_bar)
% This function performs systematic re-sampling
% Inputs:   
%           S_bar(t):       4XM
% Outputs:
%           S(t):           4XM
function S = systematic_resample(S_bar)
M = size(S_bar, 2);
cdf = cumsum(S_bar(4,:));
r = 1/M*rand(1);
r_0 = r;
S = zeros(4, M);
for i=1:M
    idx = find(cdf>r_0+(i-1)/M, 1);
    S(:,i) = S_bar(:, idx);
end
S(4,:) = 1/M;
end
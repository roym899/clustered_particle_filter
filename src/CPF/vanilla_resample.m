function [ S_sampled ] = vanilla_resample( S, W, n )
%VANILLA_RESAMPLE draws n samples from S with a probability of W
M = size(S, 2);

cdf = cumsum(W);
r = rand(1, n);
S_sampled = zeros(n, 3);
for i=1:n
    idx = find(cdf>r(i), 1);
    S_sampled(i,:) = S(idx, :);
end
S(4,:) = 1/M;


end


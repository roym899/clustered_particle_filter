% function S_bar = weight(S_bar,Psi,outlier)
%           S_bar(t)            4XM
%           outlier             1Xn
%           Psi(t)              1XnXM
% Outputs: 
%           S_bar(t)            4XM
function S_bar = weight(S_bar,Psi,outlier)

S_bar(4,:) = prod(Psi(1, ~outlier, :), 2);

%BE CAREFUL TO NORMALIZE THE FINAL WEIGHTS
S_bar(4,:) = S_bar(4,:)/sum(S_bar(4,:));
end

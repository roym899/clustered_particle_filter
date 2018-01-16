function [ means ] = cluster_mean( C )
%CLUSTER_MEAN Returns the mean of the passed clusters

means = zeros(length(C),3);

for i=1:length(C)
      
    C{i}(:,3) = atan2(sum(sin(C{i}(:,3))),sum(cos(C{i}(:,3))));
    means(i,:) = mean(C{i});
end

end


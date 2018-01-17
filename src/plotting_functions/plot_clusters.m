function [ ] = plot_clusters( clustered_particles, threed )

if nargin < 2
    threed = false;
end

hold on
for i=1:length(clustered_particles)
    if threed
        scatter3(clustered_particles{i}(:,1), clustered_particles{i}(:,2), clustered_particles{i}(:,3), 10, '.');
        zlim([-pi pi]);
    else
        scatter(clustered_particles{i}(:,1), clustered_particles{i}(:,2),10,'.');
    end
end
hold off

end


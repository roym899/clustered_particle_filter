function [ ] = plot_clusters( clustered_particles, threed, extra_set )

if nargin < 2
    threed = false;
end

if nargin < 3
    extra_set = false;
end

hold on
for i=1:length(clustered_particles)
    if threed
        if extra_set == true
            scatter3(clustered_particles{i}(:,1), clustered_particles{i}(:,2), clustered_particles{i}(:,3), 10, '.', 'MarkerEdgeColor', [0.7 0.7 0.7]);
        else
            scatter3(clustered_particles{i}(:,1), clustered_particles{i}(:,2), clustered_particles{i}(:,3), 20, '.');
        end
        zlim([-pi pi]);
    else
        if extra_set == true
            scatter(clustered_particles{i}(:,1), clustered_particles{i}(:,2),10,'.', 'MarkerEdgeColor', [0.7 0.7 0.7]);
        else
            scatter(clustered_particles{i}(:,1), clustered_particles{i}(:,2),20,'.');
        end
    end
end
hold off

end


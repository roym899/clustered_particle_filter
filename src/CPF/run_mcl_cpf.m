% function run_mcl_cpf(map,robot,data,mode)
% Principal run function. main.

% Inputs:
%			map:			struct
%			robot:          struct
%			data:			struct
%           mode:           1X1
%           initial_particle_set:   Mx3
%           control_variance:       2x2
%           measurement_variance:   1x1



function run_mcl_cpf(map, robot, data, mode, initial_particle_set, control_variance, measurement_variance, clustering_options)
t = 0;

z = data.measurements;
u = data.control;
S = initial_particle_set;
R = control_variance;
Q = measurement_variance;

canvas = figure;

clf(canvas);
plot_map(map);
hold on
plot(S(:,1), S(:,2), '.','MarkerSize',3,'Color','blue');
hold off
drawnow
    
flag = 1;
while 1 
    t = t+1;
    switch mode
        case 'mcl'
            S = mcl(S,R,Q,z(t,:),u(t,:),map,robot);
        case 'mcl_cpf'
            if t==1
                C{1} = initial_particle_set;
            end
            C = mcl_cluster(C,R,Q,z(t,:),u(t,:),map,robot);
            if t==clustering_options.first_timestep
                S = [];
                for i=1:length(C)
                    S = [S; C{i}];
                end
                C = cluster(S, clustering_options.distance, clustering_options.angle_distance, 1);
            end
        case 'mcl_cpf_extra'
            
        case 'mcl_cpf_adaptive_likelihood'
            % start with the inital number of particles
            if t==1
                C{1} = initial_particle_set;
                W = {};
                adapt = 0;
            end
            if mod(t, 20) == 0
                [C, W] = mcl_cluster(C,R,Q,z(t,:),u(t,:),map,robot, adapt, W, clustering_options.max_cluster_particles, true);
            else
                [C, W] = mcl_cluster(C,R,Q,z(t,:),u(t,:),map,robot, adapt, W, clustering_options.max_cluster_particles, false);
            end
            if t==clustering_options.first_timestep
                S = [];
                for i=1:length(C)
                    S = [S; C{i}];
                end
                C = cluster(S, clustering_options.distance, clustering_options.angle_distance, 1);
                adapt = clustering_options.likelihood_threshold;
            end
    end
    
    
    switch mode
        case 'mcl'
            clf(canvas);
            plot_map(map);
            hold on
            plot(S(:,1), S(:,2), '.','MarkerSize',3,'Color','blue');
            hold off
            plot_robot(robot, data.actual_state(t,:), data.measurements(t,:), true);
            drawnow
        case 'mcl_cpf'
            clf(canvas);
            plot_map(map);
            hold on
            plot_clusters(C);
            hold off
            plot_robot(robot, data.actual_state(t,:), data.measurements(t,:), true);
            drawnow
        case 'mcl_cpf_extra'
        case 'mcl_cpf_adaptive_likelihood'
            clf(canvas);
            plot_map(map);
            hold on
            plot_clusters(C);
            hold off
            plot_robot(robot, data.actual_state(t,:), data.measurements(t,:), true);
            drawnow
    end
      
if t>=size(z,1) 
    break;
end
end


end
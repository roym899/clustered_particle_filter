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
if nargin < 8
    clustering_options.first_timestep = 10;
end

t = 0;

z = data.measurements;
u = data.control;
S = initial_particle_set;
R = control_variance;
Q = measurement_variance;

canvas = figure('Position', [100 100 1820, 880]);

clf(canvas);
plot_map(map);
hold on
plot(S(:,1), S(:,2), '.','MarkerSize',3,'Color','blue');
hold off
drawnow

next_clustering_timestep = clustering_options.first_timestep;

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
                S = merge_clusters(C);
                C = cluster(S, clustering_options.distance, clustering_options.angle_distance, 1);
            end
        case 'mcl_cpf_adaptive_likelihood'
            % start with the inital number of particles
            if t==1
                C{1} = initial_particle_set;
                W = {};
                adapt = 0;
            end
            if t == next_clustering_timestep
                S = [];
                for i=1:length(C)
                    S = [S; C{i}];
                end
                C = cluster(S, clustering_options.distance, clustering_options.angle_distance, 1);
                adapt = clustering_options.likelihood_threshold;
            end
            if mod(t, 20) == 0 || t == next_clustering_timestep  
                [C, W] = mcl_cluster(C,R,Q,z(t,:),u(t,:),map,robot, adapt, W, clustering_options.max_cluster_particles, true, clustering_options);
            else
                [C, W] = mcl_cluster(C,R,Q,z(t,:),u(t,:),map,robot, adapt, W, clustering_options.max_cluster_particles, false, clustering_options);
            end
            
            if length(C) == 0% no cluster left => kidnapping or no correct hypothesis => restart
                C{1} = initial_particle_set;
                next_clustering_timestep = t + clustering_options.first_timestep;
            end
        case 'mcl_cpf_adaptive_likelihood_extra'
            % start with the inital number of particles
            if t==1
                C{1} = initial_particle_set;
                W = {};
                adapt = 0;
            end
            if t == next_clustering_timestep
                S = [];
                for i=1:length(C)
                    S = [S; C{i}];
                end
                C = cluster(S, clustering_options.distance, clustering_options.angle_distance, 1);
                adapt = clustering_options.likelihood_threshold;
            end
            if mod(t, 20) == 0 || t == next_clustering_timestep  
                if exist('extra_cluster')
                    C{end+1} = extra_cluster{1};
                end
                [C, W] = mcl_cluster(C,R,Q,z(t,:),u(t,:),map,robot, adapt, W, clustering_options.max_cluster_particles, true, clustering_options);
                if(t == next_clustering_timestep)
                    C_original = C;
                end
                if(length(C) >0)
                    extra_cluster = generate_new_cluster(C_original,'focused',map,1000,13);
                    for b = 1:t-1
                        extra_cluster = mcl(extra_cluster,R,Q,z(b,:),u(b,:),map,robot);
                    end
                    extra_cluster = mcl_cluster({extra_cluster},R,Q,z(t,:),u(t,:),map,robot, adapt, {0}, clustering_options.max_cluster_particles, false, clustering_options);
                end
            else
                [C, W] = mcl_cluster(C,R,Q,z(t,:),u(t,:),map,robot, adapt, W, clustering_options.max_cluster_particles, false, clustering_options);
                if exist('extra_cluster')
                    extra_cluster = mcl_cluster(extra_cluster,R,Q,z(t,:),u(t,:),map,robot, adapt, {0}, clustering_options.max_cluster_particles, false, clustering_options);
                end
            end
            
            if length(C) == 0% no cluster left => kidnapping or no correct hypothesis => restart
                C{1} = initial_particle_set;
                clear('extra_cluster');
                next_clustering_timestep = t + clustering_options.first_timestep;
            end
        case 'mcl_cpf_extra'
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
                extra_cluster = generate_new_cluster(C,'focused',map,1000,17); 
            end
            
    
    end
    
    
    switch mode
        case 'mcl'
            clf(canvas);
            plot_map(map);
            hold on
            plot(S(:,1), S(:,2), '.','MarkerSize',5,'Color','blue');
            hold off
            plot_robot(robot, data.actual_state(t,:), data.measurements(t,:), true, 20, [1 0 0]);
            means = cluster_mean({S});
            plot_robot(robot, means(1,:), 0, false, 20, [0.0 0.0 0.0]);
            drawnow
%             f(t) = getframe
        case 'mcl_cpf'
            clf(canvas);
            plot_map(map);
            hold on
            plot_clusters(C);
            hold off
            plot_robot(robot, data.actual_state(t,:), data.measurements(t,:), true, 20, [1 0 0]);
%             
%             means = cluster_mean(C);
%             for i=1:size(means,1)
%                 plot_robot(robot, means(i,:), 0, false, 20, [0.0 0.0 0.0]);
%             end
%             f(t) = getframe
            
            drawnow
        case 'mcl_cpf_extra'
            clf(canvas);
            plot_map(map);
            hold on
            plot_clusters(C);
            hold off
            plot_robot(robot, data.actual_state(t,:), data.measurements(t,:), true, 20, [1 0 0]);
            drawnow
        case 'mcl_cpf_adaptive_likelihood'
            clf(canvas);
            plot_map(map);
            hold on
            plot_clusters(C, true);
            hold off
            plot_robot(robot, data.actual_state(t,:), data.measurements(t,:), true, 20, [1 0 0]);
            
            drawnow
%             f(t) = getframe
        case 'mcl_cpf_adaptive_likelihood_extra'
            clf(canvas);
            plot_map(map);
            hold on
            plot_clusters(C, true);
            if exist('extra_cluster')
                plot_clusters(extra_cluster, true, true);
            end
            hold off
            plot_robot(robot, data.actual_state(t,:), data.measurements(t,:), true, 20, [1 0 0]);
            drawnow
%             f(t) = getframe
    end
   
if t>=size(z,1) 
    break;
end
end

% make_video(f, 'merging_john.mj2', 30);

end
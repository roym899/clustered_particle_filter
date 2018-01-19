clear all

load('cluster_dropping.mat');

initial_particle_set = generate_uniform_particle_set(room_data.map, k);
 tic
 figure
 run_mcl_cpf(room_data.map, room_data.robot, room_data, 'mcl', initial_particle_set, [0.5, 0; 0 1], 0.5);
 t1(i) = toc;
close all
% tic
% figure
% clustering_options.first_timestep = 10;
% clustering_options.distance = 1;
% clustering_options.angle_distance = 1000;
% run_mcl_cp10000f(room_data.map, room_data.robot, room_data, 'mcl_cpf', initial_particle_set, [0.5, 0; 0 1], 0.5, clustering_options);
% toc

tic
clustering_options.first_timestep = 10;
clustering_options.distance = 1;
clustering_options.angle_distance = 1000;
clustering_options.max_cluster_particles = 500;
clustering_options.likelihood_threshold = 20;
run_mcl_cpf(room_data.map, room_data.robot, room_data, 'mcl_cpf_adaptive_likelihood', initial_particle_set, [0.5, 0; 0 1], 0.5, clustering_options);
t2(i) = toc;





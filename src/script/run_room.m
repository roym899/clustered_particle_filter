clear all

load('room_dataset.mat');

initial_particle_set = generate_uniform_particle_set(room_data.map, 5000);



figure
clustering_options.first_timestep = 10;
clustering_options.distance = 1;
clustering_options.angle_distance = 1000;
run_mcl_cpf(room_data.map, room_data.robot, room_data, 'mcl_cpf_extra', initial_particle_set, [0.5, 0; 0 1], 0.5, clustering_options);
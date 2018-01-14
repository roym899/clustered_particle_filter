clear all

load('room_dataset.mat');

initial_particle_set = generate_uniform_particle_set(room_data.map, 5000);

run_mcl_cpf(room_data.map, room_data.robot, room_data, 0, initial_particle_set, [0.5, 0; 0 1], 0.5);
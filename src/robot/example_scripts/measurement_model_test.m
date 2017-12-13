%% generate a room to test measurements in
map = init_map([0 5 0 4]);
map = add_wall(map, [1 1 4 1]);
map = add_wall(map, [4 1 4 3]);
map = add_wall(map, [4 3 1 3]);
map = add_wall(map, [1 3 1 1]);

plot_map(map);

%% generate eight sensor robot to test

robot = init_robot(0.5, 16, 2);

particle = [2, 2, 1];

tic
measurement = observation_model(robot, map, particle);
toc

plot_map(map);
plot_robot(robot, particle, measurement, true);
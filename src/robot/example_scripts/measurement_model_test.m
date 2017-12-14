%% generate a room to test measurements in
map = init_map([0 5 0 4]);
map = add_wall(map, [1 1 4 1]);
map = add_wall(map, [4 1 4 3]);
map = add_wall(map, [4 3 1 3]);
map = add_wall(map, [1 3 1 1]);

plot_map(map);

%% generate eight sensor robot to test

robot = init_robot(0.5, 8, 2);

particle = repmat([2, 2, 1], 10000, 1)+randn(10000, 3);

tic
measurement = observation_model(robot, map, particle);
toc

plot_map(map);
plot_robot(robot, particle(100,:), measurement(100,:), true);
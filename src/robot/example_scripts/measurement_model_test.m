%% generate a room to test measurements in
map = init_map([0 5 0 4]);
map = add_wall(map, [1 1 4 1]);
map = add_wall(map, [4 1 4 3]);
map = add_wall(map, [4 3 1 3]);
map = add_wall(map, [1 3 1 1]);

plot_map(map);

%% generate eight sensor robot to test

robot = init_robot(0.5, 20, 2);

particle = repmat([1.5, 2.5, -1.9], 1, 1);

tic
measurement = observation_model(robot, map, particle);
toc

plot_map(map);
plot_robot(robot, particle(1,:), measurement(1,:), true);
%% generate a room to test measurements in
map = init_map([0 5 0 4]);
map = add_wall(map, [1 1 4 1]);
map = add_wall(map, [4 1 4 3]);
map = add_wall(map, [4 3 1 3]);
map = add_wall(map, [1 3 1 1]);
map = add_wall(map, [1 2 1.5 2]);
map = add_wall(map, [4 2 3 2]);

plot_map(map);

%% generate eight sensor robot to test

robot = init_robot(0.04, 20, 2);

particle = repmat([2, 2, -1.9], 1, 1);

u = repmat([0.4 0.75], 10000);

canvas = figure;
for i=1:size(u,1)
    tic;
    clf(canvas);
    measurement = observation_model(robot, map, particle);
    plot_map(map);
    plot_robot(robot, particle, measurement, true);
    particle = motion_model(robot, particle, u(i,:), diag([0 0 0]));
    t = toc;
    if robot.sampling_interval - t > 0
        pause(robot.sampling_interval - t)
    end
end

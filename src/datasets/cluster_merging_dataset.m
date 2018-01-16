%% generates simple 10mx10m room dataset
map = init_map([0 11 0 11]);
map = add_wall(map, [1 5 1 6]);
map = add_wall(map, [1 6 3 6]);
map = add_wall(map, [3 6 5 8]);
map = add_wall(map, [5 8 5 10]);
map = add_wall(map, [5 10 6 10]);
map = add_wall(map, [6 10 6 8]);
map = add_wall(map, [6 8 8 6]);
map = add_wall(map, [8 6 10 6]);
map = add_wall(map, [10 6 10 5]);
map = add_wall(map, [10 5 8 5]);
map = add_wall(map, [8 5 6 3]);
map = add_wall(map, [6 3 6 1]);
map = add_wall(map, [6 1 5 1]);
map = add_wall(map, [5 1 5 3]);
map = add_wall(map, [5 3 3 5]);
map = add_wall(map, [3 5 1 5]);

plot_map(map);

%% define constants
sensors = 8;
control_variance = diag([0.1; 0.05]);
sensor_variance = 0.2;

%% set seed for reproducible results
rng(1);

%% generate eight sensor robot to test
robot = init_robot(0.1, sensors, 2, sensor_variance, control_variance);

state = [1.5, 5.5, 0];

control = repmat([0.4 0], 100,1);
control = [control; repmat([0 0], 100,1)];

canvas = figure;
room_data.control = add_control_noise(robot, control);
room_data.measurements = zeros(size(control,1), sensors);
room_data.actual_state = zeros(size(control,1), size(state,2));
room_data.map = map;
room_data.robot = robot;

for i=1:size(control,1)
    tic;
    clf(canvas);
    measurement = add_observation_noise(robot, observation_model(robot, map, state));
    plot_map(map);
    plot_robot(robot, state, measurement, true);
    state = motion_model(robot, state, control(i,:), [0, 0; 0, 0]); % move robot perfectly
    room_data.actual_state(i,:) = state;
    room_data.measurements(i,:) = measurement;
    t = toc;
    pause(0.001)
end



save('cluster_merging','room_data');


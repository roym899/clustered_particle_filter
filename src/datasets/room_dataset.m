%% generates simple 10mx10m room dataset
map = init_map([0 12 0 12]);
map = add_wall(map, [1 1 11 1]);
map = add_wall(map, [11 1 11 11]);
map = add_wall(map, [11 11 1 11]);
map = add_wall(map, [1 11 1 1]);

plot_map(map);

%% define constants
sensors = 8;
control_noise = diag([0.05; 0.5]);
sensor_variance = 0.1;

%% set seed for reproducible results
rng(1);

%% generate eight sensor robot to test
robot = init_robot(0.1, sensors, 2);

state = [2, 2, 0];

control = repmat([0.4 0], 200,1);

canvas = figure;
room_data.control = control;
room_data.measurements = zeros(size(control,1), sensors);
room_data.actual_state = zeros(size(control,1), size(state,2));
room_data.map = map;
room_data.robot = robot;

for i=1:size(control,1)
    tic;
    clf(canvas);
    measurement = add_observation_noise(robot, observation_model(robot, map, state), sensor_variance);
    plot_map(map);
    plot_robot(robot, state, measurement, true);
    state = motion_model(robot, state, control(i,:), control_noise);
    room_data.measurements(i,:) = measurement;
    t = toc;
    pause(0.001)
end

save('room_dataset','room_data');


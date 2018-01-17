 %% generates simple 10mx10m room dataset
map = init_map([0 17 0 9]);
map = add_wall(map, [1 1 16 1]);
map = add_wall(map, [16 1 16 8]);
map = add_wall(map, [16 8 1 8]);
map = add_wall(map, [1 8 1 1]);
map = add_wall(map, [2 3 7 4]);
map = add_wall(map, [2 7 3 5]);
map = add_wall(map, [4 5 5 7]);
map = add_wall(map, [6 2 10 2]);
map = add_wall(map, [8 3 9 4]);
map = add_wall(map, [11 3 7 6]);
map = add_wall(map, [9 6 13 7]);
map = add_wall(map, [16 8 15 6]);
map = add_wall(map, [16 5 13 2]);

plot_map(map);

%% define constants
sensors = 8;
control_variance = diag([0.1; 0.05]);
sensor_variance = 0.2;

%% set seed for reproducible results
rng(1);

%% generate eight sensor robot to test
robot = init_robot(0.1, sensors, 2, sensor_variance, control_variance);

state = [2, 4, 0];

control = repmat([0.4 0.25], 50,1);
control = [control; repmat([0.4 0.1], 50,1)];
control = [control; repmat([0.2 0.2], 50,1)];
control = [control; repmat([0.2 -0.3], 50,1)];
control = [control; repmat([0.3 0.1], 50,1)];

canvas = figure;
room_data.control = add_control_noise(robot, control);
room_data.measurements = zeros(size(control,1), sensors);
room_data.actual_state = zeros(size(control,1), size(state,2));
room_data.map = map;
room_data.robot = robot;

for i=1:size(control,1)
    tic;
    clf(canvas);
    plot_map(map);
    plot_robot(robot, state, measurement, true);
    if i == 100 
        state = [ 11 2 pi/4 ];
    else
        state = motion_model(robot, state, control(i,:), [0, 0; 0, 0]); % move robot perfectly
    end
    measurement = add_observation_noise(robot, observation_model(robot, map, state));    
    room_data.actual_state(i,:) = state;
    room_data.measurements(i,:) = measurement;
    t = toc;
    drawnow
end



save('kidnapping','room_data');


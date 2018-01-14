function [ robot ] = init_robot( sampling_interval, sensor_num, max_range, measurement_variance, control_variance)
%INIT_ROBOT Initializes the robot and its sensors

if nargin < 4
    measurement_variance = 0;
    control_variance = diag([0 0]);
end

robot.sampling_interval = sampling_interval;
robot.max_range = max_range;
robot.measurement_variance = measurement_variance;
robot.control_variance = control_variance;

robot.sensors = [];
angles = linspace(0,2*pi,sensor_num + 1);
for i=1:sensor_num
    robot.sensors = [ robot.sensors; max_range.*[cos(angles(i)) sin(angles(i))] ];
end
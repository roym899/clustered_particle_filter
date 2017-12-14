function [ robot ] = init_robot( sampling_interval, sensor_num, max_range)
%INIT_ROBOT Initializes the robot and its sensors

robot.sampling_interval = sampling_interval;
robot.max_range = max_range;

robot.sensors = [];
angles = linspace(0,2*pi,sensor_num + 1);
for i=1:sensor_num
    robot.sensors = [ robot.sensors; max_range.*[cos(angles(i)) sin(angles(i))] ];
end
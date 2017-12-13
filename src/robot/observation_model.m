function [ observations ] = observation_model( robot, map, particles)
%OBSERVATION_MODEL Generates no noisy measurement vectors from particles
%   robot the robot to generates the measurement for
%   map the map to generates the measurement for
%   particles Mx3 matrix repreesnting particles to generate measurement for

sensor_num = size(robot.sensors,1);
observations = zeros(size(particles,1), sensor_num);

% convert map to lines
walls = [];
for i=1:size(map.walls,1)
    wall = [map.walls(i,1) map.walls(i,3) NaN; 
            map.walls(i,2) map.walls(i,4) NaN];
    walls = [walls wall];
end

for p=1:size(particles,1)
    rotated_sensors = robot.sensors*[cos(particles(p,3)) sin(particles(p,3)); -sin(particles(p,3)) cos(particles(p,3))];
    shifted_sensor_ends = rotated_sensors + particles(p, 1:2);
    for i=1:sensor_num
        intersection = InterX(walls, [particles(p, 1) shifted_sensor_ends(i,1); particles(p,2) shifted_sensor_ends(i,2)]);
        if size(intersection,2) >= 1
            observations(p, i) = min(sqrt( sum( (particles(p, 1:2) - intersection').^2, 2) ));
        else
            observations(p, i) = robot.max_range;
        end
    end
end
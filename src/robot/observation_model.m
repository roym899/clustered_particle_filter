function [ observations ] = observation_model( robot, map, particles)
%OBSERVATION_MODEL Generates no noisy measurement vectors from particles
%   robot the robot to generates the measurement for
%   map the map to generates the measurement for
%   particles Mx3 matrix repreesnting particles to generate measurement for

sensor_num = size(robot.sensors,1);
observations = zeros(size(particles,1), sensor_num);

% convert map to lines
walls = [];

d = zeros(size(particles,1), sensor_num, size(map.walls,1));

normed_sensors = robot.sensors ./ sqrt(sum(robot.sensors.^2,2));
for i=1:size(map.walls,1)
    if map.walls(i,1) ~= map.walls(i,3)
        line = [map.walls(i,1) 1; map.walls(i,3) 1]\[map.walls(i,2); map.walls(i,4)];
        for j=1:sensor_num
            d(:,j,i)=(line(2)-particles(:,2)+line(1)*particles(:,1))./(normed_sensors(j,1)*sin(particles(:,3))+normed_sensors(j,2)*cos(particles(:,3))-line(1)*normed_sensors(j,1)*cos(particles(:,3))+line(1)*normed_sensors(j,2)*sin(particles(:,3)));
        end
        d( or(d(:,:,:)<0, d(:,:,:)>robot.max_range) ) = robot.max_range; % this is not optimal yet as it checks stuff again every loop
    else
        for j=1:sensor_num
            d(:,j,i)=(map.walls(i,1)-particles(:,1))./(normed_sensors(j,1)*cos(particles(:,3))-normed_sensors(j,2)*sin(particles(:,3)));
        end
        d( or(d(:,:,:)<0, d(:,:,:)>robot.max_range) ) = robot.max_range; % this is not optimal yet as it checks stuff again every loop
    end
end

for i=1:sensor_num
    to_check = min(d(:,i,:), [], 3) < robot.max_range;
    while any(to_check)
        [check_d, wall_idx] = min(d(to_check,i,:), [], 3);
        lims = zeros(size(check_d, 1), 2);
        
        % set the limits depending if it is a vertical wall or not
        y_walls = map.walls(wall_idx,1) == map.walls(wall_idx,3);
        lims(~y_walls,:) = [min(map.walls(wall_idx(~y_walls),[1 3]), [], 2) max(map.walls(wall_idx(~y_walls),[1 3]), [],2)];
        lims(y_walls,:) = [min(map.walls(wall_idx(y_walls),[2 4]), [],2) max(map.walls(wall_idx(y_walls),[2 4]), [],2)];
        
        % calculate the relevant position
        pos = zeros(size(check_d, 1), 1);
        to_check_y = to_check;
        to_check_y(to_check_y) = to_check_y(to_check_y) & y_walls;
        to_check_ny = ~to_check_y & to_check;
        pos(~y_walls) = particles(to_check_ny,1) + check_d(~y_walls).*(normed_sensors(i,1).*cos(particles(to_check_ny,3))-normed_sensors(i,2).*sin(particles(to_check_ny,3)));
        pos(y_walls) = particles(to_check_y,2) + check_d(y_walls).*(normed_sensors(i,2).*cos(particles(to_check_y,3))+normed_sensors(i,1).*sin(particles(to_check_y,3)));
        
        % check if limits are fine
        good_idx = pos > lims(:,1) & pos < lims(:,2);
        
        % update distances and remaining checks
        to_check(to_check) = xor(to_check(to_check), good_idx);
        
        wall_idx = wall_idx(~good_idx);
        part_idx = find(to_check);
        
        for j=1:sum(to_check)
            d(part_idx(j),i,wall_idx(j)) = robot.max_range;
        end
        
        to_check(to_check) = to_check(to_check) & min(d(to_check,i,:), [], 3) < robot.max_range;
    end
end

observations = min(d, [], 3);

%% slow version using intersection function
% for i=1:size(map.walls,1)
%     wall = [map.walls(i,1) map.walls(i,3) NaN; 
%             map.walls(i,2) map.walls(i,4) NaN];
%     walls = [walls wall];
% end
% 
% parfor (p=1:size(particles,1), 12)
%     rotated_sensors = robot.sensors*[cos(particles(p,3)) sin(particles(p,3)); -sin(particles(p,3)) cos(particles(p,3))];
%     shifted_sensor_ends = rotated_sensors + particles(p, 1:2);
%     for i=1:sensor_num
%         intersection = InterX(walls, [particles(p, 1) shifted_sensor_ends(i,1); particles(p,2) shifted_sensor_ends(i,2)]);
%         if size(intersection,2) >= 1
%             observations(p, i) = min(sqrt( sum( (particles(p, 1:2) - intersection').^2, 2) ));
%         else
%             observations(p, i) = robot.max_range;
%         end
%     end
% end
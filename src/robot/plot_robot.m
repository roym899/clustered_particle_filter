function [ ] = plot_robot( robot, state, measurement, sensor_lines, siz, col )
%plot_robot Plots the robot with different verbosities
%   robot the robot to be plotted
%   state the current state of the robot
%   optional: measurement vector to plot, leave empty if not wanted
%   optional: sensor_lines, boolean draw lines representing the beams of the sensors

% check number of arguments
if nargin < 3
    col = [1,0,0];
    measurement = [];
    draw_sensors = false;
elseif nargin < 4
    sensor_lines = false;
    draw_sensors = false;
elseif nargin < 5
    siz = 20;
    draw_sensors = true;
    col = [1,0,0];
elseif nargin < 6
    col = [1,0,0];
    draw_sensors = true;
else
    draw_sensors = true;
end


hold on


% plot the sensor beams
if draw_sensors
    sensor_num = size(robot.sensors,1);
    rotated_sensors = robot.sensors*[cos(state(3)) sin(state(3)); -sin(state(3)) cos(state(3))];
    shifted_sensor_ends = rotated_sensors + state(1:2);
    % if wanted plot the sensor beams
    if sensor_lines
        for i=1:sensor_num
            line([state(1); shifted_sensor_ends(i, 1)], [state(2); shifted_sensor_ends(i, 2)], 'Color','black','LineStyle','--');
        end
    end
    if size(measurement,2) >= 1
        measured_sensor_ends = rotated_sensors .*measurement'./robot.max_range + state(1:2);
        for i=1:sensor_num
            line([state(1); measured_sensor_ends(i, 1)], [state(2); measured_sensor_ends(i, 2)], 'Color','green');
        end
    end
end

% draw the robot
line([state(1) state(1)+0.25*cos(state(3))], [state(2) state(2)+0.25*sin(state(3))],'Color',col);
plot(state(1), state(2), '.','MarkerSize',siz,'Color',col);

% ax = gca;
% 
% [john, map, alpha] = imread('robot.png');
% AxesHandle=findobj(gcf,'Type','axes');
% curaxes = plotboxpos(AxesHandle);
% axes('position',[(state(1)-0.5)/diff(xlim)*curaxes(3)+curaxes(1), (state(2)-0.65)/diff(ylim)*curaxes(4)+curaxes(2), size(john,2)/max(size(john))*curaxes(3)/10,  size(john,1)/max(size(john))*curaxes(4)/10]);
% f = imshow('robot.png');
% set(f, 'AlphaData', alpha);

hold off

% axes(ax)

end


function [ ] = plot_map( map, varargin )
%PLOT_MAP Plots the map defined by map
%   map map to plot
%   varargin can be used to change the plot

walls = size(map.walls, 1);

% make the plot nice
axis(map.limits);
axis('equal');

% plot all the walls, one by one
hold on
for i=1:walls
    line([map.walls(i,1); map.walls(i,3)], [map.walls(i,2); map.walls(i,4)], varargin{:});
end
hold off


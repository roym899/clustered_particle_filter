function [ map ] = init_map( limits )
%INIT_MAP Initilizes a map with a certain size
%   limits 1x4 row vector defining the boundaris of the map [xmin xmax ymin ymax]

map.limits = limits;
map.walls = [];

end


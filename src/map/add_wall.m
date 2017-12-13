function [ map ] = add_wall( map, coords )
%ADD_WALL Add a wall to map and return the new map
%   map Map to add the wall to
%   coords coords of the wall, should be in the form [x0 y0 x1 y1]

map.walls = [map.walls; coords];

end
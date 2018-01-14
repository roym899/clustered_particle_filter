function [ particles ] = generate_uniform_particle_set( map, m )
%GENERATE_UNIFORM_PARTICLE_SET Generates a uniform particle set in the map
%boundaries

particles = rand(m, 3).*[map.limits(2)-map.limits(1), map.limits(4)-map.limits(3), 2*pi] + [map.limits(1), map.limits(3), -pi];

end


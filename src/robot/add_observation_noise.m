function [ noisy_observations ] = add_observation_noise( robot, observations, variance )
%ADD_OBSERVATION_NOISE Adds uncorrelated noise according to the variance to
%the observation, still maxing out at max distance

if nargin < 3
    variance = robot.measurement_variance;
end

noisy_observations = observations + normrnd(0, variance, size(observations));
noisy_observations(noisy_observations < 0) = 0;
noisy_observations(noisy_observations > robot.max_range) = robot.max_range;

end


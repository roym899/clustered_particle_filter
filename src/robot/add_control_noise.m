function [ noisy_control ] = add_control_noies( robot, control, variance )
%ADD_CONTROL_NOIES Adds noise to a contorl measurement
if nargin < 3
    variance = robot.control_variance;
end

noisy_control = control + mvnrnd([0 0], variance, size(control, 1));

end


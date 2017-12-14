function [ updated_particles ] = motion_model( robot, particles, control, noise )
%MOTION_MODEL Applies the velocity motion model
%   robot       the robot to apply the motion for
%   particles   the particles the motion will be applied on Mx3
%   control     control vector 1x2 u=[v omega]
%   noise       covariance of gaussian noise to be added to each particle

control = control + 1e-12;
updated_particles = particles;
updated_particles(:,1) = updated_particles(:,1) - control(1)/control(2).*sin(particles(:,3)) + control(1)/control(2)*sin(particles(:,3) + control(2)*robot.sampling_interval);
updated_particles(:,2) = updated_particles(:,2) + control(1)/control(2).*cos(particles(:,3)) - control(1)/control(2)*cos(particles(:,3) + control(2)*robot.sampling_interval);
updated_particles(:,3) = updated_particles(:,3) + control(2)*robot.sampling_interval;

updated_particles = updated_particles(:,:) + mvnrnd([0 0 0], noise, size(updated_particles, 1));

end


%% initializes a robot with 8 sensors of 2m range and a sampling frequency of 500ms

robot = init_robot(0.5, 8, 2);

figure
axis([0 5 0 5]);
axis equal
plot_robot(robot, [1, 1, 0.3], [1 2 1.5 2 0.3 0.3 0.3 0.4], true);
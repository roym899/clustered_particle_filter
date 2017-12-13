%% creates a simple 3x2m room and plots it

room = init_map([0 5 0 4]);
room = add_wall(room, [1 1 4 1]);
room = add_wall(room, [4 1 4 3]);
room = add_wall(room, [4 3 1 3]);
room = add_wall(room, [1 3 1 1]);

plot_map(room);
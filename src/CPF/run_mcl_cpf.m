% function run_mcl_cpf(map,robot,data,mode)
% Principal run function. main.

% Inputs:
%			map:			struct
%			robot:          struct
%			data:			struct
%           mode:           1X1
%           initial_particle_set:   Mx3
%           control_variance:       2x2
%           measurement_variance:   1x1



function run_mcl_cpf(map, robot, data, mode, initial_particle_set, control_variance, measurement_variance)
t = 0;

z = data.measurements;
u = data.control;
S = initial_particle_set;
R = control_variance;
Q = measurement_variance;

canvas = figure;

clf(canvas);
plot_map(map);
hold on
plot(S(:,1), S(:,2), '.','MarkerSize',3,'Color','blue');
hold off
drawnow
    
flag = 1;
while 1 
    t = t+1;
    switch flag
        case 1
            if((t*mode)<10)
                S = mcl(S,R,Q,z(t,:),u(t,:),map,robot);
            else
                C = cluster(S);
                flag = 2;
            end
        case 2 
            S = mcl_cluster(C,S,R,Q,z,u,t,map,robot);
        case 3  
            S = restart(C,S,R,Q,z,u,t,map,robot);
            flag = 2;
    end
    
    
    clf(canvas);
    plot_map(map);
    hold on
    plot(S(:,1), S(:,2), '.','MarkerSize',3,'Color','blue');
    hold off
    plot_robot(robot, data.actual_state(t,:), data.measurements(t,:), true);
    drawnow
    
    if t>=size(z,1) 
        break;
    end
        
end


end
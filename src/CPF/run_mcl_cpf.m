% function run_mcl_cpf(map,robot,data,mode)
% Principal run function. main.

% Inputs:
%			map:			struct
%			robot:          struct
%			data:			struct
%           mode:           1X1



function run_mcl_cpf(map, robot, data,mode)
t = 0;
[S,R,Q,u] = init();
%z = data...
while 1 
    t = t+1;
    switch flag
        case 1
            if((t*mode)<10)
                S = mcl(S,R,Q,z,u,t,map,robot);
            else
                C = cluster(S);
                flag = 2;
            end
        case 2 
            S = mclcluster(S,C);
    end
    
end
end
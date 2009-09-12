
function [T,Y] = kuramoto(ic,adj,w,tSpan)

    % param{1} = number of nodes
    % param{2} = adjacency matrix
    % param{3} = natural frequencies
    param{1} = size(ic,1);
    param{2} = adj;
    param{3} = w;
    
    %[T Y] = ode45(@(t,y) odeKur(t,y,param),tSpan,ic);
    [T Y] = ode113(@(t,y) odeKur(t,y,param),tSpan,ic);
    
end % end kuramoto

function dy = odeKur(t,y,param)

    % dy = change in phase
    % y  = phase
    
    % dy = w + sum over j (k * sin(y(j) - y(i)))
    r = repmat(y,1,param{1});
    dy = param{3} + sum(param{2} .* sin(r'-r),2);
    
end % end ode

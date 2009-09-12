
function [T,Y] = sync(ic,adj,w,tSpan)

    % param{1} = number of community nodes
    % param{2} = adjacency matrix of community
    % param{3} = natural frequencies of all nodes
    param{1} = size(ic,1)-1;
    param{2} = adj;
    param{3} = w;
    
    %[T Y] = ode45(@(t,y) odeSync(t,y,param),tSpan,ic);
    [T Y] = ode113(@(t,y) odeSync(t,y,param),tSpan,ic);
    
end % end sync

function dy = odeSync(t,y,param)

    % dy = change in phase
    % y  = phase
    
    % kuramoto:
    % dy = w + sum over j (k * sin(y(j) - y(i)))
    r = repmat(y,1,param{1});
    dy = param{3}(1:param{1}) + sum(param{2} .* sin(r'-r),2);
    
    % mechanics of external system:
    dy(param{1}+1) = extSys();
    
    
end % end odeSync

function dy = extSys()

    % HOPF: !!! TODO !!! problem: where do the state vars go? >>> dy?
    % where does dw go, its not dy but the derivate...
    
    % dx = gamma * ( mu - ( x^2 + y^2 )) * x - dw * y + epsilon * FORCE (=
    % sin( dy(1) * t + theta ) ) 
    % dy = gamma * ( mu - ( x^2 + y^2 )) * y + dw * x
    
    % dw = - epsilon * FORCE * y / sqrt( x^2 + y^2)
    

end % end extSys

function [T,Y] = sync(ic,param,tSpan)

    % param{1}(1) = number of community nodes
    % param{1}(2) = dimension of external system
    % param{1}(3) = number of sensors connected
    % param{1}(4) = number of actuators connected
    % param{2} = adjacency matrix of the whole network
    % param{3} = natural frequencies of community nodes
    % param{4} = function handle to external system ode
    
    opt = odeset('RelTol',1e-6);

    [T Y] = ode113(@(t,y) odeSync(t,y,param),tSpan,ic,opt);
    
end % end sync

function dy= odeSync(t,y,param)

    % dy = change in phase
    % y  = phase
    
    % sizes of sub-systems
    N = param{1}(1);
    numExtStates = param{1}(2);
    Ntot = N+numExtStates;
    
    % external system function
    extSys = param{4};
    
    % pre-allocation
    dy = zeros(Ntot,1);
    
    % indices for nodes in the network
    indComm = 1:N;
    % indices for the external system
    indExt = (N+1):(N+numExtStates);
    
    % adjacency matrices
    commAdj = param{2}(indComm,indComm);
    sensorAdj = param{2}(1:N,N+1);
    actuatorAdj = param{2}(N+1,1:N);
    
%     actGain = param{2}(indSensor,1:N)~=0;
%     if sum(actGain)>1
%         disp('Error!!! Please connect only one actuator!');
%         return
%     end
%     actGain = sum(param{2}(indSensor,actGain));
    

    sensorSignals=sensorAdj(indComm)*sensorFunc(y(indExt));
    actSignals=actuatorAdj*actFunc(y(indComm));    
    
    % kuramoto:
    % dy = w + sum over j (k * sin(y(j) - y(i)))
    r = repmat(y(indComm),1,N);
    dy(indComm) = param{3}(indComm) + sum(commAdj .* sin(r'-r),2) + ...
                  sensorSignals;
    %   (t>20 & t<50)*extAdj(indComm)*y(indSensor,1);
    
%    dy(indSensor) = gradSensor(y(indExt)) * dy(indExt);
    
%    dy(indActuator) = gradActuator(y(indComm)) * dy(indComm);
    
    dy(indExt) = extSys(t,y,param) +  ExtActAdj*actSignals;
    
end % end odeSync

function s=sensorFunc(y,t)

    s=y(1);

end % end gradSensor


function da=gradActuator(y)
    N = numel(y);
    da = zeros(1,N);
    da(1,1) = cos(y(1));

end % end gradActuator


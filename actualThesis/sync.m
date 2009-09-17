
function [T,Y] = sync(ic,param,tSpan)

    % param{1}(1) = number of community nodes
    % param{1}(2) = dimension of external system
    % param{2} = adjacency matrix of the whole network
    % param{3} = natural frequencies of community nodes
    % param{4} = function handle to external system ode
    % param{5}{1} = nodes in community with sensors
    % param{5}{2} = handle to sensor function
    % param{5}{3} = internal states of external system connected to actuator
    % param{5}{4} = handle to actuator function

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
    
    % natural frequencies of community
    W = param{3};
    
    % pre-allocation
    dy = zeros(Ntot,1);
    
    % indices for nodes in the network
    indComm = 1:N;
    % indices for the external system
<<<<<<< .mine
    indExt = (N+1):(Ntot);
=======
    indExt = (N+1):(N+numExtStates);
>>>>>>> .r10
    
    % adjacency matrices
<<<<<<< .mine
    commAdj = param{2};
    sensorAdj = param{5}{1};
    actuatorAdj = param{5}{3};
=======
    commAdj = param{2}(indComm,indComm);
    sensorAdj = param{2}(1:N,N+1);
    actuatorAdj = param{2}(N+1,1:N);
>>>>>>> .r10
    
<<<<<<< .mine
    % functions
    sensorFunc=param{5}{2};
    actuatorFunc=param{5}{4};
=======
%     actGain = param{2}(indSensor,1:N)~=0;
%     if sum(actGain)>1
%         disp('Error!!! Please connect only one actuator!');
%         return
%     end
%     actGain = sum(param{2}(indSensor,actGain));
>>>>>>> .r10
    
<<<<<<< .mine
=======

    sensorSignals=sensorAdj(indComm)*sensorFunc(y(indExt));
    actSignals=actuatorAdj*actFunc(y(indComm));    
    
>>>>>>> .r10
    % kuramoto:
    % dy = w + sum over j (k * sin(y(j) - y(i)))
    r = repmat(y(indComm),1,N);
<<<<<<< .mine
    dy(indComm,1) = W + sum(commAdj .* sin(r'-r),2) + ...
                  sensorFunc(y(indExt),t) * sensorAdj;
=======
    dy(indComm) = param{3}(indComm) + sum(commAdj .* sin(r'-r),2) + ...
                  sensorSignals;
    %   (t>20 & t<50)*extAdj(indComm)*y(indSensor,1);
>>>>>>> .r10
    
<<<<<<< .mine
    dy(indExt,1) = extSys(t,y,param) + ...
                 actuatorFunc(y(indComm),t) * actuatorAdj;
=======
%    dy(indSensor) = gradSensor(y(indExt)) * dy(indExt);
>>>>>>> .r10
    
<<<<<<< .mine
=======
%    dy(indActuator) = gradActuator(y(indComm)) * dy(indComm);
    
    dy(indExt) = extSys(t,y,param) +  ExtActAdj*actSignals;
    
>>>>>>> .r10
end % end odeSync

<<<<<<< .mine
=======
function s=sensorFunc(y,t)

    s=y(1);

end % end gradSensor


function da=gradActuator(y)
    N = numel(y);
    da = zeros(1,N);
    da(1,1) = cos(y(1));

end % end gradActuator

>>>>>>> .r10


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
    numSensors = param{1}(3);
    numActuators = param{1}(4);
    Ntot = N+numExtStates+numSensors+numActuators;
    
    % external system function
    extSys = param{4};
    
    % pre-allocation
    dy = zeros(Ntot,1);
    
    % indices for nodes in the network
    indComm = 1:N;
    % indices of sensor(s)
    indSensor = (N+1):(N+numSensors);
    % indices of actuator(s)
    indActuator = (N+numSensors+1):(N+numSensors+numActuators);
    % indices for the external system
    indExt = (N+numSensors+numActuators+1):(N+numSensors+numActuators+numExtStates);
    
    % adjacency matrices
    commAdj = param{2}(indComm,indComm);
    sensorAdj = param{2}(1:N,indSensor);
    %actuatorAdj = param{2}(indSensor,1:N);
    
    actGain = param{2}(indSensor,1:N)~=0;
    if sum(actGain)>1
        disp('Error!!! Please connect only one actuator!');
        return
    end
    actGain = sum(param{2}(indSensor,actGain));
    
    %actuator=sin(y(indComm(1)));
    %sensor=sin(y(indExt));
    
    % kuramoto:
    % dy = w + sum over j (k * sin(y(j) - y(i)))
    r = repmat(y(indComm),1,N);
    dy(indComm) = param{3}(indComm) + sum(commAdj .* sin(r'-r),2) + ...
        sensorAdj(indComm) * y(indSensor,1);
    %   (t>20 & t<50)*extAdj(indComm)*y(indSensor,1);
    
    dy(indSensor) = gradSensor(y(indExt)) * dy(indExt);
    
    dy(indActuator) = gradActuator(y(indComm)) * dy(indComm);
    
    dy(indExt) = extSys(t,y,param) + actGain * y(indActuator,1);
    
end % end odeSync

function ds=gradSensor(y)

    ds(1,1)=1;

end % end gradSensor


function da=gradActuator(y)
    N = numel(y);
    da = zeros(1,N);
    da(1,1) = cos(y(1));

end % end gradActuator


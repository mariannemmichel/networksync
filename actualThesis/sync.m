
function dy = sync(t,y,param)
    
    % param{1}(1) = number of community nodes
    % param{1}(2) = dimension of external system
    % param{2} = adjacency matrix of the whole network
    % param{3} = natural frequencies of community nodes
    % param{4} = function handle to external system ode
    % param{5}{1} = nodes in community with sensors
    % param{5}{2} = handle to sensor function
    % param{5}{3} = internal states of external system connected to actuator
    % param{5}{4} = handle to actuator function
    
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
    indExt = (N+1):(Ntot);
    
    % adjacency matrices
    commAdj = param{2};
    sensorAdj = param{5}{1};
    actuatorAdj = param{5}{3};
    
    % sensor & actuator functions
    sensorFunc=param{5}{2};
    actuatorFunc=param{5}{4};
    
    sensorSignals=sensorAdj*sensorFunc(y(indExt),t);
    actuatorSignals=actuatorAdj*actuatorFunc(y(indComm));    
    
    % kuramoto:
    % dy = w + sum over j (k * sin(y(j) - y(i)))
    r = repmat(y(indComm),1,N);
    dy(indComm,1) = W + sum(commAdj .* sin(r'-r),2) + ...
                  sensorSignals;
    
    dy(indExt,1) = extSys(t,y,param) + actuatorSignals;

end % end sync


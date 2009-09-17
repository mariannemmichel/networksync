
% number of internal states of external sytem
numExtStates = 1;

% initial values of internal states of external system
IC(N+1:N+numExtStates,:) = pi*ones(1,numRuns);

% actuator gain
actGain = 0;

% connecting the external system: actuator adjacency
actuatorAdj = actGain * [ 1 ];

% actuator function
actuatorFunc = @(x,t) x(1);

if size(actuatorAdj,1) ~= numExtStates
    error('Actuator adjacency matrix does not have the right proportions!')
end
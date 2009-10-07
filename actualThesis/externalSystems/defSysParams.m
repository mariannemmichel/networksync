
% number of internal states of external sytem
numExtStates = 1;

% initial values of internal states of external system
IC(N+1:N+numExtStates,:) = pi*ones(1,numRuns);

% adjacency matrix of external system for actuator connection
externAdj = [ 1 ];

% parameters for external ode function
extParams = [];

% number of internal states of external sytem
numExtStates = 1;

% initial values of internal states of external system
IC(N+1:N+numExtStates,:) = pi*ones(1,numRuns);

% parameters for external ode function
extParams = [];
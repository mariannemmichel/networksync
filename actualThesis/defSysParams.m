
% number of internal states of external sytem
numExtStates = 1;

% initial values of internal states of external system
IC(N+numSensors+numActuators+1:N+numSensors+numActuators+numExtStates,:) = pi*ones(1,numRuns);

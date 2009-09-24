
% number of internal states of external sytem
numExtStates = 2;

% initial value of theta
IC(N+1,:) = (rand(1)-0.5)*2*pi*ones(1,numRuns);%(rand(1,numRuns)-0.5)*2*pi;
% initial value of omega
IC(N+2,:) = (rand(1)-0.5)*2*pi*ones(1,numRuns);%(rand(1,numRuns)-0.5)*2*pi;

% adjacency matrix of external system for actuator connection
externAdj = [ 1 0 ];

% parameters for external ode function [ mu, E0, k ]
extParams = [ 10, 0.5, 2*pi ];
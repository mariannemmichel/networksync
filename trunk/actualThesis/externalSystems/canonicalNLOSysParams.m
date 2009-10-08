
% number of internal states of external sytem
numExtStates = 2;

% initial value of theta
IC(N+1,:) = (rand(1,numRuns)-0.5)*2*pi;
% initial value of omega
IC(N+2,:) = (rand(1,numRuns)-0.5)*2*pi;

% parameters for external ode function [ mu, E0, k ]
extParams = [ 10, 0.5, 2*pi ];
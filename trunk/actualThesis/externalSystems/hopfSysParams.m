
% number of internal states of external sytem
numExtStates = 3;

% initial value of r
IC(N+1,:) = 1;
% initial value of phi
IC(N+2,:) = (rand(1,numRuns)-0.5)*2*pi;
% initial value of omega
IC(N+3,:) = (rand(1,numRuns)-0.5)*2*pi;

% parameters for external ode function [ mu, tau]
extParams = [ 0, 1 ];
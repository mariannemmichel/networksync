
% number of internal states of external sytem
numExtStates = 4;

% Lengths
L = 10e-2; % Rest Length of the body in meters
Lb = 6e-2; % Rest Length of the back leg in meters
Lf = Lb; % Rest Length of the fornt leg in meters

% Masses
totalMass = 280e-3; %Total mass in kg
balance=0.5; % Mass balance, 0.5 = masses are equal
mf = balance*totalMass; % Front mass
mb = (1-balance)*totalMass; % Back mass

% Spring Constants
K = 1e2; % Body spring in N/m
Kf = 6e1; % Front leg in N/m
Kb = 6e1; % Back leg in N/m

% Damping constants
Gf=1e0; % Front leg  in N s/m
Gb=1e0; % Back leg in N s/m 

% Force functions with gravity compensation
Ff = @(x,v) -Kf*(x-Lf - mf*9.81/Kf)-Gf*v;
Fb = @(x,v) -Kb*(x-Lb - mb*9.81/Kb)-Gb*v;
Fl = @(x,y) K*(1-L/sqrt((y-x)^2+L^2))*(y-x);

% initial value of vertical positions and velocities
ICext=[Lf;Lb;0; 0];
if exist('IC','var')
    IC((N+1):(N+numExtStates),:) = repmat(ICext,1,size(IC,2));
end

% parameters for external ode function [ mu, tau]
extParams = {Ff,Fb,Fl,mf,mb};
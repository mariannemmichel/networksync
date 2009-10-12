%% Test for the double mass hopper
% This file is used to study the behavior of the dynamical system defined
% in SpringMassHopper.m
% Things to try are (Modify the vlaues after the call to 
% SpringMassHopperParams)
% 
% * Front or Back Leg slightly compress,e.g. ICext(1)=Lf*1.1
% * Front or back leg with initial velocity, e.g. ICext(3)=0.4
% * The gains differt from zero, this forces system.
% 
% *NOTE:* To run this file you must uncomment lines 27 and 28 from
% SpringMassHopper.m
%%

clear all
SpringMassHopperParams;

% Legs slightly extended/compressed
%ICext(1)=Lf*1.1;
%ICext(2)=Lb*0.9;

tspan=[0 3];
opt = odeset('RelTol',1e-6,...
    'InitialStep',1e-4,'MaxStep',.05);

sig={@(t).5*sin(3*2*pi*t), @(t).1*sin(11*2*pi*t)};

[t,y] = ode113(@(t,y) SpringMassHopper(t,y,extParams,sig,[0 0]),...
    tspan,ICext,opt);

plot(t,y(:,[1 2]));
grid on
xlabel('Time [s]')
ylabel('Amplitude [m]')
legend('Front Leg','Hind Leg')

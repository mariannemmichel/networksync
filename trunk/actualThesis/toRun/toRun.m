
clear all
cd ..
pth=pwd;
cd toRun

% add folders containing helper functions to path
addpath(pth,[pth '\externalSystems\'],[pth '\plothelpers\'])

% load current parameters
ipHopfSensorGain

% run main procedure
mainProcedureToRun
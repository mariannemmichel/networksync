
clear all

% add folders containing helper functions to path
addpath('..')

% load current parameters
ipHopfSensorGain

% change dir & add paths
cd ..
addpath('./externalSystems/','./plothelpers/')

% run main procedure
mainProcedureToRun
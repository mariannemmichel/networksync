
% get community matrix
if exist('matrices.mat', 'file')
    load matrices.mat
else
    matrices
end

% community adjacency matrix
M = A;

% size of internal community
N = size(M,1);

% number of runs
numRuns = 1;

% add coupling factor
coupFac = 1;

% number of sensors connected
numSensors = 1;

% number of actuators connected
numActuators = 1;

% sensor gain
senGain = 0.1;

% connecting the external system: sensor adjacency
sensorAdj = senGain * [ 1 0 0 0 0 0 0 0 0 ]';

if size(sensorAdj,1) ~= N
    error('Sensor adjacency matrix does not have the right proportions!')
end

% sensor function
sensorFunc = @(x,t) x;

% time vector used for integration
tSpan = linspace(0,100,200)';

% threshold for DT: when are nodes in sync
thresh = 0.99;

% natural frequencies of community
%W = 0.1*ones(N,1); 
W = normrnd(0.1,1,N,1);

% initial conditions
if ~exist('IC','var')
    % initial phases of community
    IC = [-2.3 2.3315 0.3849 -3.1 4.9 2.5 -1.4911 -4 -3.6]'; 
    %IC = (rand(N,numRuns)*2-1)*2*pi;
end

% choose external system:
extSys = 'defSys';

goOn = 1;
switch extSys
    case 'defSys'
        extFun = @defSys;
        if exist('defSys.m', 'file')
            if exist('defSysParams.m', 'file')
                defSysParams
            else
                error('File specifying external system parameters not found. Exiting procedure.')
                goOn = 0;
            end
        else
            error('File specifying external system not found. Exiting procedure.')
            goOn = 0;
        end
end

% params to show in filename of result file
saveParams = ['runs' num2str(numRuns)];


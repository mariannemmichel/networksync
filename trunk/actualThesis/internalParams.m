
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

% standard deviation for distribution of W
sigmaW = linspace(0,1,11);%[ 0.1, 0.5, 1 ];
meanW = 0.1;

% natural frequencies of community
calcW = @(meanW,sigmaW,N) normrnd(meanW,sigmaW,N,1);
%calcW = @(meanW,sigmaW,N) 0.1*ones(N,1); 

if numel(meanW) == 1
    meanW = meanW * ones(1,numel(sigmaW));
elseif numel(sigmaW) ~= numel(meanW)
    error('Parameters for natural frequency distribution do not match. Exiting procedure.')
end

% initial conditions
if ~exist('IC','var')
    % initial phases of community
    IC = [-2.3 2.3315 0.3849 -3.1 4.9 2.5 -1.4911 -4 -3.6]'; 
    %IC = (rand(N,numRuns)*2-1)*2*pi;
end

% time vector used for integration
tSpan = linspace(0,100,200)';

% threshold for DT: when are nodes in sync
thresh = 0.99;

% choose external system:
extSys = 'defSys';

switch extSys
    case 'defSys'
        extFun = @defSys;
        if exist('defSys.m', 'file')
            if exist('defSysParams.m', 'file')
                defSysParams
            else
                error('File specifying external system parameters not found. Exiting procedure.')
            end
        else
            error('File specifying external system not found. Exiting procedure.')
        end
end

% sensor gain
senGain = 0.1;

% connecting the external system: sensor adjacency
sensorAdj = senGain * [ 1 0 0 0 0 0 0 0 0 ]';

if size(sensorAdj,1) ~= N
    error('Sensor adjacency matrix does not have the right proportions. Exiting procedure.')
end

% sensor function
sensorFunc = @(x,t) x;

% actuator gain
actGain = 0;

% connecting the external system: actuator adjacency
actuatorAdj = actGain * externAdj;

% actuator function
actuatorFunc = @(x,t) x(1);

if size(actuatorAdj,1) ~= numExtStates
    error('Actuator adjacency matrix does not have the right proportions!')
end

% params to show in filename of result file
saveParams = datestr(clock);
saveParams(saveParams == ':') = '-';
saveParams(saveParams == ' ') = '_';


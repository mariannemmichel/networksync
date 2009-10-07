
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
numRuns = 30;

% add coupling factor
coupFac = 1;

% standard deviation for distribution of W
sigmaW = 0.3;
meanW = 2;

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
    %IC = repmat([-2.3 2.3315 0.3849 -3.1 4.9 2.5 -1.4911 -4 -3.6]',1,numRuns); 
    IC = (rand(N,numRuns)*2-1)*2*pi;
end

% time vector used for integration
% Fs: sampling frequency
Fs = 2;
dt = 1/Fs;
tSpan = (0:dt:150)';

% threshold for DT: when are nodes in sync
thresh = 0.9;

% threshold for calculating tau: max deviation of slope of mean
threshTau = 1e-6;

% choose external system:
extSys = 'hopfSys';

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
    case 'hopfSys'
        extFun = @hopfSys;
        if exist('hopfSys.m', 'file')
            if exist('hopfSysParams.m', 'file')
                hopfSysParams
            else
                error('File specifying external system parameters not found. Exiting procedure.')
            end
        else
            error('File specifying external system not found. Exiting procedure.')
        end
    otherwise
        error('External system not found - Please check internal parameter file. Exiting procedure.')
end

% sensor gain
senGain = 3;

% connecting the external system: sensor adjacency
sensorAdj = [ 1 0 0 0 0 0 0 0 0 ]';

if size(sensorAdj,1) ~= N
    error('Sensor adjacency matrix does not have the right proportions. Exiting procedure.')
end

% sensor function
sensorFunc = @(x,t) sin(x(1));

% actuator gain
actGain = (0:0.5:10);

% connecting the external system: actuator adjacency
%actuatorAdj = actGain * externAdj;

% actuator function
actuatorFunc = @(x,t) x(1);

if size(externAdj,2) ~= numExtStates
    error('Actuator adjacency matrix does not have the right proportions!')
end

% params to show in filename of result file
saveParams = datestr(clock);
saveParams(saveParams == ':') = '-';
saveParams(saveParams == ' ') = '_';


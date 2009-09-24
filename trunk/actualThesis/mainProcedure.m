
clear

if exist('internalParams.m', 'file')
    internalParams
else
    error('Parameter file not found. Exiting procedure.')
end

% add coupling factor
M = coupFac * M;

% measure time vector
tSize = size(tSpan,1);

% create solution vectors
T = zeros(numRuns,1);
Y = cell(1,numRuns);
numSigma = numel(sigmaW);
numSgain = numel(senGain);%!!!
C = cell(1,numSgain);%!!!

% param{1}(1) = number of community nodes
% param{1}(2) = dimension of external system
% param{2} = adjacency matrix of the whole network
% param{3} = natural frequencies of community nodes
% param{4} = function handle to external system ode
% param{5}{1} = nodes in community with sensors
% param{5}{2} = handle to sensor function
% param{5}{3} = internal states of external system connected to actuator
% param{5}{4} = handle to actuator function
% param{6} = parameters for the external ode function
param{1} = [N numExtStates];
param{2} = M;
param{3} = zeros(N,1);
param{4} = extFun;
%param{5} = {sensorAdj, sensorFunc, actuatorAdj, actuatorFunc};
param{6} = extParams;

opt = odeset('RelTol',1e-6);

for ss=1:numSigma
    for sg=1:numSgain
        sg
        sensorAdj = senGain(sg) * sensorAdj;
        param{5} = {sensorAdj, sensorFunc, actuatorAdj, actuatorFunc};
        for i=1:numRuns
            % calculate natural frequencies
            param{3} = calcW(meanW(ss),sigmaW(ss),N);
            
            % ode
            [T,Y{i}] = ode113(@(t,y) sync(t,y,param),tSpan,IC(:,i),opt);
        end

        % calculate corellation
        CORavg = zeros(N,N,tSize);
        for i=1:numRuns
            COR = zeros(N,N,tSize);
            for t=1:tSize
                r = repmat(Y{i}(t,1:N),N,1);
                COR(:,:,t) = cos(r'-r);
            end
            CORavg = CORavg + COR;
        end
        C{sg} = CORavg / numRuns;

    end
end

% plot results
%syncPlotSgain(T,Y,N,C,thresh,threshTau,senGain,'rhoinf','tau','rho','trajec');


% save results
save(['results/' saveParams '.mat'])



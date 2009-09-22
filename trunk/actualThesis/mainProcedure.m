
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
numS = numel(sigmaW);
C = cell(1,numS);
rhoN = cell(1,numS);
rhoC = cell(1,numS);
rhoInf = zeros(numS);
tauC = zeros(numS);


% param{1}(1) = number of community nodes
% param{1}(2) = dimension of external system
% param{2} = adjacency matrix of the whole network
% param{3} = natural frequencies of community nodes
% param{4} = function handle to external system ode
% param{5}{1} = nodes in community with sensors
% param{5}{2} = handle to sensor function
% param{5}{3} = internal states of external system connected to actuator
% param{5}{4} = handle to actuator function
param{1} = [N numExtStates];
param{2} = M;
param{3} = zeros(N,1);
param{4} = extFun;
param{5} = {sensorAdj, sensorFunc, actuatorAdj, actuatorFunc};

opt = odeset('RelTol',1e-6);

for s=1:numS

    for i=1:numRuns
        % calculate natural frequencies
        param{3} = calcW(meanW(s),sigmaW(s),N);
        
        %ode
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
    C{s} = CORavg / numRuns;
    
    % sync state of every node over time
    rhoN{s} = squeeze(mean(C{s},1))';
    % sync state of community over time
    rhoC{s} = mean(rhoN{s},2);
    % steady state sync value of community
    rhoInf(s) = mean(rhoC{s}(end-20:end));
    tauC(s) = T(find(rhoC{s} > (thresh*rhoInf(s)),1,'first'));

end

% plot results
%f = syncPlot();
% rhoInf
plot(sigmaW,rhoInf,'.')
% sync state over time
plot(T,rhoC{1})

% save results
save(['results/' saveParams '.mat'])



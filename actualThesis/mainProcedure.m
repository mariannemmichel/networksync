
clear

if exist('internalParams.m', 'file')
    internalParams
else
    error('Parameter file not found. Exiting procedure.')
    return
end

if ~goOn
    error('File specifying external system not found. Exiting procedure.')
    return
end

% add coupling factor
M = coupFac * M;

% measure time vector
tSize = size(tSpan,1);

% create solution vectors
T = cell(1,numRuns);
Y = cell(1,numRuns);


%%% ode %%%

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
param{3} = W;
param{4} = extFun;
param{5} = {sensorAdj, sensorFunc, actuatorAdj, actuatorFunc};

for i=1:numRuns
    [T{i},Y{i}] = sync(IC(:,i),param,tSpan);
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
CORavg = CORavg / numRuns;

% dynamic connectivity matrix
DT = gt(CORavg,thresh);

% pairwise sync time
syncTime = zeros(N,N);
for i=1:N
    for j=i+1:N
        t=tSize;
        while (DT(i,j,t) && t>1)
            t = t-1;
        end
        syncTime(i,j) = T{1}(t);
    end
end
syncTime = squareform(syncTime + syncTime');

% plot results
%f = syncPlot();

% save results
save(['results/' saveParams '.mat'])



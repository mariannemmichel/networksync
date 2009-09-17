
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

% add sensor gain
M(:,N+1)= senGain * M(:,N+1);

% add actuator gain
M(N+1,:)= actGain * M(N+1,:);

% measure time vector
tSize = size(tSpan,1);

% create solution vectors
T = cell(1,numRuns);
Y = cell(1,numRuns);


%%% ode %%%

% param{1}(1) = number of community nodes
% param{1}(2) = dimension of external system
% param{1}(3) = number of sensors connected
% param{1}(4) = number of actuators connected
% param{2} = adjacency matrix of community
% param{3} = natural frequencies of community nodes
% param{4} = function handle to external system ode
param{1} = [N numExtStates numSensors numActuators];
param{2} = M;
param{3} = W;
param{4} = extFun;

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

% save results
save(['results/' saveParams '.mat'])



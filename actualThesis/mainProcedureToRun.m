
% add coupling factor
M = coupFac * M;

% measure time vector
tSize = size(tSpan,1);

% param{1}(1) = number of community nodes
% param{1}(2) = dimension of external system
% param{2} = adjacency matrix of the internal network (community)
% param{3} = natural frequencies of community nodes
% param{4} = function handle to external system ode
% param{5}(1) = adjacency matrix: sensor connection
% param{5}(2) = handle to sensor function
% param{5}(3) = handle to actuator function
% param{5}(4) = actuator gain
% param{6} = parameters for the external system
param = cell(6,1);
param{1} = [N numExtStates];
param{2} = M;
param{3} = zeros(N,1);
param{4} = extFun;
param{5} = cell(1,4);
param{6} = extParams;

% create data matrices
T = zeros(numRuns,1);
numSigma = numel(sigmaW);
numSgain = numel(senGain);
numAgain = numel(actGain);

increm = [];
dispIncrem = '';
numIncrem = 0;
if numSigma>1
    dispIncrem = 'Sigma';
    increm = sigmaW;
    numIncrem = numSigma;
elseif numSgain>1
    dispIncrem = 'Sensor Gain';
    increm = senGain;
    numIncrem = numSgain;
    meanW = meanW * ones(1,numIncrem);
    sigmaW = sigmaW * ones(1,numIncrem);
elseif numAgain>1
    dispIncrem = 'Actuator Gain';
    increm = actGain;
    numIncrem = numAgain;
    meanW = meanW * ones(1,numIncrem);
    sigmaW = sigmaW * ones(1,numIncrem);
else
    dispIncrem = 'Actuator Gain';
    increm = actGain;
    numIncrem = numAgain;
end
    
C = cell(1,numIncrem);
Y = cell(numIncrem,numRuns);
            
opt = odeset('RelTol',1e-6,'InitialStep',1e-4,'MaxStep',.05);

for s=1:numIncrem
    
    display(['Running ODE for ' dispIncrem ' = ' num2str(increm(s)) ':'])
   
    if strcmp(dispIncrem,'Sensor Gain')
        senAdj = senGain(s) * sensorAdj;
        aG = actGain(1);
    elseif strcmp(dispIncrem,'Actuator Gain')
        senAdj = senGain(1) * sensorAdj;
        aG = actGain(s);
    else
        senAdj = senGain(1) * sensorAdj;
        aG = actGain(1);
    end
    param{5} = {senAdj, sensorFunc, actuatorFunc, aG};
    
    for i=1:numRuns
        
        display([ num2str(i) '. Run...'])
        
        % calculate natural frequencies
        param{3} = calcW(meanW(s),sigmaW(s),N);
        param{3}(1) = meanW(1); % hub gets no noise 

        % ode
        [T,Y{s,i}] = ode113(@(t,y) sync(t,y,param),tSpan,IC(:,i),opt);
    end

    % calculate corellation
    CORavg = zeros(N,N,tSize);
    for i=1:numRuns
        COR = zeros(N,N,tSize);
        for t=1:tSize
            r = repmat(Y{s,i}(t,1:N),N,1);
            COR(:,:,t) = cos(r'-r);
        end
        CORavg = CORavg + COR;
    end
    C{s} = CORavg / numRuns;

end


% save results
save(['results/' saveParams '.mat'])



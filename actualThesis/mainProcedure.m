
clear
load matrices.mat

%%%%%%%%%%%%%%
netType = 'A';
%%%%%%%%%%%%%%

% number of runs
numRuns = 1;

% network adjacency matrix
if (netType == 'A')
    M = A;
end
N = size(M,1)-1;

% coupling factor
coupFac = 1;
M = coupFac * M;

% Sensor gain
M(:,N+1)= 0.5 * M(:,N+1);

% Actuator gain
M(N+1,:)=0.0 * M(N+1,:);

% tSpan
if (netType == 'A')
    tSpan = linspace(0,100,200)';
end
tsize = size(tSpan,1);

% threshold for DT
thresh = 0.99;

% natural frequencies of community
W = 0.1*ones(N,1);
%W = normrnd(0,0.04,N,1);

T = cell(1,numRuns);
Y = cell(1,numRuns);

%%% ode %%%
% initial phases of community
ic = [-2.3 2.3315 0.3849 -3.1 4.9 2.5 -1.4911  -4 -3.6]';%(rand(N,numRuns)*2-1)*2*pi;
% initial value of the sensor
ic(N+1,:) = pi+zeros(1,numRuns);

% initial phase of external node
ic(N+2,:) = pi+zeros(1,numRuns);

% initial phase of actuator
ic(N+3,:) = sin(-2.3)*ones(1,numRuns);


for i=1:numRuns
    IC=ic(:,i);
    [T{i},Y{i}] = sync(IC,M,W,tSpan);
end

% corellation
CORavg = zeros(N,N,tsize);
for z=1:numRuns
    COR = zeros(N,N,tsize);
    for t=1:tsize
                r = repmat(Y{z}(t,1:N),N,1);
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
        t=tsize;
        while (DT(i,j,t) && t>1)
            t = t-1;
        end
        syncTime(i,j) = T{1}(t);
    end
end
syncTime = squareform(syncTime + syncTime');

% dendrogram
% Z = linkage(syncTime,'average');
% figure('Name',['Network ' netType ' - Trajectories of first run'],'NumberTitle','off')
% plot(T{1},sin(Y{1}))
% xlabel('Time --->')
% ylabel('sin(Phases)')
% set(gca,'YLim',[-1 1])
% set(gca,'YTick',(-1:1:1))
% %set(gca,'YTickLabel',{'0','pi','2pi'})
% figure('Name',['Network ' netType ' - Dendrogram, average over ' num2str(numRuns) 'runs'],'NumberTitle','off')
% dendrogram(Z,0);
% xlabel('Nodes')
% ylabel('Time --->')
% %imagesc(squareform(syncTime));
% 
% save(['res' netType num2str(numRuns) '.mat'])

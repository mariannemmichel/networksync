
clear
load matrices.mat

%%%%%%%%%%%%%%
netType = 'A';
%%%%%%%%%%%%%%

% number of runs
numRuns = 5;

% network adjacency matrix
if (netType == 'A')
    M = A;
end
N = size(M,1)-1;

% coupling factor
coupFac = 1;
M = coupFac * M;

% tSpan
if (netType == 'A')
    tSpan = (0:0.1:500)';
end
tsize = size(tSpan,1);

% threshold for DT
thresh = 0.99;

% natural frequencies of community
W = 0.1*ones(N,1);
%W = normrnd(0,0.04,N,1);
    
% natural frequency of external node
W(N+1,1) = 1;

T = cell(1,numRuns);
Y = cell(1,numRuns);

%%% ode %%%
for i=1:numRuns
    
    % initial phases of community
    ic = (rand(N,1)*2-1)*2*pi;
    
    % initial phase of external node
    ic(N+1,1) = (rand(1)*2-1)*2*pi;

    [T{i},Y{i}] = sync(ic,M,W,tSpan);
end

% corellation
CORavg = zeros(N,N,tsize);
for z=1:numRuns
    COR = zeros(N,N,tsize);
    for t=1:tsize
                r = repmat(Y{z}(t,:),N,1);
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
Z = linkage(syncTime,'average');
figure('Name',['Network ' netType ' - Trajectories of first run'],'NumberTitle','off')
plot(T{1},sin(Y{1}))
xlabel('Time --->')
ylabel('sin(Phases)')
set(gca,'YLim',[-1 1])
set(gca,'YTick',(-1:1:1))
%set(gca,'YTickLabel',{'0','pi','2pi'})
figure('Name',['Network ' netType ' - Dendrogram, average over ' num2str(numRuns) 'runs'],'NumberTitle','off')
dendrogram(Z,0);
xlabel('Nodes')
ylabel('Time --->')
%imagesc(squareform(syncTime));

save(['res' netType num2str(numRuns) '.mat'])

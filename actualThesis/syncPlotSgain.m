
function syncPlotSgain(T,Y,N,C,thresh,threshTau,senGain,varargin)
    
    optargin = size(varargin,2);
    stdargin = nargin - optargin;
    
    numS = size(C,2);
    L = size(T,1);
    rhoN = cell(1,numS);
    rhoC = cell(1,numS);
    rhoInf = zeros(1,numS);
    tauC = zeros(1,numS);
    tauWindow = cell(1,numS);
    syncTime = cell(1,numS);
    %stDevValue = zeros(1,numS);
    % moving window (half of it)
    win = round(L*0.1/2);
    
        
    for s=1:numS
        % sync state of every node over time
        rhoN{s} = squeeze(mean(C{s},1))';
        % sync state of community over time
        rhoC{s} = mean(rhoN{s},2);
        
        % steady state sync value of community
        rhoInf(s) = mean(rhoC{s}(end-2*win:end));
        %stDev = ones(L,1);
        slope = ones(L,1);
        dummy = zeros(L,2);
        for ti=win:L-win
            %stDev(ti)=std(rhoC{s}(ti-win+1:ti+win),1);
            dummy(ti,:) = polyfit(T(ti-win+1:ti+win),rhoC{s}(ti-win+1:ti+win),1);
            slope(ti) = dummy(ti,1);
        end   
        %tauWindow{s} = find(stDev < threshTau,1,'first');
        tauWindow{s} = find(slope < threshTau,1,'first');
        if isempty(tauWindow{s})
            tauC(s) = L;
            %stDevValue(s) = -1;
        else
            tauC(s) = tauWindow{s};
            tauWindow{s} = (tauWindow{s}-win+1:tauWindow{s}+win);
            %stDevValue(s) = stDev(tauC(s));
        end
        
        % dynamic connectivity matrix
        thresh = thresh*rhoC{s}(tauC(s));
        DT = gt(C{s},thresh);
        % pairwise sync time
        syncTime{s} = zeros(N,N);
        for i=1:N
            for j=i+1:N
                t = L;
                while (DT(i,j,t) && t>1)
                    t = t-1;
                end
                syncTime{s}(i,j) = T(t);
            end
        end
        syncTime{s} = squareform(syncTime{s} + syncTime{s}');
    end
    
    doDendro = 0;
    doState = 0;
    doRhoinf = 0;  
    doTau = 0;
    doTrajec = 0;
    doTimesquares = 0;
    doRho = 0;
    for i=1:optargin
        switch varargin{i}
            case 'dendro'
                doDendro = 1;
            case 'syncstate'
                doState = 1;
            case 'rhoinf'
                doRhoinf = 1;
            case 'tau'
                doTau = 1;
            case 'rho'
                doRho = 1;
            case 'trajec'
                doTrajec = 1;
            case 'timesquares'
                doTimesquares = 1;
        end
    end
    
    if doRhoinf
        figure('Name','RhoInf','NumberTitle','off')
        rhoinfPlot(senGain,rhoInf)
    end
    
    if doTau
        figure('Name','Tau','NumberTitle','off')
        tauPlot(senGain,T(tauC),L)
    end
    
    if doRho
        figure('Name','Rho over time','NumberTitle','off')
        for s=1:numS
            clf
            rhoPlot(T,rhoC{s},tauWindow{s},tauC(s))
            title(['Rho for senGain = ' num2str(senGain(s))])
            pause
        end
    end
    
    if doDendro
        figure('Name','Dendrograms','NumberTitle','off')
        for s=1:numS
            clf
            dendroPlot(syncTime{s})
            title(['Dendrogram for senGain = ' num2str(senGain(s))])
            pause
        end
    end
    
    if doState
        figure('Name','Syncstate','NumberTitle','off')
        for s=1:numS
            clf
            syncstatePlot(T,rhoN{s})
            title(['States of synchronization for senGain = ' num2str(senGain(s))])
            pause
        end
    end
    
    if doTimesquares
        figure('Name','Syncstate','NumberTitle','off')
        for s=1:numS
            clf
            timesquaresPlot(syncTime{s})
            title(['Sync time of nodes for senGain = ' num2str(senGain(s))])
            pause
        end
    end
    
    if doTrajec
        figure('Name','Trajectories of last run','NumberTitle','off')
        for s=1:numS
            clf
            trajecPlot(T,Y{s}(:,1:N))
            title(['Trajectories of nodes for senGain = ' num2str(senGain(s))])
            pause
        end
    end
    
end



function dendroPlot(syncTime)
   
    Z = linkage(syncTime,'average');
    dendrogram(Z,0);
    xlabel('Nodes')
    ylabel('Time --->')
    if max(syncTime) < 5
        l=5;
    elseif max(syncTime) < 50
        l=50;
    elseif max(syncTime) < 100
        l=100;
    elseif max(syncTime) < 150
        l=150;
    else
        l=200;
    end
    set(gca,'YLim',[0 l])
    
end

function timesquaresPlot(syncTime)

    imagesc(squareform(syncTime));
    colormap(hot)
    
end

function syncstatePlot(T,rhoN)
    plot(T,rhoN)
    set(gca,'YLim',[0 1])
    set(gca,'XLim',[0 100])
    xlabel('Time --->')
    ylabel('rho (quality of sync)')
end

function rhoinfPlot(senGain,rhoInf)
    hold on
    plot(senGain,rhoInf,'.')
    %plot(sigmaW,(1.1 - 0.7/2*sigmaW),'r-')
    hold off
    xlabel('Sensor Gain')
    ylabel('rho inf')
    set(gca,'YLim',[0.4 1])
end

function tauPlot(senGain,tauC,L)
    plot(senGain,tauC,'.')
    xlabel('Sensor Gain')
    ylabel('\tau')
    if tauC < 20
        l=20;
    else
        l=L;
    end
    set(gca,'YLim',[0 l])
end

function trajecPlot(T,Y)
    hold on
    plot(T,sin(Y(:,2:end)),'b-')
    plot(T,sin(Y(:,1)),'r-')
    hold off
    xlabel('Time --->')
    ylabel('sin(Phases)')
    set(gca,'YLim',[-1 1])
    set(gca,'YTick',(-1:1:1))
    set(gca,'XLim',[0 100])
end

function rhoPlot(T,rhoC,tauWindow,tau)

    if isempty(tauWindow)
        plot(T,rhoC)
        set(gca,'YLim',[0 1])
    else
        hold on
        plot(T,rhoC,'-b',T(tauWindow),rhoC(tauWindow),'xg')
        plot(T(tau),rhoC(tau),'ro')
        set(gca,'YLim',[0 1])
        set(gca,'XLim',[0 100])
        hold off
    end
    xlabel('Time --->')
    ylabel('rho (quality of sync)')
end


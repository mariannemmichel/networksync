
function syncPlot(T,Y,N,C,thresh,threshTau,sigmaW,varargin)
    
    optargin = size(varargin,2);
    stdargin = nargin - optargin;
    
    numS = size(C,2);
    rhoN = cell(1,numS);
    rhoC = cell(1,numS);
    rhoInf = zeros(1,numS);
    tauC = zeros(1,numS);
    tauWindow = cell(1,numS);
    syncTime = cell(1,numS);
    stDevValue = zeros(1,numS);
    
        
    for s=1:numS
        % sync state of every node over time
        rhoN{s} = squeeze(mean(C{s},1))';
        % sync state of community over time
        rhoC{s} = mean(rhoN{s},2);
        % steady state sync value of community
        win = round(length(rhoC{s})*.1/2);
        rhoInf(s) = mean(rhoC{s}(end-2*win:end));
        stDev = ones(length(rhoC{s}),1);
        slope = ones(length(rhoC{s}),1);
        for ti=win:length(rhoC{s})-win
            %stDev(ti)=std(rhoC{s}(ti-win+1:ti+win),1);
            dummy(ti,:) = polyfit(T(ti-win+1:ti+win),rhoC{s}(ti-win+1:ti+win),1);
            slope(ti) = dummy(ti,1);
        end   
        %tauWindow{s} = find(stDev < threshTau,1,'first');
        tauWindow{s} = find(slope < threshTau,1,'first');
        if isempty(tauWindow{s})
            tauC(s) = length(T);
            stDevValue(s) = -1;
        else
            tauC(s) = tauWindow{s};
            tauWindow{s} = (tauWindow{s}-win+1:tauWindow{s}+win);
            stDevValue(s) = stDev(tauC(s));
        end
        
        %tauC(s) = T(find(rhoC{s} > (thresh*rhoInf(s)),1,'first'));
        % dynamic connectivity matrix
        DT = gt(C{s},thresh);
        % pairwise sync time
        syncTime{s} = zeros(N,N);
        for i=1:N
            for j=i+1:N
                t = size(T,1);
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
    doStd = 0;
    numSubs = 0;
    for i=1:optargin
        switch varargin{i}
            case 'dendro'
                doDendro = 1;
                numSubs = numSubs+1;
            case 'syncstate'
                doState = 1;
                numSubs = numSubs+1;
            case 'rhoinf'
                doRhoinf = 1;
            case 'tau'
                doTau = 1;
            case 'rho'
                doRho = 1;
            case 'std'
                doStd = 1;
            case 'trajec'
                doTrajec = 1;
                numSubs = numSubs+1;
            case 'timesquares'
                doTimesquares = 1;
                numSubs = numSubs+1;
        end
    end
    
    if doRhoinf
        figure('Name','RhoInf','NumberTitle','off')
        rhoinfPlot(sigmaW,rhoInf)
    end
    
    if doTau
        figure('Name','Tau','NumberTitle','off')
        tauPlot(sigmaW,T(tauC))
    end
    
    if doStd
        figure('Name','Std','NumberTitle','off')
        stdPlot(sigmaW,stDevValue)
    end
    
    if doRho
        figure('Name','Rho over time','NumberTitle','off')
        for s=1:numS
            clf
            rhoPlot(T,rhoC{s},tauWindow{s},tauC(s))
            title(['Rho for sigma = ' num2str(sigmaW(s))])
            pause
        end
    end
    
   
    
%     if numSubs>0
%         figure('Name','Sigma Plots','NumberTitle','off')
%         nSubs = numSubs;
%         if doDendro && nSubs>0
%             for s=1:numS
%                 subplot(numS,numSubs,(s-1)*numSubs+nSubs)
%                 dendroPlot(syncTime{s})
%             end
%             nSubs = nSubs-1;
%         elseif doState && nSubs>0
%             for s=1:numS
%                 subplot(numS,numSubs,(s-1)*numSubs+nSubs)
%                 syncstatePlot(T,rhoC)
%             end
%             nSubs = nSubs-1;
%         elseif doTrajec && nSubs>0
%             for s=1:numS
%                 subplot(numS,numSubs,(s-1)*numSubs+nSubs)
%                 trajecPlot(T,Y)
%             end
%             nSubs = nSubs-1;
%         elseif doTimesquares && nSubs>0
%             for s=1:numS
%                 subplot(numS,numSubs,(s-1)*numSubs+nSubs)
%                 timesquaresPlot(syncTime{s})
%             end
%             nSubs = nSubs-1;
%         end
%     end
    
    
end



function dendroPlot(syncTime)
   
    Z = linkage(syncTime,'average');
    dendrogram(Z,0);
    xlabel('Nodes')
    ylabel('Time --->')
    
end

function timesquaresPlot(syncTime)

    imagesc(squareform(syncTime));
    
end

function syncstatePlot(T,rhoC)
    plot(T,rhoC{1})
end

function rhoinfPlot(sigmaW,rhoInf)
    plot(sigmaW,rhoInf,'.')
end

function tauPlot(sigmaW,tauC)
    plot(sigmaW,tauC,'.')
end

function stdPlot(sigmaW,stdev)
    plot(sigmaW,stdev,'.')
end

function trajecPlot(T,Y)

    plot(T,sin(Y))
    xlabel('Time --->')
    ylabel('sin(Phases)')
    set(gca,'YLim',[-1 1])
    set(gca,'YTick',(-1:1:1))

end

function rhoPlot(T,rhoC,tauWindow,tauC)

    if isempty(tauWindow)
        plot(T,rhoC)
    else
        hold on
        plot(T,rhoC,'-b',T(tauWindow),rhoC(tauWindow),'xg')
        plot(T(tauC),rhoC(tauC),'ro')
        hold off
    end

end






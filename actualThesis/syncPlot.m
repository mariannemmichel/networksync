
function f = syncPlot()

end

function f = dendroPlot()

    Z = linkage(syncTime,'average');
    figure('Name',['Network ' netType ' - Trajectories of first run'],'NumberTitle','off')
    plot(T{1},sin(Y{1}))
    xlabel('Time --->')
    ylabel('sin(Phases)')
    set(gca,'YLim',[-1 1])
    set(gca,'YTick',(-1:1:1))

end

function f = trajecPlot()
   
    figure('Name',['Network ' netType ' - Dendrogram, average over ' num2str(numRuns) 'runs'],'NumberTitle','off')
    dendrogram(Z,0);
    xlabel('Nodes')
    ylabel('Time --->')
    
end

function f = timePlot()

    imagesc(squareform(syncTime));
    
end

function
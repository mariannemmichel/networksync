 function spDendro(syncTime,tellS,incrS)
    
    numS = size(syncTime,2);
    figure('Name','Dendrograms','NumberTitle','off')
    for s=1:numS
        clf
        Z = linkage(syncTime{s},'average');
        dendrogram(Z,0);
        title(['Community Dendrogram for ' tellS '  = ' num2str(incrS(s))])
        xlabel('Nodes')
        ylabel('Time --->')
        l = ceil(max(syncTime{s})*1.05);
        set(gca,'YLim',[0 l])
        pause
    end
 end
      
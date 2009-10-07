
function spRhon(T,N,rhoN,tellS,incrS)

    numS = size(rhoN,2);
    figure('Name','Synchronization State of Nodes over Time','NumberTitle','off')
    for s=1:numS
        clf
        
        plot(T,rhoN{s}(:,1),'r',T,rhoN{s}(:,2:N),'b')
        set(gca,'YLim',[0 1])
        set(gca,'XLim',[0 50])
        title(['Sync States for  ' tellS '  = ' num2str(incrS(s))])
        legend('Hub', 'Nodes')
        xlabel('Time t')
        ylabel('Rho \rho (quality of sync)')
        
        pause
    end
end

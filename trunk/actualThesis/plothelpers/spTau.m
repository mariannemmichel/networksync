
function spTau(T,tauC,incrS,tellS)

    figure('Name','Time to reach Steady State of Synchronization','NumberTitle','off')
    plot(incrS,T(tauC),'.')
    title('Time to reach Steady State of Synchronization')
    xlabel(tellS)
    ylabel('Tau \tau')
    if tauC < 50
        l=50;
    else
        l=T(end);
    end
    set(gca,'YLim',[0 l])
end
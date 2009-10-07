
function spRho(T,rhoC,tauWindow,tauC,tellS,incrS)

    numS = size(rhoC,2);
    figure('Name','Synchronization Quality Measurement','NumberTitle','off')
    for s=1:numS
        clf
        
        if isempty(tauWindow{s})
            plot(T,rhoC{s})
            set(gca,'YLim',[0 1])
        else
            hold on
            plot(T,rhoC{s},'-b',T(tauWindow{s}),rhoC{s}(tauWindow{s}),'xg')
            plot(T(tauC(s)),rhoC{s}(tauC(s)),'ro')
            hold off
            set(gca,'YLim',[0 1])
        end
        title(['Rho \rho for  ' tellS '  = ' num2str(incrS(s))])
        legend('Rho \rho', 'Moving Window', ['Tau \tau :   ' num2str(T(tauC(s))) ' sec'])
        xlabel('Time t')
        ylabel('Rho \rho (quality of sync)')
        
        pause
    end
end
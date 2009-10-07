
function spRhoinf(rhoInf,incrS,tellS)
    
    figure('Name','Synchronization Quality at Steady State','NumberTitle','off')
    temp = polyfit(incrS,rhoInf,1);
    fit = temp(2)+temp(1)*incrS;
    plot(incrS,fit,'r-',incrS,rhoInf,'.')
    set(gca,'YLim',[0 1])
    legend(['y = ' num2str(temp(2)) ' + ' num2str(temp(1)) ' * x'])
    title('Synchronization Quality at Steady State')
    xlabel(tellS)
    ylabel('Rho inf')

end
    
function spFreq(ssFreqs,tellS,incrS,extFreq)
    
    figure('Name','Steady State Frequencies','NumberTitle','off')
    labels = cellstr(num2str(incrS'));
    hold on
    boxplot(ssFreqs','labels',labels)
    plot(2*ones(size(incrS)),'bx')
    plot(extFreq,'go')
    a=axis();
    axis([a(1:2) 0 4])
    hold off
    title('Steady State Frequencies')
    xlabel(tellS)
    ylabel('Frequency (Hz)')
 end
        


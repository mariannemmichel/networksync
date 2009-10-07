    
function spFreq(ssFreqs,tellS,incrS)
    
    figure('Name','Steady State Frequencies','NumberTitle','off')
    labels = cellstr(num2str(incrS'));
    hold on
    boxplot(ssFreqs','labels',labels)
    plot(incrS,1/pi)
    hold off
    title('Steady State Frequencies')
    xlabel(tellS)
    ylabel('Frequency (Hz)')
 end
        


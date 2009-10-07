    
function spSquares(syncTime,tellS,incrS)
    
    numS = size(syncTime,2);
    figure('Name','Time to Sync','NumberTitle','off')
    for s=1:numS
        clf
        imagesc(squareform(syncTime{s}));
        colormap(hot)
        title(['Time to Sync for ' tellS '  = ' num2str(incrS(s))])
        pause
    end
 end
        

    
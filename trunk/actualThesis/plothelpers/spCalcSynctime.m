
function syncTime = spCalcSynctime(T,C,N,rhoC,tauC,thresh)

    numS = size(C,2);
    syncTime = cell(1,numS);
    L = size(T,1);
    
    for s=1:numS
        
        % dynamic connectivity matrix
        thresh = thresh*rhoC{s}(tauC(s));
        DT = gt(C{s},thresh);
        % pairwise sync time
        syncTime{s} = zeros(N,N);
        for i=1:N
            for j=i+1:N
                t = find(DT(i,j,:),3,'first');
                syncTime{s}(i,j) = T(t(3));
            end
        end
        syncTime{s} = squareform(syncTime{s} + syncTime{s}');
    end
end
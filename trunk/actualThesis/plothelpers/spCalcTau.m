
function [L,rhoN,rhoC,rhoInf,tauC,tauWindow] = spCalcTau(T,C,threshTau)

    L = size(T,1);
    numS = size(C,2);
    rhoN = cell(1,numS);
    rhoC = cell(1,numS);
    rhoInf = zeros(1,numS);
    tauC = zeros(1,numS);
    tauWindow = cell(1,numS);

    % moving window (half of it)
    win = round(L*0.1/2);
    
    for s=1:numS
        % sync state of every node over time
        rhoN{s} = squeeze(mean(C{s},1))';
        % sync state of community over time
        rhoC{s} = mean(rhoN{s},2); 
        % steady state sync value of community
        rhoInf(s) = mean(rhoC{s}(end-2*win:end));

        slope = ones(L,1);
        dummy = zeros(L,2);
        for ti=win:L-win
            dummy(ti,:) = polyfit(T(ti-win+1:ti+win),rhoC{s}(ti-win+1:ti+win),1);
            slope(ti) = dummy(ti,1);
        end   
        tauWindow{s} = find(slope < threshTau,1,'first');
        if isempty(tauWindow{s})
            tauC(s) = L;
        else
            tauC(s) = tauWindow{s};
            tauWindow{s} = (tauWindow{s}-win+1:tauWindow{s}+win);
        end
    end
end
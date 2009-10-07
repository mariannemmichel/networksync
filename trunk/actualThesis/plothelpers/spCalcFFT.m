
function [X,f,m,mind,ssFreqs] = spCalcFFT(Y,Fs,tauC)

    numS = size(Y,1);
    numRuns = size(Y,2);
    X = cell(1,numS);
    f = cell(1,numS);
    m = zeros(numS);
    mind = zeros(numS);
    ssFreqs = zeros(numS,numRuns);
    
    for s=1:numS
        x = Y{s,1}(tauC(s):end,1);
        L = size(x,1);
        NFFT = 2^nextpow2(L);
        X{s} = fft(sin(x),NFFT)/L;
        X{s} = 2*abs(X{s}(1:NFFT/2+1));
        [m(s),mind(s)] = max(X{s});
        if numel(m(s)) > 1
            warning(1,'Warning: More than one dominant frequency at steady state.')
        end
        f{s} = Fs/2*linspace(0,1,NFFT/2+1);
        ssFreqs(s,1) = f{s}(mind(s));
        for i=1:numRuns-1
            x = Y{s,i}(tauC(s):end,1);
            XX = fft(sin(x),NFFT)/L;
            XX = 2*abs(XX(1:NFFT/2+1));
            [M,MI] = max(XX);
            if numel(M) > 1
                warning(1,'Warning: More than one dominant frequency at steady state.')
            end
            ssFreqs(s,i) = f{s}(MI);
        end
    end
end
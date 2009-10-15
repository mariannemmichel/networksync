
function syncPlot(varargin)
    
% e.g. call:
% syncPlot('T',T,'Y',Y,'N',N,'C',C,'Fs',Fs,'thresh',thresh,...
%    'threshTau',threshTau,{sigmaW OR senGain OR actGain},...
%    'rhoinf','tau','rho','rhon','trajec','fft','dendro','timesquares')

    T = NaN;
    Y = NaN;
    N = NaN;
    C = NaN;
    Fs = NaN;
    thresh = NaN;
    threshTau = NaN;
    actGain = NaN;
    senGain = NaN;
    sigmaW = NaN;
    Yindext = NaN;
    
    tellS = NaN;
    incrS = NaN;

    rhoN = NaN;
    rhoC = NaN;
    rhoInf = NaN;
    tauWindow = NaN;
    tauC = NaN;
    syncTime = NaN;
    ssFreqs = NaN;
    
    i=1;
    while i<=nargin
        switch varargin{i}
            case 'T'
                T = varargin{i+1};
                i = i+1;
            case 'Y'
                Y = varargin{i+1};
                i = i+1;
            case 'N'
                N = varargin{i+1};
                i = i+1;
            case 'C'
                C = varargin{i+1};
                i = i+1;
            case 'Fs'
                Fs = varargin{i+1};
                i = i+1;
            case 'Yindext'
                Yindext = varargin{i+1};
                i = i+1;
            case 'thresh'
                thresh = varargin{i+1};
                i = i+1;
            case 'threshTau'
                threshTau = varargin{i+1};
                i = i+1;
            case 'actGain'
                actGain = varargin{i+1};
                i = i+1;
                tellS = 'Actuator Gain';
                incrS = actGain;
            case 'senGain'
                senGain = varargin{i+1};
                tellS = 'Sensor Gain';
                incrS = senGain;
                i = i+1;
            case 'sigmaW'
                sigmaW = varargin{i+1};
                tellS = 'Sigma \sigma';
                incrS = sigmaW;
                i = i+1;
            case 'rhoinf'
                if isnan(T)
                    error('SyncPlot: T not specified.')
                elseif ~iscell(C) && isnan(C)
                    error('SyncPlot: C not specified.')
                elseif isnan(threshTau)
                    error('SyncPlot: threshTau not specified.')
                elseif ~iscell(rhoN) && isnan(rhoN)
                    [L,rhoN,rhoC,rhoInf,tauC,tauWindow] = spCalcTau(T,C,threshTau);
                end
                spRhoinf(rhoInf,incrS,tellS);
            case 'rhon'
                if isnan(T)
                    error('SyncPlot: T not specified.')
                elseif ~iscell(C) && isnan(C)
                    error('SyncPlot: C not specified.')
                elseif isnan(threshTau)
                    error('SyncPlot: threshTau not specified.')
                elseif ~iscell(rhoN) && isnan(rhoN)
                    [L,rhoN,rhoC,rhoInf,tauC,tauWindow] = spCalcTau(T,C,threshTau);
                end
                spRhon(T,N,rhoN,tellS,incrS);
            case 'tau'
                if isnan(T)
                    error('SyncPlot: T not specified.')
                elseif ~iscell(C) && isnan(C)
                    error('SyncPlot: C not specified.')
                elseif isnan(threshTau)
                    error('SyncPlot: threshTau not specified.')
                elseif ~iscell(rhoN) && isnan(rhoN)
                    [L,rhoN,rhoC,rhoInf,tauC,tauWindow] = spCalcTau(T,C,threshTau);
                end
                spTau(T,tauC,incrS,tellS)
            case 'rho'
                if isnan(T)
                    error('SyncPlot: T not specified.')
                elseif ~iscell(C) && isnan(C)
                    error('SyncPlot: C not specified.')
                elseif isnan(threshTau)
                    error('SyncPlot: threshTau not specified.')
                elseif ~iscell(rhoN) && isnan(rhoN)
                    [L,rhoN,rhoC,rhoInf,tauC,tauWindow] = spCalcTau(T,C,threshTau);
                end
                spRho(T,rhoC,tauWindow,tauC,tellS,incrS);
            case 'trajec'
                if isnan(T)
                    error('SyncPlot: T not specified.')
                elseif ~iscell(Y) && isnan(Y)
                    error('SyncPlot: Y not specified.')
                elseif isnan(N)
                    error('SyncPlot: N not specified.')
                end
                spTrajecFFT(T,Y,N,incrS,tellS,Yindext,0);
            case 'fft'
                if isnan(T)
                    error('SyncPlot: T not specified.')
                elseif ~iscell(C) && isnan(C)
                    error('SyncPlot: C not specified.')
                elseif ~iscell(Y) && isnan(Y)
                    error('SyncPlot: Y not specified.')
                elseif isnan(N)
                    error('SyncPlot: N not specified.')
                elseif isnan(threshTau)
                    error('SyncPlot: threshTau not specified.')
                elseif ~iscell(rhoN) && isnan(rhoN)
                    [L,rhoN,rhoC,rhoInf,tauC,tauWindow] = spCalcTau(T,C,threshTau);
                end
                if isnan(ssFreqs)
                    [X,f,m,mind,ssFreqs] = spCalcFFT(Y,Fs,tauC);
                end
                spTrajecFFT(T,Y,N,incrS,tellS,Yindext,1,X,f,m,mind);
            case 'dendro'
                if isnan(T)
                    error('SyncPlot: T not specified.')
                elseif ~iscell(C) && isnan(C)
                    error('SyncPlot: C not specified.')
                elseif isnan(thresh)
                    error('SyncPlot: thresh not specified.')
                elseif isnan(threshTau)
                    error('SyncPlot: threshTau not specified.')
                elseif ~iscell(rhoN) && isnan(rhoN)
                    [L,rhoN,rhoC,rhoInf,tauC,tauWindow] = spCalcTau(T,C,threshTau);
                end
                if ~iscell(syncTime) && isnan(syncTime)
                    syncTime = spCalcSynctime(T,C,N,rhoC,tauC,thresh);
                end
                spDendro(syncTime,tellS,incrS);
            case 'squares'
                if isnan(T)
                    error('SyncPlot: T not specified.')
                elseif ~iscell(C) && isnan(C)
                    error('SyncPlot: C not specified.')
                elseif isnan(thresh)
                    error('SyncPlot: thresh not specified.')
                elseif isnan(threshTau)
                    error('SyncPlot: threshTau not specified.')
                elseif ~iscell(rhoN) && isnan(rhoN)
                    [L,rhoN,rhoC,rhoInf,tauC,tauWindow] = spCalcTau(T,C,threshTau);
                end
                if ~iscell(syncTime) && isnan(syncTime)
                    syncTime = spCalcSynctime(T,C,N,rhoC,tauC,thresh);
                end
                spSquares(syncTime,tellS,incrS);
            case 'freq'
                if isnan(T)
                    error('SyncPlot: T not specified.')
                elseif ~iscell(C) && isnan(C)
                    error('SyncPlot: C not specified.')
                elseif ~iscell(Y) && isnan(Y)
                    error('SyncPlot: Y not specified.')
                elseif isnan(N)
                    error('SyncPlot: N not specified.')
                elseif isnan(threshTau)
                    error('SyncPlot: threshTau not specified.')
                elseif ~iscell(rhoN) && isnan(rhoN)
                    [L,rhoN,rhoC,rhoInf,tauC,tauWindow] = spCalcTau(T,C,threshTau);
                end
                if isnan(ssFreqs) 
                    [X,f,m,mind,ssFreqs,extFreq] = spCalcFFT(Y,Fs,tauC,Yindext);
                end
                spFreq(ssFreqs,tellS,incrS,extFreq);
        end
        i = i+1;
    end
end


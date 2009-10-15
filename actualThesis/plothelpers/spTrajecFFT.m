
function spTrajecFFT(T,Y,N,incrS,tellS,Yindext,doFFT,varargin)
    
    if isnan(Yindext)
        error('Yindext not specified.')
    end
    numS = size(Y,1);
    if doFFT
        if size(varargin,2) ~= 4
            error('Check input arguments for the current plotting function.')
        end
        X = varargin{1};
        f = varargin{2};
        m = varargin{3};
        mind = varargin{4};
        figure('Name','Sample Trajectory of the Community and its FFT','NumberTitle','off')
        for s=1:numS
            clf
            subplot(1,2,1)
            plot(T,sin(Y{s,1}(:,1)),'r-',T,sin(Y{s,1}(:,Yindext)),'g-',...
                T,sin(Y{s,1}(:,2:N)),'b-',T,sin(Y{s,1}(:,1)),'r-')
            title(['Sample Community Trajectory for ' tellS '  = ' num2str(incrS(s))])
            legend('Hub','Nodes')
            xlabel('Time t')
            ylabel('sin( \theta )')
            set(gca,'YLim',[-1 1])
            set(gca,'YTick',(-1:1:1))
            set(gca,'XLim',[0 20])
            subplot(1,2,2)
            plot(f{s}(mind(s)),m(s),'ro',f{s}(mind(s)),0,'ro',f{s},X{s},'b-')
            legend(['Steady State Frequency:   ' num2str(f{s}(mind(s))) ' Hz'])
            title('Single-Sided Amplitude Spectrum of the Community Trajectory')
            xlabel('Frequency (Hz)')
            ylabel('|Y(f)|')
            pause
        end
     else
        figure('Name','Sample Trajectory of the Community','NumberTitle','off')
        for s=1:numS
            clf
            plot(T,sin(Y{s,1}(:,1)),'r-',T,sin(Y{s,1}(:,Yindext)),'g-',...
                T,sin(Y{s,1}(:,2:N)),'b-',T,sin(Y{s,1}(:,1)),'r-')
            title(['Sample Community Trajectory for ' tellS '  = ' num2str(incrS(s))])
            legend('Hub','External System','Nodes')
            xlabel('Time t')
            ylabel('sin( \theta )')
            set(gca,'YLim',[-1 1])
            set(gca,'YTick',(-1:1:1))
            set(gca,'XLim',[0 20])
            pause
        end
    end
end
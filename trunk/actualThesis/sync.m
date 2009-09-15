
function [T,Y] = sync(ic,adj,w,tSpan)

    % param{1} = number of community nodes & dimension of external system
    % param{2} = adjacency matrix of community
    % param{3} = natural frequencies of all nodes
    NextSys=1; % Dimension of external system
    Nconections=2; % Number of sensors + actuators
    
    param{1} = [size(ic,1)-Nconections-NextSys NextSys];
    param{2} = adj;
    param{3} = w;
    opt=odeset('RelTol',1e-6);
    
    %[T Y] = ode45(@(t,y) odeSync(t,y,param),tSpan,ic);
    [T Y] = ode113(@(t,y) odeSync(t,y,param),tSpan,ic,opt);
    
end % end sync

function dy= odeSync(t,y,param)

    % dy = change in phase
    % y  = phase
    
    % Sizes of sub-systems
    NComm=param{1}(1);
    NextSys=param{1}(2);
    
    % Pre-allocation
    dy=zeros(NComm+1+NextSys,1);
    
    % Index for nodes in the network
    indComm=1:NComm;
    % Index of sensor
    indSensor=NComm+1;
    
    % Index for the external system
    indExt=(indSensor+1):(indSensor+NextSys);
    natAdj=param{2}(indComm,indComm);
    extAdj=param{2}(1:NComm,indSensor);

    % Index of the Actuator
    indActuator=indExt(end)+1;
    
    extAct=param{2}(indSensor,1:NComm)~=0;
    if sum(extAct)>1
        disp('Error!!! Please connect only one!');
        return
    end
    extAct=sum(param{2}(indSensor,extAct));
    
    %actuator=sin(y(indComm(1)));
    %sensor=sin(y(indExt));
    
    % kuramoto:
    % dy = w + sum over j (k * sin(y(j) - y(i)))
    r = repmat(y(indComm),1,NComm); 
    dy(indComm,1) = param{3}(indComm) + sum(natAdj .* sin(r'-r),2) + ...
          (t>20 & t<50)*extAdj(indComm)*y(indSensor,1);%extAdj(indComm)*sensor;
  
    dy(indExt)=extSys(t,y,param)+ extAct*y(indActuator,1); %extAct*actuator;%
    
    dy(indSensor,1)=gradSensor(y(indExt))*dy(indExt);%0;
    
    dy(indActuator,1)=gradActuator(y(indComm))*dy(indComm);%0;
    
end % end odeSync

function dy = extSys(t,y,param)
dy(1,1)=0;%(2*pi/60)*5;
end % end extSys

function ds=gradSensor(y)
    ds(1,1)=1;
end
function da=gradActuator(y)
N=numel(y);
da=zeros(1,N);
da(1,1)=cos(y(1));
end
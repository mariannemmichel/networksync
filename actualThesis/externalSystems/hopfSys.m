
function dy = hopfSys(t,y,param,inputSignals,actGain)

    mu = param(1);
    tau = param(2);
    
    % dR
    dy(1) = (mu - y(1)^2)*y(1) + cos(y(2))*actGain*inputSignals;
    % dPhi
    dy(2) = y(3) - 1/y(1)*sin(y(2))*actGain*inputSignals;
    %dOmega
    dy(3) = -1/tau*sin(y(2))*actGain*inputSignals;
    
end % end hopfSys
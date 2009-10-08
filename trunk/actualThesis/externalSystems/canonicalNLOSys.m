
function dy = canonicalNLOSys(t,y,param,inputSignals,actGain)

    mu = param(1);
    E0 = param(2);
    k2 = param(3)^2;
    E = y(2)^2/2 + k2*y(1)^2/2;
    
    % dTheta = omega
    dy(1) = y(2) + actGain*inputSignals;
    % dOmega
    dy(2) = -mu/E0*(E-E0)*y(2) - k2*y(1);
    
end % end canonicalNLOSys
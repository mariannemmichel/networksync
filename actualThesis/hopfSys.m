
function dy = hopfSys(t,y,param)

    mu = param(1);
    E0 = param(2);
    k2 = param(3)^2;
    E = y(2)^2/2 + k2*y(1)^2/2;
    
    % dTheta = omega
    dy(1) = y(2);
    % dOmega
    dy(2) = -mu/E0*(E-E0)*y(2) - k2*y(1);

end % end hopfSys
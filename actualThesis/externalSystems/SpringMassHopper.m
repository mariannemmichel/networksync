function dy = SpringMassHopper(t,y,param,inputSignals,actGain)
% function dy = SpringMassHopper(t,y,param,inputSignals,actGain)
% Defines the equations of motion for a system of two point masses
% moving along the vertical axis. Each mass is connected with a spring 
% to the ground. The masses separated horizonrally and coonected with a
% third spring.
% The potential function defining the motion has the following shape
%%
% 
% $$V(y_1,y_2,v_1,v_2) = V_f(y_1,v_1)+V_b(y_2,v_2)+V_l(y_1,y_2)$$
% 
% Where the subidexes f,b and l, stand for front, back and link,
% respectively.

% The params specifiy the force functions deriving from the potentials
% described above.
    Ff = param{1}(y(1),y(3));
    mf =param{4};
    Fb = param{2}(y(2),y(4));
    mb = param{5};
    Flink = param{3}(y(1),y(2));

    Grav=-9.81; % Gravity in m/s^2
    
    Isig1=inputSignals{1};
    Isig2=inputSignals{2};

% Just for the testing
    Isig1=inputSignals{1}(t);
    Isig2=inputSignals{2}(t);
    
    dy=zeros(4,1);
    
    dy(1) = y(3);
    dy(2) = y(4);
    dy(3) = Grav + (Ff + Flink + actGain(1)*Isig1 )/mf;
    dy(4) = Grav + ( Fb - Flink + actGain(2)*Isig2 )/mb;
    
end
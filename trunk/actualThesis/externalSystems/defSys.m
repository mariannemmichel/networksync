
function dy = defSys(t,y,param,inputSignals,actGain)

    dy(1,1)=cos(y(end)) + actGain*inputSignals;

end % end defSys
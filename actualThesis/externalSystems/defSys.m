
function dy = defSys(t,y,param,inputSignals,actGain)

    dy=cos(y) + actGain*inputSignals;

end % end defSys
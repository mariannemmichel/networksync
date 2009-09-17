
function syncSave(varargin)
    
    % file params must be given as: 'param', paramvalue, ...
    nargs = size(varargin,2);
    nameStr = zeros(1,nargs);
    i=1;
    varargin
    while i<nargs;
        nameStr(i) = varargin{i};
        nameStr(i+1) = num2str(varargin{i+1});
        i=i+2;
    end
    nameStr
    nargs
    varargin
    save(['results/' nameStr '.mat'])

end
function YPredCell = applyActivations(YPredCell)    %#codegen

%   Copyright 2020-2021 The MathWorks, Inc.


numCells = size(YPredCell, 1);
for iCell = 1:numCells
    for idx = 1:3
        YPredCell{iCell, idx} = sigmoidActivation(YPredCell{iCell,idx});
    end
end
for iCell = 1:numCells
    for idx = 4:5
        YPredCell{iCell, idx} = exp(YPredCell{iCell, idx});
    end
end
for iCell = 1:numCells
    YPredCell{iCell, 6} = sigmoidActivation(YPredCell{iCell, 6});
end
end

function out = sigmoidActivation(x)
out = 1./(1+exp(-x));
end
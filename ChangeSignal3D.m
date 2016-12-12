% Simulation of Complex Systems (FFR120), 2016
% Chalmers University of Technology
% Group 2 : PROJECT (Quorum Sensing Simulation)

function signals    = ChangeSignal3D(bacteriaLocation, signals, ...
    neighbours, baseSignal, sigThres)
    % Description : TBC

    latticeSize     = size(signals, 1);
    newSignals      = zeros(latticeSize, latticeSize, latticeSize);
    nBacteria       = length(bacteriaLocation);
    
    for iBacteria = 1 : nBacteria
        index    = bacteriaLocation(iBacteria);
        if signals(index) > sigThres
            newSignals(index)   = newSignals(index) + 2*baseSignal;
            newSignals(neighbours(index, :)) = ...
                newSignals(index) + baseSignal;
        else
            newSignals(index)   = newSignals(index) + baseSignal;
            newSignals(neighbours(index, :)) = ...
                newSignals(index) + 0.5*baseSignal;
        end
    end
    signals     = newSignals;

end
     
% Simulation of Complex Systems (FFR120), 2016
% Chalmers University of Technology
% Group 2 : PROJECT (Quorum Sensing Simulation)

function signals    = ChangeSignal(bacteriaLocation, signals, ...
    neighbours, baseSignal, rho, sigThres)
    % Description : TBC

    latticeSize     = size(signals,1);
    newSignals      = zeros(latticeSize);
    nBacteria       = size(bacteriaLocation, 2);
    
    for iBacteria = 1 : nBacteria
        i0 = bacteriaLocation(1, iBacteria);
        j0 = bacteriaLocation(2, iBacteria);
        linIndex    = sub2ind([latticeSize, latticeSize], i0, j0);
        if signals(linIndex) > sigThres
            newSignals(linIndex)   = newSignals(linIndex) + 2*baseSignal;
            newSignals(neighbours(linIndex, :)) = ...
                newSignals(linIndex) + baseSignal;
        else
            newSignals(linIndex)   = newSignals(linIndex) + baseSignal;
            newSignals(neighbours(linIndex, :)) = ...
                newSignals(linIndex) + 0.5*baseSignal;
        end
    end
    signals = rho*signals + newSignals;
       
end
     
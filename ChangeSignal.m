% Simulation of Complex Systems (FFR120), 2016
% Chalmers University of Technology
% Group 2 : PROJECT (Quorum Sensing Simulation)

function signals    = ChangeSignal(bacteriaLocation, signals, ...
    neighbours, baseSignal, rho, sigThres, inhibitor)
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
                newSignals(neighbours(linIndex, :)) + baseSignal;
        else
            newSignals(linIndex)   = newSignals(linIndex) + baseSignal;
            newSignals(neighbours(linIndex, :)) = ...
                newSignals(neighbours(linIndex, :)) + 0.5*baseSignal;
        end
    end
    signals = rho*signals + newSignals;
    
    if inhibitor
        i0 = latticeSize/2;
        j0 = latticeSize/2;
        
        boxSize = 10*sqrt(latticeSize);
        for i = 1:boxSize
            for j = 1:boxSize
                i1 = i0 + i - boxSize/2;
                j1 = j0 + j - boxSize/2;
                signals(i1, j1) = signals(i1,j1) - 4*baseSignal*exp(-norm([i0 j0] - [i1 j1])/(2*(3)^2));
            end
        end
            
        %signals(i0-2*sqrt(latticeSize):i0 + 2*sqrt(latticeSize),j0-2*sqrt(latticeSize):j0 + 2*sqrt(latticeSize)) = -1;
    end
       
end
     
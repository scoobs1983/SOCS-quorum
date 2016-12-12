% Simulation of Complex Systems (FFR120), 2016
% Chalmers University of Technology
% Group 2 : PROJECT (Quorum Sensing Simulation)

function signals    = ChangeSignal3D(bacteriaLocation, bacteriaEnergy, ...
    signals, neighbours, baseSignal, sigThres)
    % Description : TBC

    latticeSize     = size(signals, 1);
    newSignals      = zeros(latticeSize, latticeSize, latticeSize);
    nBacteria       = length(bacteriaLocation);
    
    for iBacteria = 1 : nBacteria
        index           = bacteriaLocation(iBacteria);
        bacteriaType    = bacteriaEnergy(4, index);
        
        if bacteriaType == 1                                                % Check if bacteria is a quorum-capable bacteria
            if signals(index) > sigThres
                newSignals(index)   = newSignals(index) + 3*baseSignal;
                newSignals(neighbours(index, :)) = ...
                    newSignals(index) + 1.5*baseSignal;
            else
                newSignals(index)   = newSignals(index) + baseSignal;
                newSignals(neighbours(index, :)) = ...
                newSignals(index) + 0.5*baseSignal;
            end
        end
    end
    signals     = newSignals;

end
     
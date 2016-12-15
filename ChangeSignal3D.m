% Simulation of Complex Systems (FFR120), 2016
% Chalmers University of Technology
% Group 2 : PROJECT (Quorum Sensing Simulation)

function [signals, bacteriaEnergy]    = ChangeSignal3D(bacteriaLocation,...
    bacteriaEnergy, signals, neighbours, baseSignal, sigThres, decayRate)
    % Description : TBC

    latticeSize     = size(signals, 1);
    newSignals      = zeros(latticeSize, latticeSize, latticeSize);
    nBacteria       = length(bacteriaLocation);
    
    for iBacteria = 1 : nBacteria
        index           = bacteriaLocation(iBacteria);
        bacteriaType    = bacteriaEnergy(4, iBacteria);
        
        if bacteriaType == 1 || bacteriaType == 2                                               % Check if bacteria is a quorum-capable bacteria
            if signals(index) > sigThres
                % disp('Enter')
                newSignals(index)   = newSignals(index) + 3*baseSignal;
                newSignals(neighbours(index, :)) = ...
                    newSignals(neighbours(index, :)) + 1.5*baseSignal;
                bacteriaEnergy(4, iBacteria) = 2;
            else
                newSignals(index)   = newSignals(index) + baseSignal;
                newSignals(neighbours(index, :)) = ...
                newSignals(neighbours(index, :)) + 0.5*baseSignal;
                bacteriaEnergy(4, iBacteria) = 1;
            end
        end
    end
    signals     = decayRate*signals + newSignals;

end
     
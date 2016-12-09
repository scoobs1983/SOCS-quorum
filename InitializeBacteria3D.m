% Simulation of Complex Systems (FFR120), 2016
% Chalmers University of Technology
% Group 2 : PROJECT (Quorum Sensing Simulation)

function [bacteriaLocation, bacteriaLattice] = ...
    InitializeBacteria3D(nBacteria, bacteriaLattice, crowdLimit)
    % Places bacteria at random locations within the bacteria lattice,
    % storing coordinates as linear indices and limiting the number of
    % bacteria at a location to a set value

    bacteriaLocation    = zeros(1, nBacteria);                              % Linear Index
    nElements           = (size(bacteriaLattice, 1))^3;
    openLocations       = 1 : nElements;
    
    for iBacteria = 1: nBacteria
        placement = 'Unsuccessful';
        
        while strcmp(placement,'Unsuccessful') == 1
            linCoord     = datasample(openLocations, 1);
                        
            if(bacteriaLattice(linCoord) < crowdLimit)
                bacteriaLattice(linCoord)  = bacteriaLattice(linCoord) + 1;
                bacteriaLocation(iBacteria)= linCoord;
                placement                  = 'Successful';
                openLocations(openLocations == linCoord) = [];              % Remove coordinate from 'pool' of possible locations    
            end
        
        end
    end
end
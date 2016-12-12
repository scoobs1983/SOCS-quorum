% Simulation of Complex Systems (FFR120), 2016
% Chalmers University of Technology
% Group 2 : PROJECT (Quorum Sensing Simulation)

function [bacteriaLocation, bacteriaLattice, bacteriaEnergy] = ...
    InitCompeteBacteria3D(nBacteria, bacteriaLattice, crowdLimit, mode, ...
    competeStatus, feedRates, respRates)
    % Places bacteria at random locations within the bacteria lattice,
    % storing coordinates as linear indices and limiting the number of
    % bacteria at a location to a set value
    
    nElements           = (size(bacteriaLattice, 1))^3;
    initialEnergy       = [3*respRates(1, 1), 3*respRates(2, 1)];
    
    if competeStatus == 1                                                   % COMPETITION CONDITIONS
        bacteriaLocation                            = zeros(1,2*nBacteria); % Linear Index
        bacEnergy                                   = ones(4, 2*nBacteria); % 1st row = energy store, 2nd row = respiration rate, 3rd row = feed-rate, 4th row = quorum(1) or no quorum (0) 
        bacEnergy(1, 1: nBacteria)                  = initialEnergy(1);     % Quorum
        bacEnergy(1, nBacteria + 1 : 2*nBacteria)   = initialEnergy(2);     % No Quorum
        bacEnergy(2, 1: nBacteria)                  = respRates(1, 1);      % Quorum
        bacEnergy(2, nBacteria + 1 : 2*nBacteria)   = respRates(2, 1);      % No Quorum
        bacEnergy(3, 1: nBacteria)                  = feedRates(1, 1);      % Quorum
        bacEnergy(3, nBacteria + 1 : 2*nBacteria)   = feedRates(2, 1);      % No Quorum
        bacEnergy(4, 1: nBacteria)                  = 1;                    % Quorum Classification
        bacEnergy(4, nBacteria + 1 : 2*nBacteria)   = 0;                    % No Quorum Classification
        nBacteria                                   = 2*nBacteria;          % Readjusts population for placement loop below
    else                                                                    % NO COMPETITION
        bacteriaLocation                            = zeros(1,nBacteria);   % Linear Index 
        bacEnergy                                   = ones(4, nBacteria);   % Rows differentiated as above
        if mode == 1                                                        % Quorum
            bacEnergy(1, :)                         = initialEnergy(1);
            bacEnergy(2, :)                         = respRates(1, 1);
            bacEnergy(3, :)                         = feedRates(1, 1);
            bacEnergy(4, :)                         = 1;
        else                                                                % No Quorum
            bacEnergy(1, :)                         = initialEnergy(2);
            bacEnergy(2, :)                         = respRates(2, 1);
            bacEnergy(3, :)                         = feedRates(2, 1);
            bacEnergy(4, :)                         = 0; 
        end        
    end
            
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
    bacteriaEnergy  = bacEnergy;
    
end
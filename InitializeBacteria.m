% Simulation of Complex Systems (FFR120), 2016
% Chalmers University of Technology
% Group 2 : PROJECT (Quorum Sensing Simulation)

function [bacteriaLocation, BacteriaLattice] = ...
    InitializeBacteria(nBacteria, BacteriaLattice, crowdLimit)
    % Places bacteria at random locations within the bacteria lattice,
    % limiting the number of bacteria at a location to a set value

    bacteriaLocation    = zeros(3, nBacteria);                              % Row 1:  x (width); Row 2: y (length / height); Row 3: Nutrient Storage
    coordinate          = size(BacteriaLattice, 1);

    for iBacteria = 1: nBacteria
        placement = 'Unsuccessful';
        
        while strcmp(placement,'Unsuccessful') == 1
            i   = ceil(rand*coordinate);
            j   = ceil(rand*coordinate);
            
            if(BacteriaLattice(i, j) < crowdLimit)
                BacteriaLattice(i, j) = BacteriaLattice(i, j) + 1;
                placement = 'Successful';
            end
            
        end
        bacteriaLocation(:,iBacteria) = [i j];
    
    end
end
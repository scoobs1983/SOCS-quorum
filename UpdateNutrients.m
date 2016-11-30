% Simulation of Complex Systems (FFR120), 2016
% Chalmers University of Technology
% Group 2 : PROJECT (Quorum Sensing Simulation)

function nutrients  = UpdateNutrients...
    (bacteriaLocation, nutrients, feedRate)
    % Replaces depleted nutrients with new nutrients at a random location
    % within the nutrients lattice

    nBacteria       = size(bacteriaLocation, 2);
    latticeSize     = size(nutrients, 2);
    
    for iBacteria = 1 : nBacteria
        i0                  = bacteriaLocation(1, iBacteria);
        j0                  = bacteriaLocation(2, iBacteria);
        nutrients(i0,j0)    = nutrients(i0, j0) - feedRate(iBacteria);
        i                   = ceil(latticeSize*rand);
        j                   = ceil(latticeSize*rand);
        nutrients(i,j)      = nutrients(i, j) + feedRate(iBacteria);
    end
    
end
% Simulation of Complex Systems (FFR120), 2016
% Chalmers University of Technology
% Group 2 : PROJECT (Quorum Sensing Simulation)

function [bacteriaLocation, BacteriaLattice] = ...
    InitializeBacteria(nBacteria, BacteriaLattice)
    % Places specified number of bacteria at random location within the
    % bacterial lattice

    bacteriaLocation    = zeros(2, nBacteria);
    width               = size(BacteriaLattice, 1);

    for iBacteria = 1: nBacteria
        i   = ceil(rand*width);
        j   = ceil(rand*width);
        
        if(BacteriaLattice(i, j) < 5)
            BacteriaLattice(i, j) = BacteriaLattice(i, j) + 1;
        end
        bacteriaLocation(:,iBacteria) = [i j];
    
    end
end
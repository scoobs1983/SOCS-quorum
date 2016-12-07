% Simulation of Complex Systems (FFR120), 2016
% Chalmers University of Technology
% Group 2 : PROJECT (Quorum Sensing Simulation)

function [bacteriaLocation, bacteriaLattice, bacteriaEnergy] = Move...
    (bacteriaLocation, signals, bacteriaLattice, nutrients,bacteriaEnergy,...
    threshold,crowdLimit,neighbours)
    % Description : TBC
    
    repThres        = threshold(1);
    deathThres      = threshold(2);
    sigThres        = threshold(3);
    nutrientThres   = threshold(4);
    nBacteria       = size(bacteriaLocation, 2);
    latticeSize     = size(signals,1);
    iBacteria       = randperm(nBacteria);
    i               = 1;    % Initialise Counter
    
    while(i <= nBacteria)
        i0  = bacteriaLocation(1,iBacteria(i));
        j0  = bacteriaLocation(2,iBacteria(i));
        
        if(signals(i0,j0) > sigThres)
            nutrientThres   = 0.8;
        end
        
        bacteriaEnergy(1,iBacteria(i)) = bacteriaEnergy(1,iBacteria(i)) - bacteriaEnergy(2,iBacteria(i));
        
                %% Death Check
        if(bacteriaEnergy(1,iBacteria(i)) < deathThres)
            bacteriaLocation(:, iBacteria(i))   = [];
            bacteriaEnergy(:,iBacteria(i))                 = [];
            temp                                = bacteriaLattice(i0,j0);
            bacteriaLattice(i0,j0)              = temp-1;
            nBacteria                           = nBacteria - 1;
            iBacteria(iBacteria == max(iBacteria))                           = [];
        
        
        elseif(nutrients(i0,j0) < nutrientThres || nutrients(i0, j0) > repThres)
            
            r = randi(9);
            linIndex = sub2ind(size(bacteriaLattice), i0, j0);
            winningIndex = linIndex;                    %Stay
            if(r > 1)                                   %Move
                winningIndex = neighbours(linIndex,r-1);
            end
            [k, j] = ind2sub(size(bacteriaLattice),winningIndex);
            winningIndex = [k j];
                
            if(bacteriaEnergy(1,iBacteria(i))>bacteriaEnergy(2,iBacteria(i))...
                    && bacteriaEnergy(1,iBacteria(i)) < repThres)%movement
                bacteriaLattice(i0,j0) = bacteriaLattice(i0,j0) - 1;
                bacteriaLocation(:,iBacteria(i)) = winningIndex;
                temp = bacteriaLattice(winningIndex(1),winningIndex(2));
                bacteriaLattice(winningIndex(1),winningIndex(2)) = temp+1;
                bacteriaEnergy(1,iBacteria(i)) = bacteriaEnergy(1,iBacteria(i)) - bacteriaEnergy(2,iBacteria(i));
            
            elseif(bacteriaEnergy(1,iBacteria(i)) >= repThres && ...
                    bacteriaLattice(winningIndex(1),winningIndex(2)) < crowdLimit)%Reproduction
                bacteriaLocation = [bacteriaLocation winningIndex'];
                bacteriaEnergy(1,iBacteria(i)) = bacteriaEnergy(1,iBacteria(i))/2;
                bacteriaEnergy = [bacteriaEnergy bacteriaEnergy(:,iBacteria(i))/2];
                temp = bacteriaLattice(winningIndex(1),winningIndex(2));
                bacteriaLattice(winningIndex(1),winningIndex(2)) = temp+1;
            end
        end
        i = i+1;
    end
        
            

% Simulation of Complex Systems (FFR120), 2016
% Chalmers University of Technology
% Group 2 : PROJECT (Quorum Sensing Simulation)

function [bacteriaLocation, bacteriaLattice, feedRate] = Move...
    (bacteriaLocation, signals, bacteriaLattice, nutrients,feedRate,threshold)
    % Description : TBC
    
    repThres        = threshold(1);
    deathThres      = threshold(2);
    sigThres        = threshold(3);
    nutrientThres   = threshold(4);
    nBacteria       = size(bacteriaLocation, 2);
    latticeSize     = size(signals,1);
    iBacteria       = randperm(nBacteria);
    i               = 1;    % Initialise Counter
    
    while(i < nBacteria)
        i0  = bacteriaLocation(1,iBacteria(i));
        j0  = bacteriaLocation(2,iBacteria(i));
        
        if(signals(i0,j0) > sigThres)
            nutrientThres   = 0.8;
        end
        
        if(nutrients(i0,j0) < nutrientThres && ...
                nutrients(i0, j0) >= deathThres || nutrients(i0, j0) > repThres)
            
            [left, right, up, down] = Boundaries(i0,j0,latticeSize);

            [winning, winningIndex] = Direction(i0,j0,left,right,up,down,...
                nutrients,bacteriaLattice);
            
            if(winning < repThres)%movement
                bacteriaLattice(i0,j0) = bacteriaLattice(i0,j0) - 1;
                bacteriaLocation(:,iBacteria(i)) = winningIndex;
                temp = bacteriaLattice(winningIndex(1),winningIndex(2));
                bacteriaLattice(winningIndex(1),winningIndex(2)) = temp+1;
            elseif(winning >= repThres)%Reproduction
                bacteriaLocation = [bacteriaLocation winningIndex'];
                feedRate = [feedRate feedRate(iBacteria(i))];
                temp = bacteriaLattice(winningIndex(1),winningIndex(2));
                bacteriaLattice(winningIndex(1),winningIndex(2)) = temp+1;
            end
        end
        %% Death Check
        if(nutrients(i0,j0) < deathThres)
            bacteriaLocation(:, iBacteria(i))   = [];
            feedRate(iBacteria(i))                 = [];
            temp                                = bacteriaLattice(i0,j0);
            bacteriaLattice(i0,j0)              = temp-1;
            nBacteria                           = size(bacteriaLocation,2);
            iBacteria                           = randperm(nBacteria);
        end
        i = i+1;   
    end
        
            

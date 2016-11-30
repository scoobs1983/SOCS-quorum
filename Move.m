% Simulation of Complex Systems (FFR120), 2016
% Chalmers University of Technology
% Group 2 : PROJECT (Quorum Sensing Simulation)

function [bacteriaLocation, bacteriaLattice] = Move...
    (bacteriaLocation, signals, bacteriaLattice, nutrients)
    % Description : TBC
    
    sigThres        = 3;
    nutrientThres   = 0.5;
    nBacteria       = size(bacteriaLocation, 2);
    latticeSize     = size(signals,1);
    iBacteria       = randperm(nBacteria);
    i               = 1;                                                    % Initialise Counter
    
    while(i < nBacteria)
        i0  = bacteriaLocation(1,iBacteria(i));
        j0  = bacteriaLocation(2,iBacteria(i));
        
        if(signals(i0,j0) > sigThres)
            nutrientThres   = 0.8;
        end
        
        if(nutrients(i0,j0) < nutrientThres && ...
                nutrients(i0, j0) >= 0.1 || nutrients(i0, j0) > 1.2)
            
            [left, right, up, down] = Boundaries(i0,j0,latticeSize);

            [winning, winningIndex] = Direction(i0,j0,left,right,up,down,nutrients);
            
            if(winning < inf)%movement
                bacteriaLattice(i0,j0) = bacteriaLattice(i0,j0) - 1;
                bacteriaLocation(:,iBacteria(i)) = winningIndex;
                temp = bacteriaLattice(winningIndex(1),winningIndex(2));
                bacteriaLattice(winningIndex(1),winningIndex(2)) = temp+1;
            elseif(winning >= inf)%Reproduction
                bacteriaLocation = [bacteriaLocation winningIndex'];
                temp = bacteriaLattice(winningIndex(1),winningIndex(2));
                bacteriaLattice(winningIndex(1),winningIndex(2)) = temp+1;
            end
        end
        %% Death Check
        if(nutrients(i0,j0) < 0.1)
            bacteriaLocation(:, iBacteria(i))   = [];
            temp                                = bacteriaLattice(i0,j0);
            bacteriaLattice(i0,j0)              = temp-1;
            nBacteria                           = size(bacteriaLocation,2);
            iBacteria                           = randperm(nBacteria);
        end
        i = i+1;   
    end
        
            

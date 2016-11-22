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
            left            = i0-1;
            right           = i0+1;
            up              = j0-1;
            down            = j0+1;
            
            if(i0 == latticeSize)
                right       = 1;
            end
            
            if(i0 == 1)
                left        = latticeSize;
            end
            
            if(j0 == latticeSize)
                down        = 1;
            end
            
            if(j0 == 1)
                up          = latticeSize;
            end

            winningIndex    = [i0 j0];
            winning         = 0;
            
            if(bacteriaLattice(left, j0) < 5 && ...
                    winning < nutrients(left, j0))
                winning     = nutrients(left, j0);
                winningIndex = [left j0];
            end
            
            if(bacteriaLattice(right,j0) < 5 && ...
                    winning < nutrients(right, j0))
                winning     = nutrients(right, j0);
                winningIndex = [right j0];
            end
            
            if(bacteriaLattice(i0,up) < 5 && winning < nutrients(i0,up))
                winning = nutrients(i0,up);
                winningIndex = [i0 up];
            end
            
            if(bacteriaLattice(i0,down) < 5 && ...
                    winning < nutrients(i0,down))
                winning = nutrients(i0,down);
                winningIndex = [i0 down];
            end
            
            if(winning < inf)
                bacteriaLattice(i0,j0) = bacteriaLattice(i0,j0) - 1;
                bacteriaLocation(:,iBacteria(i)) = winningIndex;
                temp = bacteriaLattice(winningIndex(1),winningIndex(2));
                bacteriaLattice(winningIndex(1),winningIndex(2)) = temp+1;
            elseif(winning >= inf)
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
        
            

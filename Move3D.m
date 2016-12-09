% Simulation of Complex Systems (FFR120), 2016
% Chalmers University of Technology
% Group 2 : PROJECT (Quorum Sensing Simulation)

function [bacteriaLocation, bacteriaLattice, bacteriaEnergy] = Move3D...
    (bacteriaLocation, bacteriaLattice, bacteriaEnergy, ...
    threshold, crowdLimit, neighbours)
    % Description : TBC
    
    reproductionThres       = threshold(1);
    deathThres              = threshold(2);
    nBacteria               = length(bacteriaLocation);
    iBacteria               = randperm(nBacteria);

    i = 1;    % Initialise Counter
    while(i <= nBacteria)
        index       = bacteriaLocation(iBacteria(i));
%         i0  = bacteriaLocation(1,iBacteria(i));
%         j0  = bacteriaLocation(2,iBacteria(i));       
        
        %% Death Check
        if(bacteriaEnergy(1, iBacteria(i)) < deathThres)
            bacteriaLocation(iBacteria(i))      = 0;                        % Tag bacteria for annihilation
            bacteriaEnergy(:, iBacteria(i))     = [0; 0; 0];                
            temp                                = bacteriaLattice(index);
            bacteriaLattice(index)              = temp - 1;
        
        %% If They Deserve to Live...
        else
            % linIndex = sub2ind(size(bacteriaLattice), i0, j0);
            bestIndex = index;                                              % Current location
            movement = 0;
            visited = 0;
            while movement == 0 && visited < 8
                r           = randi(27);
                visited     = visited + 1;
                
                if(r == 1)
                    break                                                   % Picking 1 equates to staying
                end
                bestIndex   = neighbours(linIndex, r - 1);
                
                if (bacteriaLattice(bestIndex) < crowdLimit)                % Move
                    movement = 1;
                end
            end
%             [k, j] = ind2sub(size(bacteriaLattice),winningIndex);
%             winningIndex = [k j];
            
            %% Movement
            bacteriaLattice(index)          = bacteriaLattice(i0,j0) - 1;
            bacteriaLocation(iBacteria(i))  = bestIndex;
            temp                            = bacteriaLattice(bestIndex);
            bacteriaLattice(bestIndex)      = temp + 1;
            
            %% Reproduction
            if(bacteriaEnergy(1, iBacteria(i)) >= reproductionThres && ...
                    bacteriaLattice(bestIndex) < crowdLimit)
                bacteriaLocation = [bacteriaLocation bestIndex];
                bacteriaEnergy(1, iBacteria(i)) = ...
                    bacteriaEnergy(1, iBacteria(i))/2;
                bacteriaEnergy = ...
                    [bacteriaEnergy bacteriaEnergy(:, iBacteria(i))/2];
                temp                        = bacteriaLattice(bestIndex);
                bacteriaLattice(bestIndex)  = temp + 1;
            end
        end
        i = i + 1;
    
    end
    
    k = 1;
    while k <= nBacteria
        
        if bacteriaLocation(k)  == 0
            bacteriaLocation(k)     = [];                                   % Remove all trace of its existence
            bacteriaEnergy(:, k)    = [];                                   % Commit its soul to the aether...
            k                       = k - 1;
            nBacteria               = nBacteria - 1;
        end
        k = k + 1;
    
    end
end
        
            

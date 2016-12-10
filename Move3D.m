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
        
        %% Death Check
        if(bacteriaEnergy(1, iBacteria(i)) < deathThres)
            bacteriaLocation(iBacteria(i))      = 0;                        % Tag bacteria for annihilation
            bacteriaEnergy(:, iBacteria(i))     = [0; 0; 0];                
            temp                                = bacteriaLattice(index);
            bacteriaLattice(index)              = temp - 1;
        
        %% If They Deserve to Live...
        else
            bestIndex = index;                                              % Current location
            moveSequence    = randperm(27);
            for r = moveSequence
                                
                if(r == 27)
                    break                                                   % Picking 27 equates to staying
                elseif (bacteriaLattice(bestIndex) < crowdLimit)                
                    bestIndex   = neighbours(index, r);                     % First viable site is selected
                    break
                end
                
            end
            
            %% Movement
            bacteriaLattice(index)          = bacteriaLattice(index) - 1;
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
                    [bacteriaEnergy bacteriaEnergy(:, iBacteria(i))];
                temp                        = bacteriaLattice(bestIndex);
                bacteriaLattice(bestIndex)  = temp + 1;
            end
        end
        i = i + 1;
    
    end
    
    %% Destroy, slaughter, pulverise...
    k = 1;
    while k <= nBacteria                                                    
        
        if bacteriaLocation(k)  == 0
            bacteriaLocation(k)     = [];                                   % Anoher one bites the dust...
            bacteriaEnergy(:, k)    = [];                                   % Commit its soul to the aether!
            k                       = k - 1;
            nBacteria               = nBacteria - 1;                        
        end
        k = k + 1;
    
    end
end
        
            

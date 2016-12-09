% Simulation of Complex Systems (FFR120), 2016
% Chalmers University of Technology
% Group 2 : PROJECT (Quorum Sensing Simulation)

function [bacteriaLocation, bacteriaLattice, bacteriaEnergy] = Move...
    (bacteriaLocation, bacteriaLattice, bacteriaEnergy, ...
    threshold, crowdLimit, neighbours)
    % Description : TBC
    
    reproductionThres       = threshold(1);
    deathThres              = threshold(2);
    nBacteria               = size(bacteriaLocation, 2);
    iBacteria               = randperm(nBacteria);

    i = 1;    % Initialise Counter
    while(i <= nBacteria)
        i0  = bacteriaLocation(1,iBacteria(i));
        j0  = bacteriaLocation(2,iBacteria(i));       
        
        %% Death Check
        if(bacteriaEnergy(1,iBacteria(i)) < deathThres)
            bacteriaLocation(:, iBacteria(i))   = [];                       % Remove all trace of its existence
            bacteriaEnergy(:,iBacteria(i))      = [];                       % Commit its soul to the aether...
            temp                                = bacteriaLattice(i0,j0);
            bacteriaLattice(i0,j0)              = temp - 1;
            nBacteria                           = nBacteria - 1;
            iBacteria(iBacteria == max(iBacteria)) = [];
        
        %% If They Deserve to Live...
        else
            linIndex = sub2ind(size(bacteriaLattice), i0, j0);
            winningIndex = linIndex;                                        % Current location
            movement = 0;
            visited = 0;
            while movement == 0 && visited < 8
                r = randi(9);
                visited = visited + 1;
                if(r == 1)
                    break
                end
                winningIndex = neighbours(linIndex,r-1);
                if (bacteriaLattice(winningIndex) < crowdLimit)             % Move
                    movement = 1;
                end
            end
            [k, j] = ind2sub(size(bacteriaLattice),winningIndex);
            winningIndex = [k j];
            
            %% Movement
            bacteriaLattice(i0,j0) = bacteriaLattice(i0,j0) - 1;
            bacteriaLocation(:,iBacteria(i)) = winningIndex;
            temp = bacteriaLattice(winningIndex(1),winningIndex(2));
            bacteriaLattice(winningIndex(1),winningIndex(2)) = temp+1;
            
            %% Reproduction
            if(bacteriaEnergy(1,iBacteria(i)) >= reproductionThres && ...
                    bacteriaLattice(winningIndex(1),winningIndex(2)) < crowdLimit)
                bacteriaLocation = [bacteriaLocation winningIndex'];
                bacteriaEnergy(1,iBacteria(i)) = bacteriaEnergy(1,iBacteria(i))/2;
                bacteriaEnergy = [bacteriaEnergy bacteriaEnergy(:,iBacteria(i))/2];
                temp = bacteriaLattice(winningIndex(1),winningIndex(2));
                bacteriaLattice(winningIndex(1),winningIndex(2)) = temp+1;
            end
        end
        i = i+1;
    end
        
            

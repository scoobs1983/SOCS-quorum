% Simulation of Complex Systems (FFR120), 2016
% Chalmers University of Technology
% Group 2 : PROJECT (Quorum Sensing Simulation)

function [nutrients, bacteriaEnergy] =  Consumption...
    (bacteriaLocation, bacteriaLattice, nutrients, bacteriaEnergy, ...
    respRates, feedRate)
    % Performs one round of consumption for all bacteria (according to 
    % fixed feed rate or splitting whatever is left, adjusting
    % respiration rates and energy stores as necessary

    nLocations      = numel(bacteriaLattice);
    nBacteria       = size(bacteriaLocation, 1);
    linIndex        = zeros(1, nBacteria);
    m               = length(bacteriaLattice(:, 1));
    n               = length(bacteriaLattice(1, :));
    
    for i = 1 : nBacteria                               
        linIndex(i) = ...
            sub2ind([m n], bacteriaLocation(1, i), bacteriaLocation(2, i)); % Convert bacteria locations to linear index of bacteria lattice
    end
    
    for j = 1 : nLocations
        [~, resBacteria]    = find(linIndex == j);
                
        if isempty(resBacteria) == 0
            nResidents  = length(resBacteria);
            toConsume   = nResidents*feedRate;
        
            if nutrients(j) >= toConsume                                    % Updates storage according to existing feed-rates
                for k = 1 : resBacteria                                     % Leaves feed-rates unchanged
                    bacteriaEnergy(1, k) = bacteriaEnergy(1, k) + feedRate;
                    bacteriaEnergy(2, k) = respRates(2);                    % Ensures all bacteria not in "survival mode"
                end
                nutrients(j) = nutrients(j) - nResidents*feedRate;
                
            elseif nutrients(j) < toConsume && nutrients(j) ~= 0            % Splits existing nutrients equally amongst resident bacteria
                for k = 1 : resBacteria
                    delta = nutrients(j)/nResidents;
                    bacteriaEnergy(1, k) = bacteriaEnergy(1, k) + delta;
                    bacteriaEnergy(2, k) = respRates(1);                    % Reduces feed-rates of all resident bacteria
                end
                nutrients(j) = 0;                                           % Leaves nutrients empty
            
            else                
                for k = 1 : resBacteria                                     % If there are no nutrients
                    bacteriaEnergy(2, k) = respRates(1);               % Reduces feed-rates of all resident bacteria
                end
            end
        end
    end
    
    replenish               = 20*rand;
    nCellsReplenished       = randi(nLocations);
    replenishPortion        = replenish/nCellsReplenished;
    locations               = 1 : nLocations;
    replenishLocation       = datasample(locations, nCellsReplenished, ...
        'Replace', false);
    for ii = replenishLocation
        nutrients(ii)       = nutrients(ii) + replenishPortion;
    end
end
       
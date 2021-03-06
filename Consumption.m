% Simulation of Complex Systems (FFR120), 2016
% Chalmers University of Technology
% Group 2 : PROJECT (Quorum Sensing Simulation)

function [nutrients, bacteriaEnergy, proteins] =  Consumption...
    (bacteriaLocation, bacteriaLattice, nutrients, bacteriaEnergy, ...
    respRates, feedRates, signals, threshold, initialBacteria, proteins)
    % Performs one round of consumption for all bacteria (according to 
    % fixed feed rate or splitting whatever is left, adjusting
    % respiration rates and energy stores as necessary

    nLocations      = numel(bacteriaLattice);
    nBacteria       = size(bacteriaLocation, 2);
    linIndex        = zeros(1, nBacteria);
    m               = length(bacteriaLattice(:, 1));
    n               = length(bacteriaLattice(1, :));
    
    for i = 1 : nBacteria                               
        linIndex(i) = ...
            sub2ind([m n], bacteriaLocation(1, i), bacteriaLocation(2, i)); % Convert bacteria locations to linear index of bacteria lattice
        if signals(linIndex(i)) >= threshold(3)                             % Check if 'quorum' achieved, adjust feed and respiration rates accordingly 
            bacteriaEnergy(2, i)    = respRates(2);                         
            bacteriaEnergy(3, i)    = feedRates(2);
        else                                                                % Turn off 'quorum'
            bacteriaEnergy(2, i)    = respRates(1);                         
            bacteriaEnergy(3, i)    = feedRates(1);
        end
    end
    
    for j = 1 : nLocations
        [~, resBacteria]    = find(linIndex == j);
        
        if(signals(j) >= threshold(5)) && ~isempty(proteins(proteins == j))
            proteins(proteins == j) = [];
        end
        
        if isempty(resBacteria) == 0
            nResidents  = length(resBacteria);
            toConsume   = sum(bacteriaEnergy(3, resBacteria));
            
            if isempty(proteins(proteins == j))  %searches proteins for j
                
                if nutrients(j) >= toConsume                                    % Updates storage according to existing feed-rates                                      % Leaves feed-rates unchanged
                    bacteriaEnergy(1, resBacteria) = ...
                        bacteriaEnergy(1, resBacteria) + ...
                        bacteriaEnergy(3, resBacteria);
                    nutrients(j) = ...
                        nutrients(j) - sum(bacteriaEnergy(3, resBacteria));

                elseif nutrients(j) < toConsume && nutrients(j) ~= 0            % Splits existing nutrients equally amongst resident bacteria
                    delta = nutrients(j)/nResidents;
                    bacteriaEnergy(1, resBacteria) = ...
                        bacteriaEnergy(1, resBacteria) + delta;
                    nutrients(j) = 0;                                           % Leaves nutrients empty
                end
            end
                                                                                
            bacteriaEnergy(1, resBacteria) = ...
                bacteriaEnergy(1, resBacteria) - ...
                bacteriaEnergy(2, resBacteria);
        end
    end
    
    replenish               = (initialBacteria)*rand*rand;
    nCellsReplenished       = randi(nLocations);
    replenishPortion        = replenish/nCellsReplenished;
    locations               = 1 : nLocations;
    replenishLocation       = datasample(locations, nCellsReplenished, ...
        'Replace', false);
    for ii = replenishLocation
        nutrients(ii)       = nutrients(ii) + replenishPortion;
    end
    
    index = ceil(nLocations*rand);
    nutrients(index) = nutrients(index) + 10;
    proteins = [proteins index];

end
       
% Simulation of Complex Systems (FFR120), 2016
% Chalmers University of Technology
% Group 2 : PROJECT (Quorum Sensing Simulation)

function [nutrients, bacteriaEnergy] =  Consumption3D...
    (bacteriaLocation, bacteriaLattice, nutrients, bacteriaEnergy, ...
    respRates, feedRates, signals, threshold, nutrientFlux, locations, ...
    mode, competeStatus)
    % Performs one round of consumption for all bacteria (according to 
    % fixed feed rate or splitting whatever is left, adjusting
    % respiration rates and energy stores as necessary

    nLocations      = numel(bacteriaLattice);
    nBacteria       = length(bacteriaLocation);
    
    if competeStatus == 1                                                   % Check if 'competing' conditions
        for i = 1 : nBacteria                               
            if bacteriaEnergy(4, i) == 1                                    % If quorum
                if signals(bacteriaLocation(i)) >= threshold(3)             % Check if 'quorum' achieved, adjust feed and respiration rates accordingly 
                    bacteriaEnergy(2, i)    = respRates(1, 2);                         
                    bacteriaEnergy(3, i)    = feedRates(1, 2);
                else                                                        % Turn off 'quorum'
                    bacteriaEnergy(2, i)    = respRates(1, 1);                         
                    bacteriaEnergy(3, i)    = feedRates(1, 1);
                end
            end                                                             % If not quorum, nothing needs to change
        end
    else                                                                    % Single species, no competition
        if mode == 1                                                        % If quorum bacteria
    
    for j = 1 : nLocations
        [~, resBacteria]    = find(bacteriaLocation == j);
                
        if isempty(resBacteria) == 0
            nResidents  = length(resBacteria);
            toConsume   = sum(bacteriaEnergy(3, resBacteria));
            
            if nutrients(j) >= toConsume                                    % Updates storage according to existing feed-rates                                      % Leaves feed-rates unchanged
                bacteriaEnergy(1, resBacteria) = ...
                    bacteriaEnergy(1, resBacteria) + ...
                    bacteriaEnergy(3, resBacteria) - ...
                    bacteriaEnergy(2, resBacteria);
                nutrients(j) = ...
                    nutrients(j) - sum(bacteriaEnergy(3, resBacteria));

            elseif nutrients(j) < toConsume && nutrients(j) ~= 0            % Splits existing nutrients equally amongst resident bacteria
                delta = nutrients(j)/nResidents;
                bacteriaEnergy(1, resBacteria) = ...
                    bacteriaEnergy(1, resBacteria) + delta - ...
                    bacteriaEnergy(2, resBacteria);
                nutrients(j) = 0;                                           % Leaves nutrients empty

            else                                                            % If there are no nutrients
                bacteriaEnergy(1, resBacteria) = ...
                    bacteriaEnergy(1, resBacteria) - ...
                    bacteriaEnergy(2, resBacteria);
            end
        end
    end
    
    replenish               = (nutrientFlux)*rand;
    nCellsReplenished       = randi(ceil(nLocations^(0.5)));
    replenishPortion        = replenish/nCellsReplenished;
    replenishLocation       = datasample(locations, nCellsReplenished, ...
        'Replace', false);
    for ii = replenishLocation
        nutrients(ii)       = nutrients(ii) + replenishPortion;
    end
    
end
       
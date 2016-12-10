% Simulation of Complex Systems (FFR120), 2016
% Chalmers University of Technology
% Group 2 : PROJECT (Quorum Sensing Simulation)

function [nutrients, bacteriaEnergy] =  Consumption3D...
    (bacteriaLocation, bacteriaLattice, nutrients, bacteriaEnergy, ...
    respRates, feedRates, signals, threshold, nutrientFlux, locations)
    % Performs one round of consumption for all bacteria (according to 
    % fixed feed rate or splitting whatever is left, adjusting
    % respiration rates and energy stores as necessary

    nLocations      = numel(bacteriaLattice);
    nBacteria       = length(bacteriaLocation);
    
    for i = 1 : nBacteria                               
        if signals(bacteriaLocation(i)) >= threshold(3)                     % Check if 'quorum' achieved, adjust feed and respiration rates accordingly 
            bacteriaEnergy(2, i)    = respRates(2);                         
            bacteriaEnergy(3, i)    = feedRates(2);
        else                                                                % Turn off 'quorum'
            bacteriaEnergy(2, i)    = respRates(1);                         
            bacteriaEnergy(3, i)    = feedRates(1);
        end
    end
    
    for j = 1 : nLocations
        [~, resBacteria]    = find(bacteriaLocation == j);
                
        if isempty(resBacteria) == 0
            nResidents  = length(resBacteria);
            toConsume   = sum(bacteriaEnergy(3, resBacteria));
            
            if nutrients(j) < 10 || signals(j) >= threshold(5)
        
                if nutrients(j) >= toConsume                                % Updates storage according to existing feed-rates                                      % Leaves feed-rates unchanged
                    bacteriaEnergy(1, resBacteria) = ...
                        bacteriaEnergy(1, resBacteria) + ...
                        bacteriaEnergy(3, resBacteria) - ...
                        bacteriaEnergy(2, resBacteria);
                    nutrients(j) = ...
                        nutrients(j) - sum(bacteriaEnergy(3, resBacteria));

                elseif nutrients(j) < toConsume && nutrients(j) ~= 0        % Splits existing nutrients equally amongst resident bacteria
                    delta = nutrients(j)/nResidents;
                    bacteriaEnergy(1, resBacteria) = ...
                        bacteriaEnergy(1, resBacteria) + delta - ...
                        bacteriaEnergy(2, resBacteria);
                    nutrients(j) = 0;                                       % Leaves nutrients empty
                end
            
            else                                                            % If there are no nutrients
                bacteriaEnergy(1, resBacteria) = ...
                    bacteriaEnergy(1, resBacteria) - ...
                    bacteriaEnergy(2, resBacteria);
            end
        end
    end
    
    replenish               = (nutrientFlux^0.5)*rand;
    nCellsReplenished       = randi(ceil(nLocations^(0.3)));
    replenishPortion        = replenish/nCellsReplenished;
    replenishLocation       = datasample(locations, nCellsReplenished, ...
        'Replace', false);
    for ii = replenishLocation
        nutrients(ii)       = nutrients(ii) + replenishPortion;
    end
    
%     index = ceil(nLocations*rand);
%     nutrients(index) = nutrients(index) + 10;

end
       
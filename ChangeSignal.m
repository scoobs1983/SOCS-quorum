% Simulation of Complex Systems (FFR120), 2016
% Chalmers University of Technology
% Group 2 : PROJECT (Quorum Sensing Simulation)

function signals    = ChangeSignal(bacteriaLocation, signals, sigma, rho, sigThres)
    % Description : TBC

    latticeSize     = size(signals,1);
    newSignals      = zeros(latticeSize);
    nBacteria       = size(bacteriaLocation, 2);
    
    for i = 1 : latticeSize
        for j = 1 : latticeSize
            for iBacteria = 1 : nBacteria
                i0 = bacteriaLocation(1, iBacteria);
                j0 = bacteriaLocation(2, iBacteria);
                if(signals(i0,j0) > sigThres)
                    sigma1 = 2*sigma;
                else
                    sigma1 = sigma;
                
                if(i ~= i0 || j ~= j0)
                    newSignals(i, j) = newSignals(i, j) + ...
                        exp(-norm([i j]-[i0 j0])^2/(2*sigma1^2));
                end
                
            end
            signals(i, j) = rho*newSignals(i, j);
        
        end
    end
end
     
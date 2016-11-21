function Signals = ChangeSignal(bacterialLocation,Signals,sigma,rho)
    LatticeSize = size(Signals,1);
    newSignals = zeros(LatticeSize);
    nBacteria = size(bacterialLocation,2);
    for i = 1:LatticeSize
        for j = 1:LatticeSize
            for iBacteria = 1:nBacteria
                i0 = bacterialLocation(1,iBacteria);
                j0 = bacterialLocation(2,iBacteria);
                if(i ~= i0 || j ~= j0)
                    newSignals(i,j) = newSignals(i,j) + exp(-norm([i j]-[i0 j0])^2/(2*sigma^2));
                end
            end
            Signals(i,j) = rho*newSignals(i,j);
        end
    end
end
    
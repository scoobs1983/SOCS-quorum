function Nutrients = UpdateNutrients(bacterialLocation,Nutrients,feedRate)

    nBacteria = size(bacterialLocation,2);
    latticeSize = size(Nutrients,2);
    for iBacteria = 1:nBacteria
        i0 = bacterialLocation(1,iBacteria);
        j0 = bacterialLocation(2,iBacteria);
        Nutrients(i0,j0) = Nutrients(i0,j0)-feedRate;
        i=ceil(20*rand);
        j = ceil(20*rand);
        Nutrients(i,j) = Nutrients(i,j) + 2*feedRate;
    end
    
end

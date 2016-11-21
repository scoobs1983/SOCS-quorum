function [bacterialLocation, BacterialLattice] = ...
    InitializeBacteria(nBacteria,BacterialLattice)
bacterialLocation = zeros(2,nBacteria);

width = size(BacterialLattice,1);

for iBacteria = 1:nBacteria
    i = ceil(rand*width);
    j = ceil(rand*width);
    if(BacterialLattice(i,j) < 5)
        BacterialLattice(i,j) = BacterialLattice(i,j) + 1;
    end
    bacterialLocation(:,iBacteria) = [i j];
    
end
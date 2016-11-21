function [bacterialLocation, BacterialLattice] = InitializeBacteria(nBacteria,BacterialLattice)
bacterialLocation = zeros(2,nBacteria);

for iBacteria = 1:nBacteria
    i = ceil(rand*20);
    j = ceil(rand*20);
    if(BacterialLattice(i,j) < 5)
        BacterialLattice(i,j) = BacterialLattice(i,j) + 1;
    end
    bacterialLocation(:,iBacteria) = [i j];
    
end
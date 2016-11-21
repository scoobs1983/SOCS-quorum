LatticeSize = 20;
BacterialLattice = zeros(LatticeSize);
Nutrients = ones(LatticeSize);
Signals = ones(LatticeSize);
nBacteria = 20;
iterations = 500;
sigma = 10;
rho = 0.3;
feedRate = 0.3;

[bacterialLocation, BacterialLattice] = InitializeBacteria(nBacteria,BacterialLattice);

for iIteration = 1:iterations
    Signals = ChangeSignal(bacterialLocation,Signals,sigma,rho);
    [bacterialLocation, BacterialLattice] = Move(bacterialLocation,Signals,BacterialLattice,...
        Nutrients);
    Nutrients = UpdateNutrients(bacterialLocation,Nutrients,feedRate);
    location(iIteration,:) = [mean(bacterialLocation(1,:)) mean(bacterialLocation(2,:))];
    spread(iIteration,:) = [std(bacterialLocation(1,:)) std(bacterialLocation(2,:))];
    nrBacteria(iIteration) = size(bacterialLocation,2);
end
figure
imagesc(BacterialLattice)
figure
imagesc(Signals)
figure
imagesc(Nutrients)
figure
plot(spread)
figure
plot(nrBacteria)



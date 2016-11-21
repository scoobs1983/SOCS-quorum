clc
clear all
close all

LatticeSize = 50;
BacterialLattice = zeros(LatticeSize);
Nutrients = ones(LatticeSize);
Signals = zeros(LatticeSize);
nBacteria = 100;
iterations = 500;
sigma = 2;
rho = 0.3;
feedRate = 0.2;

[bacterialLocation, BacterialLattice] = InitializeBacteria(nBacteria,BacterialLattice);

for iIteration = 1:iterations
    Signals = ChangeSignal(bacterialLocation,Signals,sigma,rho);
    [bacterialLocation, BacterialLattice] = Move(bacterialLocation,Signals,BacterialLattice,...
        Nutrients);
    Nutrients = UpdateNutrients(bacterialLocation,Nutrients,feedRate);
    location(iIteration,:) = [mean(bacterialLocation(1,:)) mean(bacterialLocation(2,:))];
    spread(iIteration,:) = [std(bacterialLocation(1,:)) std(bacterialLocation(2,:))];
    nrBacteria(iIteration) = size(bacterialLocation,2);
    
    %% Realtime Plot
    figure(1)
    subplot(1,2,1);
    imagesc(BacterialLattice)
    title('Bacteria');
    colorbar
    subplot(1,2,2);
    imagesc(Nutrients)
    title('Nutrient Lattice');
    colorbar
    drawnow update;

end

%% Summary Plots
figure(2)
imagesc(Signals)
figure(3)
plot(spread)
figure(4)
plot(nrBacteria)



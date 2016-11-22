% Simulation of Complex Systems (FFR120), 2016
% Chalmers University of Technology
% Group 2 : PROJECT (Quorum Sensing Simulation)
clc
clear all
close all

latticeSize         = input('Enter square lattice size : ');
bacteriaLattice     = zeros(latticeSize);
nutrients           = ones(latticeSize);
signals             = zeros(latticeSize);
nBacteria           = input('Enter initial number of bacteria : ');
iterations          = input('Enter number of time steps / iterations : ');
sigma               = 2;
rho                 = 0.3;
feedRate            = 0.2;

%% Initialise Bacteria Population
[bacteriaLocation, bacteriaLattice] = ...
    InitializeBacteria(nBacteria, bacteriaLattice);

for i = 1 : iterations
    signals         = ChangeSignal(bacteriaLocation,signals,sigma,rho);
    [bacteriaLocation, bacteriaLattice] = ...
        Move(bacteriaLocation,signals,bacteriaLattice, nutrients);
    nutrients       = UpdateNutrients(bacteriaLocation, nutrients, feedRate);
    location(i, :)  = [mean(bacteriaLocation(1,:)) mean(bacteriaLocation(2,:))];
    spread(i, :)    = [std(bacteriaLocation(1,:)) std(bacteriaLocation(2,:))];
    nrBacteria(i)   = size(bacteriaLocation,2);
    
    %% Realtime Plots
    figure(1)
    set(gcf,'units','normalized','outerposition',[0 0 1 1])
    subplot(1,2,1);
    imagesc(bacteriaLattice)
    colorbar
    title('Bacteria');
    
    subplot(1,2,2);
    imagesc(nutrients)
    title('Nutrient Lattice');
    colorbar
    drawnow update;

end

%% Summary Plots
figure(2)
imagesc(signals)
figure(3)
plot(spread)
figure(4)
plot(nrBacteria)



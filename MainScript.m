% Simulation of Complex Systems (FFR120), 2016
% Chalmers University of Technology
% Group 2 : PROJECT (Quorum Sensing Simulation)
clc
clear all
close all

latticeSize         = input('Enter square lattice size         : ');
nBacteria           = input('Initial number of bacteria        : ');
iterations          = input('Number of time steps / iterations : ');
crowdLimit          = input('Max. bacteria at a location       : ');
feedRate            = 0.2;                                                  % Standard nutrient Consumption per bacteria per timestep
bacteriaEnergy = zeros(2,nBacteria);                       % Initialises the feed-rate for each bacteria 
bacteriaLattice     = zeros(latticeSize);
nutrients           = ones(latticeSize);
signals             = zeros(latticeSize);
sigma               = 2;
rho                 = 0.3;
repThres            = 2;
deathThres          = 0.1;
sigThres            = 3;
nutrientThres       = 0.5;
threshold = [repThres deathThres sigThres nutrientThres];


%% Initialise Bacteria Population
[bacteriaLocation, bacteriaLattice] = ...
    InitializeBacteria(nBacteria, bacteriaLattice, crowdLimit);

for i = 1 : iterations
    %[bacteriaLocation, nutrients, feedRate] = Consume(bacteriaLocation, ...
        %bacteriaLattice, nutrients, feedRate, crowdLimit);
    signals         = ChangeSignal(bacteriaLocation, signals, sigma, rho);
    [bacteriaLocation, bacteriaLattice, bacteriaEnergy] = ...
        Move(bacteriaLocation,signals,bacteriaLattice, nutrients,bacteriaEnergy,threshold);
    nutrients       = UpdateNutrients(bacteriaLocation, nutrients, feedRate);
    location(i, :)  = [mean(bacteriaLocation(1,:)) mean(bacteriaLocation(2,:))];
    spread(i, :)    = [std(bacteriaLocation(1,:)) std(bacteriaLocation(2,:))];
    nrBacteria(i)   = size(bacteriaLocation,2);
    
    %% Realtime Plots
    figure(1)
    set(gcf, 'units','normalized','outerposition',[0 0 1 1]);
    
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
title('Cumulative Quorum Signal Over Area');

figure(3)
plot(spread)
title('Std. Deviation of Bacterial Spread (Degree of Clustering)');

figure(4)
plot(nrBacteria)
title('Number of Surviving Bacteria vs. Time');


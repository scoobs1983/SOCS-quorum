% Simulation of Complex Systems (FFR120), 2016
% Chalmers University of Technology
% Group 2 : PROJECT (Quorum Sensing Simulation)
clc
clear all
%close all

%% Parameters / Variables
latticeSize         = input('Enter square lattice size         : ');
nBacteria           = input('Initial number of bacteria        : ');
iterations          = input('Number of time steps / iterations : ');
crowdLimit          = input('Max. bacteria at a location       : ');
feedRates           = [0.1 0.5];                                            % 1st Element: Low respiration due to low transcription, thus also low feedrate
respRates           = [0.1 0.3];                                            % 2nd Element: High respiration once transcription activated, enzyme enables higher feedrate
baseSignal          = 2;                                                    % Quorum Signal at location of each bacteria
rho                 = 0.3;
repThres            = 2;
deathThres          = 0.1;
sigThres            = 1.5;
nutrientThres       = 0.5;
threshold           = [repThres deathThres sigThres nutrientThres];

%% Initialise Vectors / Matrices
bacteriaEnergy      = zeros(3,nBacteria);                                   % Initialises the feed-rate for each bacteria 
bacteriaLattice     = zeros(latticeSize);
nutrients           = ones(latticeSize)*0.5;
signals             = zeros(latticeSize); 

%% Initialise Bacteria Population & Neighbour Registry
[bacteriaLocation, bacteriaLattice] = ...
    InitializeBacteria(nBacteria, bacteriaLattice, crowdLimit);
neighbours          = MooreNeighbours(bacteriaLattice);

for i = 1 : iterations
    signals         = ChangeSignal(bacteriaLocation, signals, ...
        neighbours, baseSignal, rho, sigThres);
    
    [nutrients, bacteriaEnergy] =  Consumption...
    (bacteriaLocation, bacteriaLattice, nutrients, bacteriaEnergy, ...
    respRates, feedRates, signals, threshold);

    [bacteriaLocation, bacteriaLattice, bacteriaEnergy] = ...
        Move(bacteriaLocation,signals,bacteriaLattice, nutrients,...
        bacteriaEnergy,threshold,crowdLimit,neighbours);
    
    location(i, :)  = [mean(bacteriaLocation(1,:)) mean(bacteriaLocation(2,:))];
    spread(i, :)    = [std(bacteriaLocation(1,:)) std(bacteriaLocation(2,:))];
    nrBacteria(i)   = size(bacteriaLocation,2);
    
    %% Realtime Plots
    figure(1)
    set(gcf, 'units','normalized','outerposition',[0 0 1 1]);
    
    subplot(1,2,1);
    imagesc(bacteriaLattice, [0 crowdLimit]);
    colorbar;
    title('Bacteria');
    
    subplot(1,2,2);
    imagesc(nutrients, [0 2]);
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


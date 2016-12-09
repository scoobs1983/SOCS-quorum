% Simulation of Complex Systems (FFR120), 2016
% Chalmers University of Technology
% Group 2 : PROJECT (Quorum Sensing Simulation)
clc
clear all
close all

%% Establish Quorum Mode
mode                = input('Quorum = 1, No Quorum = 0          : ');
if mode             == 1                                                    % QUORUM conditions
    feedRates       = [0.1      0.9];                                       % 1st Element: Low respiration due to low transcription, thus also low feedrate
    respRates       = [0.05     0.3];                                       % 2nd Element: High respiration once transcription activated, enzyme enables higher feedrate
    sigThres        = 4.5;
else                                                                        % NO QUORUM conditions
    feedRates       = [0.6      0.6];                                       % 1st Element: Low respiration due to low transcription, thus also low feedrate
    respRates       = [0.2      0.2];                                       % 2nd Element: High respiration once transcription activated, enzyme enables higher feedrate
    sigThres        = inf;
end

%% Other Parameters / Variables
latticeSize         = input('Enter square lattice size          : ');
nBacteria           = input('Initial number of bacteria         : ');
iterations          = input('Number of time steps / iterations  : ');
crowdLimit          = input('Max. bacteria at a location        : ');
baseSignal          = 1;                                                    % Quorum Signal at location of each bacteria
rho                 = 0.10;                                                 % Decay Rate
repThres            = 1.5;
deathThres          = 0.1;
nutrientThres       = 0.5;
threshold           = [repThres deathThres sigThres nutrientThres];
    
%% Initialise Vectors / Matrices
bacteriaEnergy      = ones(3,nBacteria)*0.2;                                % Initialises the feed-rate for each bacteria 
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
    respRates, feedRates, signals, threshold, nBacteria);

    [bacteriaLocation, bacteriaLattice, bacteriaEnergy] = ...
        Move(bacteriaLocation, bacteriaLattice, bacteriaEnergy, ...
        threshold, crowdLimit, neighbours);
    
    location(i, :)  = ...
        [mean(bacteriaLocation(1,:)) mean(bacteriaLocation(2,:))];
    spread(i, :)    = ...
        [std(bacteriaLocation(1,:)) std(bacteriaLocation(2,:))];
    nrBacteria(i)   = size(bacteriaLocation,2);
    
    aveNutrients(i) = sum(nutrients(:))/(latticeSize^2);
    
    %% Realtime Plots
    figure(1)
    set(gcf, 'units','normalized','outerposition',[0 0 1 1]);
    
    subplot(2, 2, 1);
    imagesc(bacteriaLattice, [0 crowdLimit]);
    colorbar;
    title('Bacteria');
    
    subplot(2, 2, 2);
    imagesc(nutrients, [0 10]);
    title('Nutrient Lattice');
    colorbar
    
    subplot(2, 2, 3) 
    imagesc(signals, [0 6]);
    title('Cumulative Quorum Signal Over Area');
    colorbar

    subplot(2, 2, 4)
    plot(nrBacteria, 'b-', 'LineWidth', 1.5)
    ylabel('Number of Bacteria');
    axis([0, iterations, 0, latticeSize*10]);
    title('Number of Surviving Bacteria vs. Time');
    drawnow update;
end

%% Summary Plots
% figure(2)
% plot(spread)
% title('Std. Deviation of Bacterial Spread (Degree of Clustering)');




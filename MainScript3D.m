% Simulation of Complex Systems (FFR120), 2016
% Chalmers University of Technology
% Group 2 : PROJECT (Quorum Sensing Simulation)
% MAIN SCRIPT - For 3-Dimensional Bacteria Network
clc
clear all
close all

%% Establish Quorum Mode
mode                = input('Quorum = 1, No Quorum = 0          : ');
if mode             == 1                                                    % QUORUM conditions
    feedRates       = [0.1      0.9];                                       % 1st Element: Low respiration due to low transcription, thus also low feedrate
    respRates       = [0.075     0.3];                                      % 2nd Element: High respiration once transcription activated, enzyme enables higher feedrate
    sigThres        = 4.5;
else                                                                        % NO QUORUM conditions
    feedRates       = [0.45      0.45];                                     % 1st Element: Low respiration due to low transcription, thus also low feedrate
    respRates       = [0.15      0.15];                                     % 2nd Element: High respiration once transcription activated, enzyme enables higher feedrate
    sigThres        = inf;
end

%% Other Parameters / Variables
latticeSize         = input('Enter square lattice size          : ');
nBacteria           = input('Initial number of bacteria         : ');
iterations          = input('Number of time steps / iterations  : ');
crowdLimit          = input('Max. bacteria at a location        : ');
nElements           = latticeSize^3;
dim                 = latticeSize;
baseSignal          = 1;                                                    % Quorum Signal at location of each bacteria
rho                 = 0.10;                                                 % Decay Rate
repThres            = 2;
deathThres          = 0.1;
nutrientThres       = 0.5;
feedThres           = 4.5;
threshold           = [repThres deathThres sigThres nutrientThres feedThres];
    
%% Initialise Vectors / Matrices
bacteriaEnergy      = ones(3, nBacteria)*0.2;                                % Initialises the feed-rate for each bacteria 
bacteriaLattice     = zeros(dim, dim, dim);
signals             = bacteriaLattice; 
nutrients           = ones(dim, dim, dim)*0.5;

%% Initialise Bacteria Population & Neighbour Registry
[bacteriaLocation, bacteriaLattice] = ...
    InitializeBacteria3D(nBacteria, bacteriaLattice, crowdLimit);
neighbours          = MooreNeighbours3D(bacteriaLattice);

for i = 1 : iterations
    signals         = ChangeSignal3D(bacteriaLocation, signals, ...
        neighbours, baseSignal, rho, sigThres);
    
    [nutrients, bacteriaEnergy] =  Consumption3D...
    (bacteriaLocation, bacteriaLattice, nutrients, bacteriaEnergy, ...
    respRates, feedRates, signals, threshold, nBacteria);

    [bacteriaLocation, bacteriaLattice, bacteriaEnergy] = ...
        Move3D(bacteriaLocation, bacteriaLattice, bacteriaEnergy, ...
        threshold, crowdLimit, neighbours);
    
%     spread(i, :)    = ...
%         [std(bacteriaLocation(1,:)) std(bacteriaLocation(2,:))];

%     nrBacteria(i)   = length(bacteriaLocation);
%     
%     aveNutrients(i) = sum(nutrients(:))/(nElements);
    
    %% Realtime 3D Plot
    [Y, X, Z]       = ind2sub([dim, dim, dim], bacteriaLocation);
    scatter3(Y, X, Z) 
    drawnow update;
end

% Simulation of Complex Systems (FFR120), 2016
% Chalmers University of Technology
% Group 2 : PROJECT (Quorum Sensing Simulation)
% MAIN SCRIPT - For 3-Dimensional Bacteria Network
clc
clear all
close all
set(0, 'defaultfigurecolor', [1, 1, 1]);

%% Establish Quorum Mode
mode                = input('Quorum = 1, No Quorum = 0          : ');
if mode             == 1                                                    % QUORUM conditions
    feedRates       = [0.300    0.900];                                     % 1st Element: Low respiration due to low transcription, thus also low feedrate
    respRates       = [0.200    0.450];                                     % 2nd Element: High respiration once transcription activated, enzyme enables higher feedrate
    sigThres        = 4.5;
else                                                                        % NO QUORUM conditions
    feedRates       = [0.900    0.900];                                     % 1st Element: Low respiration due to low transcription, thus also low feedrate
    respRates       = [0.450    0.450];                                     % 2nd Element: High respiration once transcription activated, enzyme enables higher feedrate
    sigThres        = inf;
end

%% Other Parameters / Variables
latticeSize         = input('Enter cube lattice size            : ');
nBacteria           = input('Initial number of bacteria         : ');
iterations          = input('Number of time steps / iterations  : ');
crowdLimit          = 5;
nElements           = latticeSize^3;
locations           = 1 : nElements;
nutrientFlux        = latticeSize;
dim                 = latticeSize;
baseSignal          = 1;                                                    % Quorum Signal at location of each bacteria
rho                 = 0.10;                                                 % Amount of 'signal' remaining after decay
repThres            = 2;
deathThres          = 0.1;
nutrientThres       = 0.5;
feedThres           = 4.5;
threshold           = [repThres deathThres sigThres ...
    nutrientThres feedThres];
transparency        = 1 / crowdLimit;
bacteriaColour      = [50, 205, 50]./255;                                   % Lime green colour for plotting
    
%% Initialise Vectors / Matrices
bacteriaEnergy      = ones(3, nBacteria)*0.45;                              % Initialises the feed-rate for each bacteria 
bacteriaLattice     = zeros(dim, dim, dim);
signals             = bacteriaLattice; 
nutrients           = ones(1, nElements)*0.45;

%% Initialise Bacteria Population & Neighbour Registry
[bacteriaLocation, bacteriaLattice] = ...
    InitializeBacteria3D(nBacteria, bacteriaLattice, crowdLimit);
neighbours          = MooreNeighbours3D(bacteriaLattice);

for i = 1 : iterations
    signals         = ChangeSignal3D(bacteriaLocation, signals, ...
        neighbours, baseSignal, rho, sigThres);
    
    [nutrients, bacteriaEnergy] =  Consumption3D...
    (bacteriaLocation, bacteriaLattice, nutrients, bacteriaEnergy, ...
    respRates, feedRates, signals, threshold, nutrientFlux, locations);

    [bacteriaLocation, bacteriaLattice, bacteriaEnergy] = ...
        Move3D(bacteriaLocation, bacteriaLattice, bacteriaEnergy, ...
        threshold, crowdLimit, neighbours);
    
    %% Realtime 3D Plot
    [Y, X, Z]       = ind2sub([dim, dim, dim], bacteriaLocation);
    scatter3(Y, X, Z, 80, 'MarkerEdgeColor', 'none', 'MarkerFaceColor',...
        bacteriaColour, 'MarkerFaceAlpha', transparency) 
    axis([0, latticeSize, 0, latticeSize, 0, latticeSize])
    xlabel('X', 'FontSize', 10, 'FontWeight', 'bold', 'FontName',...
        'Times New Roman')
    ylabel('Y', 'FontSize', 10, 'FontWeight', 'bold', 'FontName',...
        'Times New Roman')
    zlabel('Z', 'FontSize', 10, 'FontWeight', 'bold', 'FontName',...
        'Times New Roman')
    title('Bacteria in 3D Volume (periodic boundaries)', 'FontSize', 12,...
        'FontWeight', 'bold', 'FontName', 'Times New Roman') 
    drawnow update;
    
%     %% Record Plots as Frames for a Movie
%     bacteriaMovie(i)    = getframe;
end

% %% Save Movie
% % Saves an *.avi* file into whatever is set as your 'Current Folder'. 
% myVideo             = VideoWriter('Bacteria_Simulation.avi');
% myVideo.FrameRate   = 10;                                                   % Default 30
% myVideo.Quality     = 100;                                                  % Default 75
% open(myVideo);
% writeVideo(myVideo, bacteriaMovie);
% close(myVideo);

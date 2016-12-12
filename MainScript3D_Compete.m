% Simulation of Complex Systems (FFR120), 2016
% Chalmers University of Technology
% Group 2 : PROJECT (Quorum Sensing Simulation)
% MAIN SCRIPT - For 3-Dimensional Bacteria Network
clc
clear all
close all
set(0, 'defaultfigurecolor', [1, 1, 1]);

%% Establish Quorum Mode
mode                = input('Quorum = 1, No Quorum = 0              : ');
competeStatus       = input('Competition = 1, No Competition = 0    : ');
feedRates(1, :)     = [0.200    0.600];                                     % 1st Element: Low respiration due to low transcription, thus also low feedrate
feedRates(2, :)     = [0.600    0.600]; 
respRates(1, :)     = [0.050    0.150];                                     % 2nd Element: High respiration once transcription activated, enzyme enables higher feedrate
respRates(2, :)     = [0.100    0.100];
sigThres            = 4;                                                    % Just for quorum bacteria


%% Other Parameters / Variables
latticeSize         = input('Enter cube lattice size                : ');
nBacteria           = input('Initial number of bacteria             : ');
iterations          = input('Number of time steps / iterations      : ');
crowdLimit          = 5;
nElements           = latticeSize^3;
locations           = 1 : nElements;
nutrientFlux        = latticeSize^1.3;
dim                 = latticeSize;
baseSignal          = 1;                                                    % Quorum Signal at location of each bacteria
reproductionThres   = 1;
deathThres          = 0.1;
nutrientThres       = 0.5;
feedThres           = 4.5;
threshold           = [reproductionThres deathThres sigThres ...
                        nutrientThres feedThres];
transparency        = 1 / crowdLimit;
bacteriaColour      = [50, 205, 50]./255;                                   % Lime green colour for plotting
nutrientColour      = [255, 69, 0]./255;                                    % Orange-red colour for plotting
signalColour        = [0, 206, 209]./255;                                   % Dark turquoise for plotting
    
%% Initialise Vectors / Matrices

bacteriaLattice     = zeros(dim, dim, dim);
signals             = bacteriaLattice; 
nutrients           = rand(1, nElements)*0.5;
tQuorumBacteria     = zeros(1, iterations + 1);
tNonQuorumBacteria  = zeros(1, iterations + 1);
totalNutrients      = zeros(1, iterations + 1);
totalSignal         = zeros(1, iterations + 1);
timeAxis            = 0 : iterations;

%% Initialise Bacteria Population & Neighbour Registry
[bacteriaLocation, bacteriaLattice] = ...
    InitCompeteBacteria3D(nBacteria, bacteriaLattice, crowdLimit, mode, ...
    competeStatus, feedRates, respRates);
neighbours          = MooreNeighbours3D(bacteriaLattice);

%% Record 'Initial' Summary Data
signals                 = ChangeSignal3D(bacteriaLocation, signals, ...
                            neighbours, baseSignal, sigThres);
tQuorumBacteria(1)      = sum(bacteriaEnergy(4, :) == 1);
tNonQuorumBacteria(1)   = sum(bacteriaEnergy(4, :) == 0);
totalNutrients(1)       = sum(nutrients(:));


%% Begin Time-Evolution
for i = 1 : iterations
    % disp(i);
    signals         = ChangeSignal3D(bacteriaLocation, bacteriaEnergy, ...
        signals, neighbours, baseSignal, sigThres);
    
    [nutrients, bacteriaEnergy] =  Consumption3D...
    (bacteriaLocation, bacteriaLattice, nutrients, bacteriaEnergy, ...
    respRates, feedRates, signals, threshold, nutrientFlux, locations);

    [bacteriaLocation, bacteriaLattice, bacteriaEnergy] = ...
        Move3D(bacteriaLocation, bacteriaLattice, bacteriaEnergy, ...
        threshold, crowdLimit, neighbours);
    
    %% Summary Data
    totalBacteria(i + 1)    = length(bacteriaLocation);
    totalNutrients(i + 1)   = sum(nutrients(:));
    totalSignal(i + 1)      = sum(signals(:));
    
    %% Realtime Plots
    [Y, X, Z]       = ind2sub([dim, dim, dim], bacteriaLocation);
    figure(1)
    subplot(1, 3, 1)
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
        
    subplot(1, 3, 2)
    plot(timeAxis(1: i + 1), totalBacteria(1 : i + 1), ...
        'Color', bacteriaColour, 'LineWidth', 2);
    title('Total Bacteria', 'FontSize', 10,...
        'FontWeight', 'bold', 'FontName', 'Times New Roman') 
    axis([0, iterations, 0, 2000]);
    
    subplot(1, 3, 3)
    semilogy(timeAxis(1 : i + 1), totalNutrients(1 : i + 1), ...
        'Color', nutrientColour, 'LineWidth', 2);
    title('Total Nutrients', 'FontSize', 10,...
          'FontWeight', 'bold', 'FontName', 'Times New Roman') 
    axis([0, iterations, 0, 100000]);
    
    drawnow update;

%     %% Record Plots as Frames for a Movie
%     bacteriaMovie(i)    = getframe;
    
end

%% Summary Plot(s)
% figure(2)

% subplot(3, 1, 1)
% plot(timeAxis, totalBacteria, 'Color', bacteriaColour, 'LineWidth', 2);
% title('Total Bacteria', 'FontSize', 10,...
%         'FontWeight', 'bold', 'FontName', 'Times New Roman') 
% axis([0, iterations, 0, 1.1*max(totalBacteria)]);
% 
% subplot(3, 1, 2)
% semilogy(timeAxis, totalNutrients, 'Color', nutrientColour, 'LineWidth', 2);
% title('Total Nutrients', 'FontSize', 10,...
%         'FontWeight', 'bold', 'FontName', 'Times New Roman') 
% axis([0, iterations, 0.9*min(totalNutrients), 1.1*max(totalNutrients)]);
% 
% subplot(3, 1, 3)
% plot(timeAxis, totalSignal, 'Color', signalColour, 'LineWidth', 2);
% title('Total Signal', 'FontSize', 10,...
%         'FontWeight', 'bold', 'FontName', 'Times New Roman') 
% axis([0, iterations, 0.9*min(totalSignal), 1.1*max(totalSignal)]);

% %% Save Movie
% % Saves an *.avi* file into whatever is set as your 'Current Folder'. 
% myVideo             = VideoWriter('Bacteria_Simulation.avi');
% myVideo.FrameRate   = 10;                                                   % Default 30
% myVideo.Quality     = 100;                                                  % Default 75
% open(myVideo);
% writeVideo(myVideo, bacteriaMovie);
% close(myVideo);

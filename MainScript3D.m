% Simulation of Complex Systems (FFR120), 2016
% Chalmers University of Technology
% Group 2 : PROJECT (Quorum Sensing Simulation)
% MAIN SCRIPT - For 3-Dimensional Bacteria Network
clc
clear all
close all
set(0, 'defaultfigurecolor', [255, 255, 255]./255);
set(0, 'defaultaxescolor', [255, 255, 255]./255);
set(0, 'defaulttextcolor', [0, 0, 0]./255);
set(0, 'defaultaxesxcolor', [0, 0, 0]./255);
set(0, 'defaultaxesycolor', [0, 0, 0]./255);
set(0, 'defaultaxeszcolor', [0, 0, 0]./255);

%% Establish Quorum Mode
mode                = input('Quorum = 1, No Quorum = 0              : ');
competeStatus       = input('Competition = 1, No Competition = 0    : ');
feedRates(1, :)     = [0.300    1.200];                                     % 1st Element: Low respiration due to low transcription, thus also low feedrate
feedRates(2, :)     = [1.200    1.200]; 
respRates(1, :)     = [0.130    0.450];                                     % 2nd Element: High respiration once transcription activated, enzyme enables higher feedrate
respRates(2, :)     = [0.370    0.370];
sigThres            = 6;                                                    % Just for quorum bacteria


%% Other Parameters / Variables
latticeSize         = input('Enter cube lattice size                : ');
nBacteria           = input('Initial number of bacteria             : ');
iterations          = input('Number of time steps / iterations      : ');
ProteinMode         = 0;
crowdLimit          = 5;
nElements           = latticeSize^3;
locations           = 1 : nElements;
nutrientFlux        = latticeSize^2;
dim                 = latticeSize;
decay               = 0;
baseSignal          = 1.5;                                                    % Quorum Signal at location of each bacteria
reproductionThres   = 1;
deathThres          = 0.09;
nutrientThres       = 0.5;
feedThres           = 5;
threshold           = [reproductionThres deathThres sigThres ...
                        nutrientThres feedThres];
transparency        = 1 / crowdLimit;
bacColourQuorumActive       = [204, 204, 50]./255;                          % Gold colour for plotting                          
bacColourQuorumInActive     = [50, 205, 50]./255;                           % Lime green colour for plotting
bacColourNonQuorum          = [255, 0, 0]./255;                             % Dark red for plotting
nutrientColour              = [30, 144, 255]./255;                         % Orange-red for plotting
    
%% Initialise Vectors / Matrices

proteins                    = [];
bacteriaLattice             = zeros(dim, dim, dim);
signals                     = bacteriaLattice; 
nutrients                   = rand(1, nElements)*1.5;
tQuorumActiveBacteria       = zeros(1, iterations + 1);
tQuorumInactiveBacteria     = zeros(1, iterations + 1);
tNonQuorumBacteria          = zeros(1, iterations + 1);
tQuorum                     = zeros(1, iterations + 1);
totalNutrients              = zeros(1, iterations + 1);
totalSignal                 = zeros(1, iterations + 1);
timeAxis                    = 0 : iterations;

%% Initialise Bacteria Population & Neighbour Registry
[bacteriaLocation, bacteriaLattice, bacteriaEnergy] = ...
    InitialiseBacteria3D(nBacteria, bacteriaLattice, crowdLimit, mode, ...
    competeStatus, feedRates, respRates);
neighbours          = MooreNeighbours3D(bacteriaLattice);

%% Record 'Initial' Summary Data
[signals, bacteriaEnergy]       = ChangeSignal3D(bacteriaLocation, ...
                                    bacteriaEnergy, signals, neighbours,...
                                    baseSignal, sigThres, decay);
tQuorumActiveBacteria(1)        = sum(bacteriaEnergy(4, :) == 2);
tQuorumInactiveBacteria(1)      = sum(bacteriaEnergy(4, :) == 1);
tNonQuorumBacteria(1)           = sum(bacteriaEnergy(4, :) == 0);
tQuorum(1)                      = tQuorumActiveBacteria(1) + ...
                                    tQuorumInactiveBacteria(1);
totalNutrients(1)               = sum(nutrients(:));


%% Begin Time-Evolution
for i = 1 : iterations
    % disp(i);
    [signals, bacteriaEnergy]   = ChangeSignal3D(bacteriaLocation, ...
        bacteriaEnergy, signals, neighbours, baseSignal, sigThres, decay);
    
    if ProteinMode == 1
        [nutrients, bacteriaEnergy, proteins] =  Protein3D...
            (bacteriaLocation, bacteriaLattice, nutrients, ...
            bacteriaEnergy, respRates, feedRates, signals, threshold, ...
            nutrientFlux, locations, competeStatus, mode, proteins);
    else
        [nutrients, bacteriaEnergy] =  Consumption3D...
            (bacteriaLocation, bacteriaLattice, nutrients, bacteriaEnergy, ...
            respRates, feedRates, signals, threshold, nutrientFlux, locations, ...
            competeStatus, mode);
    end

    [bacteriaLocation, bacteriaLattice, bacteriaEnergy] = ...
        Move3D(bacteriaLocation, bacteriaLattice, bacteriaEnergy, ...
        threshold, crowdLimit, neighbours);
    
    %% Summary Data
    tQuorumActiveBacteria(i + 1)        = sum(bacteriaEnergy(4, :) == 2);
    tQuorumInactiveBacteria(i + 1)      = sum(bacteriaEnergy(4, :) == 1);
    tNonQuorumBacteria(i + 1)           = sum(bacteriaEnergy(4, :) == 0);
    tQuorum(i + 1)                      = tQuorumActiveBacteria(i + 1) +...
                                            tQuorumInactiveBacteria(i + 1);
    totalNutrients(i + 1)               = sum(nutrients(:));
    totalSignal(i + 1)                  = sum(signals(:));
    
    %% Realtime Plots
    indexQuorumActive       = find(bacteriaEnergy(4, :) == 2);
    indexQuorumInActive     = find(bacteriaEnergy(4, :) == 1);
    indexNonQuorum          = find(bacteriaEnergy(4, :) == 0);
    [Y, X, Z]               = ind2sub([dim, dim, dim], ...
                                bacteriaLocation(indexQuorumActive));
    [YY, XX, ZZ]            = ind2sub([dim, dim, dim], ...
                                bacteriaLocation(indexQuorumInActive));
    [YYY, XXX, ZZZ]         = ind2sub([dim, dim, dim], ...
                                bacteriaLocation(indexNonQuorum));
    
    mainFig = figure(1);
    set(mainFig, 'Position', [20 100 1400 500])
    subplot(3, 1, 1)
    scatter3(Y, X, Z, 80, 'MarkerEdgeColor', 'none', 'MarkerFaceColor',...
        bacColourQuorumActive, 'MarkerFaceAlpha', transparency) 
    hold on
    scatter3(YY, XX, ZZ, 80, 'MarkerEdgeColor', 'none', ...
        'MarkerFaceColor', bacColourQuorumInActive, ...
        'MarkerFaceAlpha', transparency) 
    scatter3(YYY, XXX, ZZZ, 80, 'MarkerEdgeColor', 'none', ...
        'MarkerFaceColor', bacColourNonQuorum, 'MarkerFaceAlpha', ...
        transparency) 
    axis([0, latticeSize, 0, latticeSize, 0, latticeSize])
    xlabel('X', 'FontSize', 10, 'FontWeight', 'bold', 'FontName',...
        'Times New Roman')
    ylabel('Y', 'FontSize', 10, 'FontWeight', 'bold', 'FontName',...
        'Times New Roman')
    zlabel('Z', 'FontSize', 10, 'FontWeight', 'bold', 'FontName',...
        'Times New Roman')
    title('Bacteria in 3D Volume (periodic boundaries)', 'FontSize', 14,...
        'FontWeight', 'bold', 'FontName', 'Times New Roman') 
    hold off
        
    subplot(3, 1, 2)
    if mode == 1 && competeStatus == 1
        plot(timeAxis(1: i + 1), tQuorumActiveBacteria(1 : i + 1), '--',...
            'Color', bacColourQuorumActive, 'LineWidth', 2);
        hold on
        plot(timeAxis(1: i + 1), tQuorum(1 : i + 1), ...
            'Color', bacColourQuorumInActive, 'LineWidth', 3);
        plot(timeAxis(1: i + 1), tNonQuorumBacteria(1 : i + 1), ...
            'Color', bacColourNonQuorum, 'LineWidth', 3);
        legendPlot  = legend('Active Quorum Bacteria', ...
            'Total Quorum Bacteria', 'Non-Quorum Bacteria');
    elseif mode == 1 && competeStatus == 0
        plot(timeAxis(1: i + 1), tQuorumActiveBacteria(1 : i + 1), '--',...
            'Color', bacColourQuorumActive, 'LineWidth', 2);
        hold on
        plot(timeAxis(1: i + 1), tQuorum(1 : i + 1), ...
            'Color', bacColourQuorumInActive, 'LineWidth', 3);
        legendPlot  = legend('Active Quorum Bacteria', ...
            'Total Quorum Bacteria');
    elseif mode == 0
        plot(timeAxis(1: i + 1), tNonQuorumBacteria(1 : i + 1), ...
            'Color', bacColourNonQuorum, 'LineWidth', 3);
        legendPlot  = legend('Non-Quorum Bacteria');
    end
    set(legendPlot,'FontSize',14);
    legend('Location', 'northeast');
    title('Bacteria Population', 'FontSize', 14,...
        'FontWeight', 'bold', 'FontName', 'Times New Roman') 
    axis([0, iterations, 0, 0.2*latticeSize^3]);
    hold off
    
    subplot(3, 1, 3)
    plot(timeAxis(1 : i + 1), totalNutrients(1 : i + 1), ...
        'Color', nutrientColour, 'LineWidth', 4);
    title('Total Nutrients', 'FontSize', 14,...
          'FontWeight', 'bold', 'FontName', 'Times New Roman') 
    axis([0, iterations, 0 2.5*latticeSize^3]);
    
    drawnow update;

%     %% Record Plots as Frames for a Movie
%     bacteriaMovie(i)    = getframe(figure(1));
    
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

%% Save Movie
% Saves an *.avi* file into whatever is set as your 'Current Folder'. 
% bacteriaMovie(1)    = [];
% myVideo             = VideoWriter('Bacteria_Simulation.avi');
% myVideo.FrameRate   = 14;                                                   % Default 30
% myVideo.Quality     = 100;                                                  % Default 75
% open(myVideo);
% writeVideo(myVideo, bacteriaMovie);
% close(myVideo);

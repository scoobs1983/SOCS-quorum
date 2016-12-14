% Simulation of Complex Systems (FFR120), 2016
% Chalmers University of Technology
% Group 2 : PROJECT (Quorum Sensing Simulation)
% MAIN SCRIPT - For 3-Dimensional Bacteria Network
clc
clear all
close all
set(0, 'defaultfigurecolor', [55, 71, 79]./255);
set(0, 'defaultaxescolor', [55, 71, 79]./255);
set(0, 'defaulttextcolor', [245, 245, 245]./255);
set(0, 'defaultaxesxcolor', [245, 245, 245]./255);
set(0, 'defaultaxesycolor', [245, 245, 245]./255);
set(0, 'defaultaxeszcolor', [245, 245, 245]./255);

%% Establish Quorum Mode
mode                = input('Quorum = 1, No Quorum = 0              : ');
competeStatus       = input('Competition = 1, No Competition = 0    : ');
feedRates(1, :)     = [0.200    0.600];                                     % 1st Element: Low respiration due to low transcription, thus also low feedrate
feedRates(2, :)     = [0.600    0.600]; 
respRates(1, :)     = [0.075    0.200];                                     % 2nd Element: High respiration once transcription activated, enzyme enables higher feedrate
respRates(2, :)     = [0.150    0.150];
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
bacColourQuorum     = [50, 205, 50]./255;                                   % Lime green colour for plotting
bacColourNonQuorum  = [255, 0, 0]./255;                                     % Dark red for plotting
nutrientColour      = [30, 144, 255]./255;                                  % Orange-red for plotting
    
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
[bacteriaLocation, bacteriaLattice, bacteriaEnergy] = ...
    InitCompeteBacteria3D(nBacteria, bacteriaLattice, crowdLimit, mode, ...
    competeStatus, feedRates, respRates);
neighbours          = MooreNeighbours3D(bacteriaLattice);

%% Record 'Initial' Summary Data
signals                 = ChangeSignal3D(bacteriaLocation, bacteriaEnergy,...
                            signals, neighbours, baseSignal, sigThres);
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
    respRates, feedRates, signals, threshold, nutrientFlux, locations, ...
    competeStatus, mode);

    [bacteriaLocation, bacteriaLattice, bacteriaEnergy] = ...
        Move3D(bacteriaLocation, bacteriaLattice, bacteriaEnergy, ...
        threshold, crowdLimit, neighbours);
    
    %% Summary Data
    tQuorumBacteria(i + 1)      = sum(bacteriaEnergy(4, :) == 1);
    tNonQuorumBacteria(i + 1)   = sum(bacteriaEnergy(4, :) == 0);
    totalNutrients(i + 1)       = sum(nutrients(:));
    totalSignal(i + 1)          = sum(signals(:));
    
    %% Realtime Plots
    indexQuorum     = find(bacteriaEnergy(4, :) == 1);
    indexNonQuorum  = find(bacteriaEnergy(4, :) == 0);
    [Y, X, Z]       = ind2sub([dim, dim, dim], ...
        bacteriaLocation(indexQuorum));
    [YY, XX, ZZ]    = ind2sub([dim, dim, dim], ...
        bacteriaLocation(indexNonQuorum));
    
    mainFig = figure(1);
    set(mainFig, 'Position', [40 100 1450 500])
    subplot(1, 3, 1)
    scatter3(Y, X, Z, 80, 'MarkerEdgeColor', 'none', 'MarkerFaceColor',...
        bacColourQuorum, 'MarkerFaceAlpha', transparency) 
    hold on
    scatter3(YY, XX, ZZ, 80, 'MarkerEdgeColor', 'none', ...
        'MarkerFaceColor', bacColourNonQuorum, 'MarkerFaceAlpha', ...
        transparency) 
    axis([0, latticeSize, 0, latticeSize, 0, latticeSize])
    legend({'Quorum', 'Non-Quorum'}, 'FontSize', 14, 'FontWeight', ...
        'bold', 'Location', 'southoutside', 'Orientation', 'horizontal');
    legend('boxoff');
    xlabel('X', 'FontSize', 10, 'FontWeight', 'bold', 'FontName',...
        'Times New Roman')
    ylabel('Y', 'FontSize', 10, 'FontWeight', 'bold', 'FontName',...
        'Times New Roman')
    zlabel('Z', 'FontSize', 10, 'FontWeight', 'bold', 'FontName',...
        'Times New Roman')
    title('Bacteria in 3D Volume (periodic boundaries)', 'FontSize', 14,...
        'FontWeight', 'bold', 'FontName', 'Times New Roman') 
    hold off
        
    subplot(1, 3, 2)
    plot(timeAxis(1: i + 1), tQuorumBacteria(1 : i + 1), ...
        'Color', bacColourQuorum, 'LineWidth', 2);
    hold on
    plot(timeAxis(1: i + 1), tNonQuorumBacteria(1 : i + 1), ...
        'Color', bacColourNonQuorum, 'LineWidth', 2);
    legendPlot  = legend('Quorum Bacteria', 'Non-Quorum Bacteria');
    set(legendPlot,'FontSize',14);
    legend('Location', 'northeast');
    title('Total Bacteria', 'FontSize', 14,...
        'FontWeight', 'bold', 'FontName', 'Times New Roman') 
    axis([0, iterations, 0, latticeSize^2]);
    hold off
    
    subplot(1, 3, 3)
    plot(timeAxis(1 : i + 1), totalNutrients(1 : i + 1), ...
        'Color', nutrientColour, 'LineWidth', 3);
    title('Total Nutrients', 'FontSize', 14,...
          'FontWeight', 'bold', 'FontName', 'Times New Roman') 
    axis([0, iterations, 0 latticeSize^3]);
    
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

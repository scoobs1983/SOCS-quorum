% Simulation of Complex Systems (FFR120), 2016
% Chalmers University of Technology
% Group 2 : PROJECT (Quorum Sensing Simulation)
clc
clear all
%close all
set(0, 'defaultfigurecolor', [55, 71, 79]./255);
set(0, 'defaultaxescolor', [55, 71, 79]./255);
set(0, 'defaulttextcolor', [245, 245, 245]./255);
set(0, 'defaultaxesxcolor', [245, 245, 245]./255);
set(0, 'defaultaxesycolor', [245, 245, 245]./255);
set(0, 'defaultaxeszcolor', [245, 245, 245]./255);
bacColourQuorum     = [50, 205, 50]./255;                                   % Lime green colour for plotting
bacColourNonQuorum  = [255, 0, 0]./255;                                     % Dark red for plotting

%% Establish Quorum Mode
mode                = input('Quorum = 1, No Quorum = 0          : ');
sThres              = 2.5;                                                  % Sets feedThreshold and sig
if mode             == 1                                                    % QUORUM conditions
    feedRates       = [0.2      0.6];                                       % 1st Element: Low respiration due to low transcription, thus also low feedrate
    respRates       = [0.05     0.15];                                       % 2nd Element: High respiration once transcription activated, enzyme enables higher feedrate
    sigThres        = sThres;
else                                                                        % NO QUORUM conditions
    feedRates       = [0.6      0.6];                                       % 1st Element: Low respiration due to low transcription, thus also low feedrate
    respRates       = [0.1      0.1];                                       % 2nd Element: High respiration once transcription activated, enzyme enables higher feedrate
    sigThres        = inf;
end

%% Other Parameters / Variables
latticeSize         = input('Enter square lattice size          : ');
nBacteria           = input('Initial number of bacteria         : ');
iterations          = input('Number of time steps / iterations  : ');
crowdLimit          = input('Max. bacteria at a location        : ');
plotting            = 0;                                                    %Plotting enable/disable
inhibitor           = 0;
antiBiotics         = 0;
baseSignal          = 2;                                                    % Quorum Signal at location of each bacteria
rho                 = 0;                                                 % Decay Rate
repThres            = 2;
deathThres          = 0.1;
nutrientThres       = 0.5;
feedThres           = sThres;
threshold           = [repThres deathThres sigThres nutrientThres feedThres];
    
%% Initialise Vectors / Matrices
bacteriaEnergy      = ones(3,nBacteria)*0.2;                                % Initialises the feed-rate for each bacteria 
bacteriaLattice     = zeros(latticeSize);
nutrients           = ones(latticeSize)*0.5;
signals             = zeros(latticeSize); 
proteins            = [];

%% Initialise Bacteria Population & Neighbour Registry
[bacteriaLocation, bacteriaLattice] = ...
    InitializeBacteria(nBacteria, bacteriaLattice, crowdLimit);
neighbours          = MooreNeighbours(bacteriaLattice);

for i = 1 : iterations
    signals         = ChangeSignal(bacteriaLocation, signals, ...
        neighbours, baseSignal, rho, sigThres,inhibitor);
    
    [nutrients, bacteriaEnergy, proteins] =  Consumption...
    (bacteriaLocation, bacteriaLattice, nutrients, bacteriaEnergy, ...
    respRates, feedRates, signals, threshold, nBacteria, proteins);

    [bacteriaLocation, bacteriaLattice, bacteriaEnergy] = ...
        Move(bacteriaLocation, bacteriaLattice, bacteriaEnergy, ...
        threshold, crowdLimit, neighbours, antiBiotics);
    
    location(i, :)  = ...
        [mean(bacteriaLocation(1,:)) mean(bacteriaLocation(2,:))];
    spread(i, :)    = ...
        [std(bacteriaLocation(1,:)) std(bacteriaLocation(2,:))];
    nrBacteria(i)   = size(bacteriaLocation,2);
    
    aveNutrients(i) = sum(nutrients(:))/(latticeSize^2);
    
    %% Realtime Plots
    if(plotting == 1)
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
        imagesc(signals, [-3 6]);
        title('Cumulative Quorum Signal Over Area');
        colorbar

        subplot(2, 2, 4)
        plot(nrBacteria, 'b-', 'LineWidth', 1.5)
        ylabel('Number of Bacteria');
        axis([0, iterations, 0, latticeSize*10]);
        title('Number of Surviving Bacteria vs. Time');
        drawnow update;
    end
end
%% For looking at inhibition
if inhibitor || antiBiotics
    figure(3)
    nutrients(proteins) = nutrients(proteins) + 10;
    imagesc(nutrients, [0 20]);
    title('Nutrient Lattice');
    colorbar
end

%% Summary Plots
figure(2)
hold on
if mode
    plot(nrBacteria,'Color', bacColourQuorum, 'LineWidth', 2)
else
    plot(nrBacteria,'Color', bacColourNonQuorum, 'LineWidth', 2)
end
legendPlot  = legend('Quorum Bacteria', 'Non-Quorum Bacteria');
set(legendPlot,'FontSize',14);
legend('Location', 'northeast');
title('Total Bacteria', 'FontSize', 14,...
    'FontWeight', 'bold', 'FontName', 'Times New Roman')
axis([0, iterations, 0, latticeSize^(1.5)]);
xlabel('Time')
ylabel('Number of Bacteria')




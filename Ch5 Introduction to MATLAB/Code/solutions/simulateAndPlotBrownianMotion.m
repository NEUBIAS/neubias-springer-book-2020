% simulateAndPlotBrownianMotion.m

% Simulate a random walk in one dimension with Gaussian stepsize
% Plot steps and trajectory versus time
% Calculate and plot stepsize and "speed" distribution from trajectory
% Subsample the trajectory and re-plot the step-size and "speed" distribution


% 2016-06-07, sfn: created
% 2016-06-21, sfn: subsampling added
% 2016-07-01, sfn: plot-options updated to new standard
% 2017-10-12, sfn: mean speed of subsampled time-series calculated


%% --- INITIALIZE ---
clear variables
close all
clc

% --- simulation settings ---
dt          = 1; % time between recordings
t           = ( 0  : 1000 ) * dt; % time

% --- plot settings ---
fs          = 16; % font-size for labels
saveFigs    = 1 ; % saves figures to file if TRUE, otherwise not

%% --- GENERATE RANDOM STEPS ---
stepNumber  = numel(t); % number of steps to take
seed        = 42; % non-negative integer that determines where the random number generator starts
rng( seed ); % reset random number generator to postion "seed"
xSteps      = randn( 1, stepNumber ) * sqrt(dt); % Gaussian distributed steps of zero mean


%% --- CALCULATE POSITIONS AND SPEEDS ---
xPos        = cumsum( xSteps ); % positions of particle
varSteps    = var( xSteps ); % variance of step-distribution

xVelocity   = diff( xPos ) / dt; % "velocities"
xSpeed      = abs( xVelocity ); % "speeds"
meanSpeed   = mean( xSpeed );
stdSpeed    = std( xSpeed );

%% --- SUBSAMPLE THE POSITIONS ---
% --- Re-sample at every fourth time-point ---
t_subsampled_4      = t( 1 : 4 : end ); % the time-vector, subsampled
xPos_subsampled_4   = xPos( 1 : 4 : end ); % the position-vector, subsampled
meanSpeed4          = mean( abs( diff( xPos_subsampled_4 ) / dt / 4 ) ); % mean "speed"

% --- Re-sample at every eighth time-point ---
t_subsampled_8    = t( 1 : 8 : end ); % the time-vector, subsampled
xPos_subsampled_8 = xPos( 1 : 8 : end ); % the position-vector, subsampled
meanSpeed8          = mean( abs( diff( xPos_subsampled_8 ) / dt / 8 ) ); % mean "speed"

%% --- DISPLAY NUMBERS ---
disp( ['VAR steps = ' num2str( varSteps ) ] )
disp( ['Average speed = ' num2str( meanSpeed ) ] )
disp( ['STD speed = ' num2str( stdSpeed ) ] )

disp( ['Average speed (subsampled 4) =' num2str( meanSpeed4 ) ] )
disp( ['Average speed (subsampled 8) =' num2str( meanSpeed8 ) ] )

%% --- PLOT STEPS VERSUS TIME ---
figure; hold on; clf
plot( t, xSteps, '-', 'color', [0.2 0.4 0.8] )
xlabel( 'Time [AU]' )
ylabel( 'Step [AU]'  )
title( 'Steps versus time' )

%--- tweak the plot ---
% this step is optional
currentAxis                 = gca; % Get Current Axis
currentAxis.Box             = 'on';
currentAxis.XLabel.FontSize = fs;
currentAxis.YLabel.FontSize = fs;
currentAxis.Title.FontSize  = fs;
currentAxis.FontSize        = fs * 1.2;
currentAxis.YLim            = [-4 4];

% --- save figure to file ---
if saveFigs == 1
    cd ~/Desktop
%     print( '-dpdf', 'stepsVersusTime.pdf' )
     print( '-dpng', 'stepsVersusTime.png' )
end

%% --- PLOT HISTOGRAM OF STEPS ---
figure; hold on
binNumber = floor( sqrt( stepNumber ) );
histHandle = histogram( xSteps, binNumber )
xlabel( 'Steps [AU]' )
ylabel( 'Count' )
title( 'Histogram of step-sizes' )

%--- tweak the plot ---
% this step is optional
currentAxis = gca; % Get Current Axis

currentAxis.Box             = 'on';
currentAxis.XLabel.FontSize = fs;
currentAxis.YLabel.FontSize = fs;
currentAxis.Title.FontSize  = fs;
currentAxis.FontSize        = fs * 1.2;
currentAxis.XLim            = [-4 4];
currentAxis.Color

histHandle.FaceColor        = [0.2 0.4 0.8]; % RGB values
histHandle.FaceAlpha        = 0.6; % alpha-value


% --- save figure to file ---
if saveFigs
    cd ~/Desktop
    print( '-dpng', 'stepsHistogram.png' )
end

%% --- PLOT POSITION VERSUS TIME ---
figure; hold on
plot( t, xPos, '-k' )
xlabel( 'Time [AU]' )
ylabel( 'Position [AU]' )
title( 'Position versus time (Trajectory)' )

%--- tweak the plot ---
% this step is optional
currentAxis = gca; % Get Current Axis

currentAxis.Box             = 'on';
currentAxis.XLabel.FontSize = fs;
currentAxis.YLabel.FontSize = fs;
currentAxis.Title.FontSize  = fs;
currentAxis.FontSize        = fs * 1.2;

% --- save figure to file ---
if saveFigs == 1
    cd ~/Desktop
    print( '-dpng', 'positionVersusTime.png' )
end

%% --- ZOOMED PLOT SUBSAMPLED POSITION VERSUS TIME ---
figure; hold on;
fs  = 16; % font-size for labels
plot( t, xPos, '-k.', 'markersize', 16 )
plot( t_subsampled_4, xPos_subsampled_4, '--or', 'markersize', 6 )
plot( t_subsampled_8, xPos_subsampled_8, ':sb', 'markersize', 10 )
legend( 'Every position', 'Every fourth position', 'Every eighth position' )

xlabel( 'Time [AU]' )
ylabel( 'Position [AU]' )
title( 'Position versus time' )

%--- tweak the plot ---
% this step is optional
currentAxis = gca; % Get Current Axis

currentAxis.Box             = 'on';
currentAxis.XLabel.FontSize = fs;
currentAxis.YLabel.FontSize = fs;
currentAxis.Title.FontSize  = fs;
currentAxis.FontSize        = fs * 1.2;
currentAxis.XLim            = [128 152];

% --- save figure to file ---
if saveFigs == 1
    cd ~/Desktop
    print( '-dpng', 'subSampledPositionVersusTime.png' )
end

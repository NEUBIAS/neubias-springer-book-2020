% load_data_plot_msd.m 

% Load all tracks from a single cell
% Calculate the MSD for all time-lags for a single track
% Plot MSD verus time-lag for that track
% Plot the slope of the MSD versus time-lag

% 2016-06-03, sfn: created
% 2016-06-08, sfn: added calculation and plotting of MSD-slope 

%% --- INITIALIZE ---
clear variables; close all; clc

rootDir                         = '/Users/simon/_work/Teaching/2016_06_EMBL_BIAS/SingleParticleTrackingPracticalResults/NEMOTrackingResults';
f                               = filesep; % system dependent file separator: / for OS X, \ for Windows
[filename,pathname,filterindex] = uigetfile( [rootDir f '*_Tracks.xml'], 'Pick a File')
trackNumber                     = 11; % select the track you want to examine
fs                              = 16; % font-size for labels

%% --- Load data ---
% This may take some time if many tracks were found for a cell
[tracks, metadata] = importTrackMateTracks( fullfile( pathname, filename ) , true); % read the xml file

x = tracks{ trackNumber }( : , 2 ); % x positions
y = tracks{ trackNumber }( : , 3 ); % y positions

%% --- Plot position data ---
figure; hold on; box on; axis equal
plot( x, y, 'ok-', 'markerfacecolor', 'w')
plot( x(1), y(1), 'ok', 'markerfacecolor', 'g', 'markersize', 10)
plot( x(end), y(end), 'sk', 'markerfacecolor', 'r', 'markersize', 10)
legend( 'Postions from Trackmate', 'Beginning', 'End')
xlabel( 'X-position (\mum)', 'fontsize', fs )
ylabel( 'Y-position (\mum)', 'fontsize', fs )
title( ['Positions data for track #' num2str( trackNumber) ], 'fontsize', fs )
set( gca, 'fontsize', fs ) % size of numbers on the axes

%% --- Calculate MSD for all time-lags ---
max_tau = numel( x ) - 1; % the largest possible timelag
clear MSD
for tau = 1 : max_tau
    MSD( tau ) = fun_msd_at_tau( x, y, tau );
end

%% --- Calculate the local slope of the MSD ---
% NB: The mean of all these is the same as performing a straight line fit in a log-log plot

logTau  = log( 1 : max_tau ); % logarithm of time-lags
logMSD  = log( MSD ); % logarithm of MSD values

dlogTau = diff( logTau ); % difference of logTau
dlogMSD = diff( logMSD ); % difference of logMSD
alpha   = dlogMSD ./ dlogTau; % the logarithmic derivative of the MSD

%% --- fitting a straigth line to data ---
% We are doing this only to introduce the function polyfit
% NB this is not the correct way of finding the slope, we are making many mistakes:
% 1) The data is correlated
% 2) The errors are not Gaussian
% 3) The y-scale is logarithmic

[P S] = polyfit( logTau, logMSD, 1 ) % polynomial fit of order one

%% --- Plot the MSD ---
figure; hold on; box on
plot( 1 : max_tau, MSD, 'ok' )
xlabel( 'Timelag (frames)', 'fontsize', fs )
ylabel( 'Mean Squared Displacement (\mum)', 'fontsize', fs )
set( gca, 'xscale', 'log' )
set( gca, 'yscale', 'log' )
set( gca, 'fontsize', fs ) % size of numbers on the axes
title( 'MSD', 'fontsize', fs )

%% --- Plot the slope of the MSD against time-lag ---
% Pure data investigation
figure; hold on; grid on; box on
plot( logTau( 2 : end ), alpha, 'or-' )
xlabel( 'log(timelag)', 'fontsize', fs )
ylabel( 'Slope', 'fontsize', fs )
title( 'Slope of MSD versus time-lag', 'fontsize', fs )
set( gca, 'fontsize', fs ) % size of numbers on the axes

%% --- Plot a straight line-fit to the MSD data ---
% (nearly) pure nonsense
figure; hold on; box on
plot( logTau, logMSD, 'ok')
plot( logTau, P(1)*logTau + P(2), 'r')
xlabel( 'log(timelag)', 'fontsize', fs )
ylabel( 'log(MSD)', 'fontsize', fs )
title( 'Straight-line "fit" in log-log plot (wrong approach!)', 'fontsize', fs )
set( gca, 'fontsize', fs ) % size of numbers on the axes

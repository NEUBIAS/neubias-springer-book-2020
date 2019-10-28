%% Perform MSD analysis with the imported tracks.
% We need to have the `tracks` variable in the MATLAB workspace before running this script.

%% 4.6.2 Step 2: Create and Add Data to the MSD Analyzer.

% Create the MSD analyzer object.
% Again, the `msdanalyzer` class must be on your MATLAB path.
ma = msdanalyzer(2, 'um', 'frames')

% Add all the tracks at once.
ma = ma.addAll(tracks);

% Plot all the tracks via the msdanalyzer class.
ma.plotTracks % Plot the tracks.
ma.labelPlotTracks % Add labels to the axis.
set(gca, 'YDir', 'reverse')
set(gca, 'Color', [0.5 0.5 0.5])
set(gcf, 'Color', [0.5 0.5 0.5])

% Add the tracks from the remaining TrackMate files.
% Again, modify the paths so that they point to the XML file on your computer.

tracks2 = importTrackMateTracks('/Users/tinevez/Desktop/Tracking-NEMO-movies_subset/NEMO-IL1/ Cell_03_Tracks.xml', true, false);
ma = ma.addAll(tracks2);

tracks3 = importTrackMateTracks('/Users/tinevez/Desktop/Tracking-NEMO-movies_subset/NEMO-IL1/ Cell_04_Tracks.xml', true, false);
ma = ma.addAll(tracks3);

%% 4.6.4 Step 3: Compute the Mean-Square Displacement.
% Now that we configured the MSD analyzer with all the tracks, we can compute 
% and investigate the MSD curves.

% Compute MSD.
ma = ma.computeMSD
 
% Plot individual MSD curves.
ma.plotMSD

% Ensemble-average MSD.
ma.plotMeanMSD

%% Fitting MSD curves.

% Get the description of the log-log fit function.
help ma.fitLogLogMSD

% Perform the fit:
ma = ma.fitLogLogMSD

% Note that now the loglogfit field of the analyzer is not empty anymore:
ma.loglogfit

% Filter out MSD curves with low R2 
% Logical indexing:
valid = ma.loglogfit.r2fit > 0.5;
fprintf('Retained %d fits over %d.\n', sum(valid), numel(valid))

% Plot histogram of slopes.
 histogram(ma.loglogfit.alpha( valid ), 'Normalization', 'probability')
box off
xlabel('Slope of the log-log fit.')
ylabel('p')
yl = ylim;
line( [ 1 1 ], [ yl(1) yl(2) ], 'Color', 'k', 'LineWidth', 2)


%% 4.6.6 Step 5: Analysis of the Log-Log Fit.

% Is the mean slope significantly lower than 1?

fprintf('Mean slope in the log-log fit: alpha = %.2f +/- %.2f (N = %d).\n', ...
  mean( ma.loglogfit.alpha(valid) ), std( ma.loglogfit.alpha(valid)), sum(valid))
if (h)
    fprintf('The mean of the distribution IS significantly lower than 1 with P = %.2e.\n', p)
else
    fprintf('The mean of the distribution is NOT significantly lower than 1. P = %.2f.\n', p)
end

% How many particles do have a constrained / freely diffusing / transported motion?
cibelow = ma.loglogfit.alpha_uci(valid) < 1;
ciin = ma.loglogfit.alpha_uci(valid) >= 1 & ma.loglogfit.alpha_lci(valid) <= 1;
ciabove = ma.loglogfit.alpha_lci(valid) > 1;

fprintf('Found %3d particles over %d with a confidence interval for the slope value below 1.\n', ...
  sum(cibelow), numel(cibelow))
  
fprintf('Found %3d particles over %d with a slope of 1 inside the confidence interval.\n', ...
  sum(ciin), numel(ciin))
  
fprintf('Found %3d particles over %d with a confidence interval for the slope value above 1.\n', ...
  sum(ciabove), numel(ciabove) )


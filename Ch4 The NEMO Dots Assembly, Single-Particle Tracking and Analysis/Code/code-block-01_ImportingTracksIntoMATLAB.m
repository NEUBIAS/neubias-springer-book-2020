%% Import tracks exported to XML from TrackMate into MATLAB.

% Of course you have to replace by the path to the files on your computer.
track_file = '/Users/tinevez/Desktop/Tracking-NEMO-movies_subset/NEMO-IL1/Cell_02_Tracks.xml';

% The importer 'importTrackMateTracks' is located in your Fiji.app/scripts folder. You
% must add it to the MATLAB path.
tracks = importTrackMateTracks(track_file, true, false);

% Simple diplay of import results.
tracks

% You should see something like this:
% tracks =
% 22x1 cell array
% 112x3 double
% 268x3 double
% 159x3 double
% ...

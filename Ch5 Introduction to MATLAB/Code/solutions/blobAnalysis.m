% blobAnalysis.m

% This script loads a single image and perform the following operations on it:
% inverting, smoothing, thresholding, masking, measurements
% Results are displayed on the image

% 2017-10-12, sfn: created
% 2017-10-13, sfn: completed

%% --- INITIALIZE ---
clear variables
close all
clc

tfs = 16; %title font size

%% --- load image ---
cd ~/Desktop
blobs       = imread('blobs.tif'); % read tif 
blobs_inv   = 255 - blobs; %invert 8bit image

%% --- display the inverted image ---
figure(1)
imshow( blobs_inv, 'initialmagnification', 'fit' )
title( 'Inverted', 'fontsize', tfs )

%% --- Gaussian smooth and Otsu threshold ---
blobs_inv_gauss = imgaussfilt( blobs_inv, 2 ); % sigma = 2 pixels
OtsuLevel       = graythresh( blobs_inv_gauss ); % find threshold
blobs_bw        = im2bw( blobs_inv_gauss, OtsuLevel ); % apply threhold

%% --- display the thresholded image ---
figure(2)
imshow( blobs_bw, 'initialmagnification', 'fit' )
title( 'Inverted, Smoothed, Thresholded', 'fontsize', tfs )

%% --- mask the inverted image with the thresholded image ---
blobs_bw_uint8  = uint8( blobs_bw ); % convert logical to integer
blobs_masked    = blobs_inv .* blobs_bw_uint8; % mask image

%% --- display the masked image ---
figure(3)
imshow( blobs_masked, 'initialmagnification', 'fit' )
title( 'Inverted and Masked', 'fontsize', tfs )

%% --- find perimeter of connected components ---
blobs_perimeter = bwperim( blobs_bw ); % perimeter of white connected components
blobs_summed    = blobs_inv + 255 * uint8( blobs_perimeter ); % convert, scale, and overlay perimeter on image

%% --- display image with perimeter overlaid ---
figure(4)
imshow( blobs_summed, 'initialmagnification', 'fit' )
title( 'Inverted, Masked, Outlines', 'fontsize', tfs )

%% --- measure areas etc on b/w image ---
% stats = regionprops( blobs_bw, {'area' 'perimeter' 'centroid'} ); % extract features from thresholded image
stats = regionprops( blobs_bw, 'area', 'perimeter', 'centroid' ); % same thing, different notation

centroids = cat( 1, stats.Centroid ); % reformat the centroid data to array

%% --- display centroid positions overlaid on grayscale with outlines ---
figure(4) % this figure already exists, we are now adding to it
hold on % tell MATLAB too keep what is already in the figure
plot( centroids( :, 1 ), centroids( :, 2 ), '*r' ) % use red asteriks
title( 'Inverted, Masked, Outlines, Centroids', 'fontsize', tfs )
print( '-dpng', 'blobs_summed_centroids.png')
%% --- measure grayscale values ---
labels          = bwlabel( blobs_bw ); % get identifier for each blob
% statsGrayscale  = regionprops( labels, blobs_inv, {'meanIntensity'} ); % measure pixel-mean for each blob
statsGrayscale  = regionprops( labels, blobs_inv, 'meanIntensity' ); % same thing, different notation
meanIntensity   = cat( 1, statsGrayscale.MeanIntensity ); % reformat the extracted date

%% --- display measurements on image ---
% again, we add to an already existing image
figure(3); hold on
xOffset = 10; % number of pixels to shift the text to the left
text( centroids( :, 1 ) - xOffset, centroids( :, 2 ), num2str( meanIntensity, 4 ), 'color', 'blue', 'fontsize', 10 )
title( 'Inverted, Masked, mean intensity displayed', 'fontsize', tfs )
print( '-dpng', 'blobs_mean_intensity.png')
% mriStackDisplay.m

% This script loads and displays an image stack

% 2017-10-13, sfn: created

%% --- INITIALIZE ---
clear variables % clear all variables in the workspace
close all % close all figure windows
clc % clear the command window
cd('~/Desktop') % change directory to desktop

%% --- load single image and display it ---
mriImage = imread( 'mri-stack.tif', 'index', 7 );
imshow(mriImage)
print( '-dpng', 'mriSlize7.png')
%% --- load same image into array ---
mriStack( : , : , 7 ) = imread( 'mri-stack.tif', 'index', 7 );

%% --- load entire stack of 27 images ---
for imageNumber = 1 : 27
    mriStack( : , : , imageNumber ) = imread( 'mri-stack.tif', 'index', imageNumber );
end

%% --- make a montage ---
mriStack2   = reshape( mriStack, [226 186 1 27]);
map         = colormap('copper'); % bone hot summer copper
montage(mriStack2, map, 'size', [3 9])
print( '-dpng', 'mriMontage.png')
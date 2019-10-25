% matrixMultiplication.m
% 2016-05-25, sfn: created

% Illustrate the effectiveness of the matrix format
% Both in lines of code required and in time to execute

%% --- INITIALIZE ---
clear variables
close all
clc

N_A = 1000; % dimension of matrix A (do not go much above 2'000)
A   = magic( N_A );

%% --- matrix multiplication, Matlab notation ---
tic
A_matrixSquared = A .^ 2;
toc

%% -- FIGURE ---
figure; hold on, box on
imshow( A, [], 'initialmagnification', 'fit' )
colormap( 'default' )
colorbar

%% --- matrix multiplication with double loop ---

tic
% A_loopSquared = zeros( N_A ); % pre-allocating speeds up by factor of 10 or so
for i = 1 : size( A, 1 ) 
    for j = 1 : size( A, 2 )
        A_loopSquared( i, j ) = A( i, j )^2;
    end
end
toc


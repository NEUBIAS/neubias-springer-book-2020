function msd_tau = fun_msd_at_tau_2dim(x,y,tau)

% fun_msd_at_tau_2dim FUNCTION
% GIVEN INPUT DATA 'X', 'Y' THIS FUNCTION RETURNS THE
% MEAN-SQUARED-DISPLACEMENT CALCULALTED IN OVERLAPPING WINDOWS
% FOR THE FIXED TIMELAG VALUE 'tau'
% NB: THIS IS FOR A SINGLE TIMELAG ONLY BUT AVERAGED OVER THE ENTIRE TRACK

% 2016-06-03, sfn, created
% 2016-06-21, sfn: renamed to emphasize 2d nature
% 2017-05-15, sfn, nomenclature changes

%% --- INITIALIZE ---
M   = length( x );            % number of postions determined
dr2  = zeros( 1, M - tau );   % initialize and speed up procedure

%% --- CALCULATE THE MSD AT A SINGLE TIMELAG ---
for k = 1 : M - tau
    dx2         = ( x( k + tau ) - x( k ) ).^2; % squared x-displacement
    dy2         = ( y( k + tau ) - y( k ) ).^2; % squared y-displacement
    
    dr2( k )    = dx2 + dy2;                    % store the squared x-y-displacement for each postion of the sliding window
end

msd_tau     = mean( dr2 ); % The mean of the squared displacements calculated in sliding windows

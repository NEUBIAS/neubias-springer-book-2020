%% coordinates
% source 
U=[ 2, 2, 4; 1, 5, 5];
% target
V=[4+1,4+1,8+1;2,10,10];

%% Method 1 
%(no translation): 
T1=V/U
% or to take into account translation
T2=V/[U; ones(size(U,2))]


%% Method 2 
structT3=fitgeotrans(U',V','nonreflectivesimilarity');
T3=structT3.T'
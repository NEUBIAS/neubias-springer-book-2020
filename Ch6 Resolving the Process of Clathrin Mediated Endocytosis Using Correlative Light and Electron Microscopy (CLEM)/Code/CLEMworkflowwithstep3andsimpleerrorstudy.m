%% Load the images
fm = imread('../data/ex1_FM.tif'); 
em = imread('../data/ex1_EM.tif');

% select red channel (channe 1 over 3 in this dataset), because it contains
% both polystyrene beads ad clatrin. 
fm1 = fm(:,:,1);
imshow(imadjust(fm1)); 


%% load pre selected matching points
load('preselectedpoints.mat'); 

%% launch cp select with the loaded control points
[c_fm,c_em] = cpselect(imadjust(fm1),em,fm_cp_preselected,em_cp_preselected,'Wait',true);
%% add step 3
[ c_fm ] = GaussianFit( fm1, c_fm, 5 );

%% Compute the transfo 
structT = fitgeotrans(c_fm,c_em,'similarity');
T = structT.T';

%% Applying the transformation
em_geom = imref2d(size(em));
fm_trans = imwarp(fm1,structT,'OutputView',em_geom);
figure(1);imshowpair(em,fm_trans,'montage');
figure(2); imshowpair(em,fm_trans,'blend');


%% Finding a point on FM and moving it to EM
figure(3);
imshow(imadjust(fm1));
[x,y] = ginput;% Press Return Key after selecting points
%% add step 3
 X  = GaussianFit( fm1, [x,y], 5 );
x=X(:,1);
y=X(:,2);
[u,v] = transformPointsForward(structT,x,y);

figure(2), hold on, plot(u,v,'*r');



%% Error study

c_em1 = T * [c_fm';ones(1,length(c_fm))];
% identical alternative: c_em1 = transfromPointsForward(a,c_fm);
figure; imshow(em);
hold all;
scatter(c_em(:,1),c_em(:,2),70,'r+');
scatter(c_em1(1,:),c_em1(2,:),70,'bo');
figure;
pos_diff = c_em1(1:2,:)' - c_em;
%plot errors
plot(pos_diff(:,1), pos_diff(:,2),'*r');
grid;
% check if errors are centered on (0,0)
[mu,sig] = normfit(pos_diff);
figure,
% plot an histogramm of absolute distance
distance=sqrt(pos_diff(:,1).^2+pos_diff(:,2).^2);
hist(distance);% default bins
hist(distance,3); % with 3 bins

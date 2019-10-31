%% Load the images
hm = imread('../data/ex1_highmag_1.tif'); 
sm = imread('../data/ex1_highmag_poi.tif');

% display the image(s)
imshow(sm);

% select the landmark pairs

[c_hm,c_lm] = cpselect(hm,em,'Wait',true);


% ----- ----- ----- -----


%% generate and apply the transformation 

a_h = fitgeotrans(c_lm,c_hm,'similarity');


% warp high-mag image on top of overview

hm2lm = invert(lm2hm);
hm_trans = imwarp(hm,hm2lm,'OutputView',em_geom);
imshowpair(em,hm_trans);

% forward transform target coordinates and display final result of correlation

[x_final,y_final] = transformPointsForward(lm2hm,u,v);
figure;imshow(sm);hold all
scatter(x_final,y_final,100,'go');


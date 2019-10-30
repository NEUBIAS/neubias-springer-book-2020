function [ corrected_position ] = GaussianFit( inputimage, listofpoints, N )
%GAUSSIANFIT Fit a 2D Gaussian in a crop around the list of points
figure,
for p=1:length(listofpoints)
    x=listofpoints(p,1);
    y=listofpoints(p,2);
    xinteger=round(x);% because we xant full pixel for the crop
    yinteger=round(y);
    lagx=-(xinteger-x);
    lagy=-(yinteger-y);
    % compute the roi where to crop (imcrop take a rectangle as a
    % parameter, left corner, width and height)
    rect=[xinteger-(N) yinteger-(N) 2*N 2*N];
    croppedimage=imcrop(inputimage,rect);
    croppedimage=croppedimage-min(min(croppedimage));

      
im=double(croppedimage);
sz=size(im);
im1=im;


% determine background from edge pixels
l=im(1,1:end-1);r=im(end,2:end);u=im(2:end,1);d=im(1:end-1,end);

ln=sz(1)-1;
back = [l(:);r(:);u(:);d(:)];
backcoos = [ones(1,ln),(ln+1)*ones(1,ln),2:ln+1,1:ln ; 1:ln,2:ln+1,ones(1,ln),(ln+1)*ones(1,ln)]';

back_s = std(back);
backg1 = median(back);

im1 = im - mean(back);



if sz(1)~=sz(2)
    error('expect square image');
end



%  initial parameters


    
    centerim = im1(2:end-1,2:end-1);
    maxpeak = max(centerim(:));
    
    
    middle = [lagx lagy] + N;


[X,Y]=meshgrid(1:sz(1),1:sz(2));



%Define a function which returns the residual between image and your fitted gaussian
gauss2D = @(params) params(1)/params(4)*exp(-(1/(2*params(4))*((X(:)-params(2)).^2+(Y(:)-params(3)).^2))) - im1(:);

%Define initial guesses for parameters
params0 = [maxpeak,middle,mean(sz)/4];

%not displaying debugging info
opts = optimset('Display','Off');

%Fit
fitparams = lsqnonlin(gauss2D,params0,[],[],opts) ;

A = fitparams(1);
mu = fitparams(2:3);
sig = fitparams(4);


[X1,Y1] = meshgrid(1:0.2:sz,1:0.2:sz);

myfit = A/sig*exp(-(1/(2*sig)*((X1-mu(1)).^2+(Y1-mu(2)).^2)));


        
    %plot(myfit);
    aa=mesh(X1-N-1,Y1-N-1,myfit);hold on; 
    plot3(reshape(X-N-1,[(2*N+1)^2,1]),reshape(Y-N-1,[(2*N+1)^2,1]),reshape(croppedimage-mean(back),[(2*N+1)^2,1]),'.r');
    hold on;
    plot3(lagx,lagy,max(croppedimage(:)-mean(back))+15,'*b');
    %plot3(myfit.x0,myfit.y0,max(max(croppedimage))+5,'*g');
    plot3(mu(1)-N-1,mu(2)-N-1,max(croppedimage(:)-mean(back))+15,'*g');
    pause;
%      corrected_position(p,1)=x-lagx+myfit.x0;
%      corrected_position(p,2)=y-lagy+myfit.y0;
    corrected_position(p,1)=x+mu(1)-N-1;
    corrected_position(p,2)=y+mu(2)-N-1;

    hold off;
end


end


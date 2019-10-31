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
   %imshow(imadjust(croppedimage));
    % use of curvefitting toolbox, define the model
    myfittype = fittype(' A*exp(-((x-x0)^2+(y-y0)^2)/s)',...
    'dependent',{'z'},'independent',{'x','y'},...
    'coefficients',{'A','x0','y0','s'})
    % compute the fit from data
    % data x and y need to be the image support (i.e the grid of pixel
    % position)
    [meshx,meshy] = meshgrid(-N:1:N);
    myfit = fit([reshape(meshx,[(2*N+1)^2,1]),reshape(meshy,[(2*N+1)^2,1])],reshape(croppedimage,[(2*N+1)^2,1]),myfittype,...
        'StartPoint', [max(max(croppedimage)) 0 0 N/5] );
    plot(myfit); hold on; 
    plot3(reshape(meshx,[(2*N+1)^2,1]),reshape(meshy,[(2*N+1)^2,1]),reshape(croppedimage,[(2*N+1)^2,1]),'.r');
    hold on;
    plot3(lagx,lagy,max(max(croppedimage))+5,'*b');
    plot3(myfit.x0,myfit.y0,max(max(croppedimage))+5,'*g');
    pause;
    corrected_position(p,1)=x-lagx+myfit.x0;
    corrected_position(p,2)=y-lagy+myfit.y0;
    hold off;
end


end


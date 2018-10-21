function [ newImage, rho, theta ] = mapToDisc( image )
%MAPTODISC Maps an image to a unit disc, that is removes all the pixels 
% that fall outside a unit radius. 
%
% Copyrights: Agata Migalska
% Last change: 19.03.2016 16:33
%---------------------------------------

    rows = size(image,1);
    cols = size(image,2);
    
    if nargin < 1
        error('Error: Image is missing');
    end
    if rows ~= cols
        error('Error: Image has to be square');
    end
    
    n = rows;
    newImage = image;
    [rho, theta] = radialCoords(n);
    newImage(rho > 1.0) = 0;

end


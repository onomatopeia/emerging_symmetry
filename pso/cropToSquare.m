function [ image ] = cropToSquare( inputImage )
%CROPTOSQUARE Summary of this function goes here
%   Detailed explanation goes here

    if size(inputImage,1) ~= size(inputImage,2)
        smaller_size = min([size(inputImage,1),size(inputImage,2)]);
        rows = size(inputImage,1);
        cols = size(inputImage,2);
        row_start_idx = floor((rows - smaller_size) / 2);
        col_start_idx = floor((cols - smaller_size) / 2);
        image = inputImage(row_start_idx+1:smaller_size+row_start_idx, col_start_idx +1:smaller_size+col_start_idx,:);
    else
        image = inputImage;
    end
    
end


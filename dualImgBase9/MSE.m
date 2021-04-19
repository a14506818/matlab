function [ MSE ] = MSE( img, stego)
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here
MSE = 0;

[height, width] = size(img);

for i = 1 : height
    for j = 1 : width
        MSE = MSE + abs(img(i,j) - stego(i,j))^2;
    end
end
MSE = MSE/(height*width);
end


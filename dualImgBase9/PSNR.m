function [ PSNR ] = PSNR( mse )
%UNTITLED3 Summary of this function goes here
%   Detailed explanation goes here
PSNR = 10 * log10(255^2 / mse);
end


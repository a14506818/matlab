function [ extract_data_array ] = extract_dual_base9( stego_img1, stego_img2 )
%UNTITLED3 Summary of this function goes here
%   Detailed explanation goes here
[height, width] = size(stego_img1);
extract_data_array = [];

for i = 1 : height
    for j = 1 : width
        if stego_img1(i, j) - stego_img2(i, j) == -4
            extract_data_array(end+1) = 0;
        elseif stego_img1(i, j) - stego_img2(i, j) == -3
            extract_data_array(end+1) = 1;
        elseif stego_img1(i, j) - stego_img2(i, j) == -2
            extract_data_array(end+1) = 2;
        elseif stego_img1(i, j) - stego_img2(i, j) == -1
            extract_data_array(end+1) = 3;
        elseif stego_img1(i, j) - stego_img2(i, j) == 0
            extract_data_array(end+1) = 4;
        elseif stego_img1(i, j) - stego_img2(i, j) == 1
            extract_data_array(end+1) = 5;
        elseif stego_img1(i, j) - stego_img2(i, j) == 2
            extract_data_array(end+1) = 6;
        elseif stego_img1(i, j) - stego_img2(i, j) == 3
            extract_data_array(end+1) = 7;
        elseif stego_img1(i, j) - stego_img2(i, j) == 4
            extract_data_array(end+1) = 8;
        end
    end
end
end


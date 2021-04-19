function [ recover_img ] = recover_dual_base9( stego_img1, stego_img2 )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
[height, width] = size(stego_img1);

for i = 1 : height
    for j = 1 : width
        if stego_img1(i, j) - stego_img2(i, j) == -4
            recover_img(i,j) = stego_img1(i, j) + 2;
        elseif stego_img1(i, j) - stego_img2(i, j) == -3
            recover_img(i,j) = stego_img1(i, j) + 1;
        elseif stego_img1(i, j) - stego_img2(i, j) == -2
            recover_img(i,j) = stego_img1(i, j) + 1;
        elseif stego_img1(i, j) - stego_img2(i, j) == -1
            recover_img(i,j) = stego_img1(i, j);
        elseif stego_img1(i, j) - stego_img2(i, j) == 0
            recover_img(i,j) = stego_img1(i, j);
        elseif stego_img1(i, j) - stego_img2(i, j) == 1
            recover_img(i,j) = stego_img1(i, j) - 1;
        elseif stego_img1(i, j) - stego_img2(i, j) == 2
            recover_img(i,j) = stego_img1(i, j) - 1;
        elseif stego_img1(i, j) - stego_img2(i, j) == 3
            recover_img(i,j) = stego_img1(i, j) - 2;
        elseif stego_img1(i, j) - stego_img2(i, j) == 4
            recover_img(i,j) = stego_img1(i, j) - 2;
        end
    end
end

end


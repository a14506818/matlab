function [ stego_img1, stego_img2 ] = embed_dual_base9( img,  secret_array )
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here
stego_img1 = img;
stego_img2 = img;
[height, width] = size(img);
secret_array_index = 0;
for i = 1 : height
    for j = 1 : width
        secret_array_index = secret_array_index + 1;
        m1 = secret_array(1, secret_array_index);

        if m1==0 
            stego_img1(i, j)  = stego_img1(i, j) - 2;
            stego_img2(i, j)  = stego_img2(i, j) + 2;
        elseif m1==1    
            stego_img1(i, j)  = stego_img1(i, j) - 1;
            stego_img2(i, j)  = stego_img2(i, j) + 2;
        elseif m1==2 
            stego_img1(i, j)  = stego_img1(i, j) - 1;
            stego_img2(i, j)  = stego_img2(i, j) + 1;
        elseif m1==3 
            stego_img1(i, j)  = stego_img1(i, j) - 0;
            stego_img2(i, j)  = stego_img2(i, j) + 1;
        elseif m1==4 
            stego_img1(i, j)  = stego_img1(i, j) - 0;
            stego_img2(i, j)  = stego_img2(i, j) + 0;
        elseif m1==5 
            stego_img1(i, j)  = stego_img1(i, j) + 1;
            stego_img2(i, j)  = stego_img2(i, j) + 0;
        elseif m1==6 
            stego_img1(i, j)  = stego_img1(i, j) + 1;
            stego_img2(i, j)  = stego_img2(i, j) - 1;
        elseif m1==7
            stego_img1(i, j)  = stego_img1(i, j) + 2;
            stego_img2(i, j)  = stego_img2(i, j) - 1;
        elseif m1==8 
            stego_img1(i, j)  = stego_img1(i, j) + 2;
            stego_img2(i, j)  = stego_img2(i, j) - 2;
        end
    end
end
end


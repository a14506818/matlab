function [ backPsnr] = daul_base9( cover_img_path, maxbpp )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
% cover_img_path = '..\images\lena.tif';
cover_img_path = [ 'images\'  cover_img_path '512x512.tif'];
cover=imread(cover_img_path); %原始影像
%Gray=rgb2gray(cover); %轉灰階
% img = (cover);
backPsnr = zeros(20,2); 
[height, width] = size(cover);
for i = 1 : height
    for j = 1 : width
        img(i,j) = double(cover(i,j));
    end
end

PSNR_array = [];
bpp_array = [];
for x = 1 : 20
    bpp = maxbpp/20 * x;

    %----------(make data)-------------
    temp_bitset_b2 = [];
    secret_array_b2 = [];
    secret_array_b9 = [];
    % bpp = 2;
    max_bit_amount = bpp*height*width*2;
    % max_bit_amount = 10;
    while length(secret_array_b2) < max_bit_amount
        temp_bitset_b10 = 0;
        for j = 1 : 7
            temp_bitset_b2(end+1) = randi(2) - 1;
            temp_bitset_b10 = temp_bitset_b10 + temp_bitset_b2(end)*2^(7-j);
        end
        if temp_bitset_b10 > 80
            temp_bitset_b2(end) = [];
        end
        temp_bitset_b10 = 0;
        for j = 1 : length(temp_bitset_b2)
            temp_bitset_b10 = temp_bitset_b10 + temp_bitset_b2(1,j)*2^(length(temp_bitset_b2) - j);
        end
        temp_bitset_b9 = [floor(temp_bitset_b10 / 9), mod(temp_bitset_b10,9)];
        secret_array_b9 = [secret_array_b9 , temp_bitset_b9];
        secret_array_b2 = [secret_array_b2, temp_bitset_b2];
        temp_bitset_b9 = [];
        temp_bitset_b2 = [];
    end
    length(secret_array_b9);
    %----------(embedding)-------------
    secret_array_b9_index = 0;
    for i = 1 : height
        for j = 1 : width
            if secret_array_b9_index < length(secret_array_b9)
                secret_array_b9_index = secret_array_b9_index + 1;
                m = secret_array_b9(1,secret_array_b9_index);
            else
                stego_img1(i, j)  = img(i, j);
                stego_img2(i, j)  = img(i, j);
                continue
            end

            m = m - 4;
            stego_img1(i, j)  = img(i, j) + floor(m/2);
            stego_img2(i, j)  = img(i, j) - ceil(m/2);
        end
    end
    %----------(extracting, recovery)-------------
    extract_data_array = [];
    for i = 1 : height
        for j = 1 : width
            diff = stego_img1(i, j) - stego_img2(i, j);            
            extract_data_array(end+1) = diff + 4;            
            recover_img(i,j) = ceil((stego_img1(i, j) + stego_img2(i, j)) / 2);  
        end
    end
    %----------(testing)-------------
    % extracting - b9
    data_diff_b9 = 0;
    temp_b10 = 0;
    binStr = '';
    extract_data_array_b2 = [];
    binStr_len = 0;
    for i = 1 : min(length(secret_array_b9), length(extract_data_array))
        data_diff_b9 = data_diff_b9 + abs(secret_array_b9(i) - extract_data_array(i));
        % b9 to b2 string
        if mod(i,2) == 1
            temp_b10 = temp_b10 + extract_data_array(i) * 9;
        else
            temp_b10 = temp_b10 + extract_data_array(i);
%             binStr = binStr + string(dec2bin(temp_b10,6));
            binStr_len =  binStr_len + length(dec2bin(temp_b10,6));
            temp_b10 = 0;
        end
    end
    data_diff_b9;

    % recovery
    pixel_diff = 0;
    for i = 1 : height
        for j = 1 : width
            pixel_diff = pixel_diff + (abs(img(i,j) - recover_img(i,j)));
        end
    end
    pixel_diff;
    %----------(mse)-------------
%     stego_img1_MSE = MSE(img, stego_img1);
%     stego_img2_MSE = MSE(img, stego_img2);
%     %----------(PSNR)-------------
%     stego_img1_PSNR = PSNR(stego_img1_MSE);
%     stego_img2_PSNR = PSNR(stego_img2_MSE);
%     
    stego_img1_PSNR = clacImage(img, stego_img1);
    stego_img2_PSNR = clacImage(img, stego_img2); 
    
    avgPSNR = (stego_img1_PSNR+stego_img2_PSNR) / 2;
    
    %----------(bpp)-------------
%     if length(secret_array_b9) > length(extract_data_array)
% %         bpp = strlength(binStr) / (height*width*2);
%         bpp = length(binStr) / (height*width*2);
%     else
% %         bpp = strlength(binStr) / (height*width*2);
%         bpp = binStr_len / (height*width*2);
% %         bpp = length(secret_array_b2) / (height*width*2);
%     end
    bpp = binStr_len / (height*width*2);
    PSNR_array = [PSNR_array, avgPSNR];
    bpp_array = [bpp_array, bpp];
    disp(x)
end

for i = 1:length(PSNR_array) 
    backPsnr (i,2) = PSNR_array (i); 
    backPsnr (i,1) = bpp_array (i); 
end
backPsnr
 end


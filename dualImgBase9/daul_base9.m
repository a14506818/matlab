function [ output_array] = daul_base9( cover_img_path, maxbpp )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
% cover_img_path = '..\images\lena.tif';
cover=imread(cover_img_path); %原始影像
%Gray=rgb2gray(cover); %轉灰階
% img = (cover);
[height, width] = size(cover);
for i = 1 : height
    for j = 1 : width
        img(i,j) = double(cover(i,j));
    end
end

output_array = [];
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

            switch m
                case {0}
                    stego_img1(i, j)  = img(i, j) - 2;
                    stego_img2(i, j)  = img(i, j) + 2;
                case {1}
                    stego_img1(i, j)  = img(i, j) - 1;
                    stego_img2(i, j)  = img(i, j) + 2;
                case {2}
                    stego_img1(i, j)  = img(i, j) - 1;
                    stego_img2(i, j)  = img(i, j) + 1;
                case {3}
                    stego_img1(i, j)  = img(i, j) - 0;
                    stego_img2(i, j)  = img(i, j) + 1;
                case {4}
                    stego_img1(i, j)  = img(i, j) - 0;
                    stego_img2(i, j)  = img(i, j) + 0;
                case {5}
                    stego_img1(i, j)  = img(i, j) + 1;
                    stego_img2(i, j)  = img(i, j) + 0;
                case {6}
                    stego_img1(i, j)  = img(i, j) + 1;
                    stego_img2(i, j)  = img(i, j) - 1;
                case {7}
                    stego_img1(i, j)  = img(i, j) + 2;
                    stego_img2(i, j)  = img(i, j) - 1;
                case {8}
                    stego_img1(i, j)  = img(i, j) + 2;
                    stego_img2(i, j)  = img(i, j) - 2;
            end
        end
    end
    %----------(extracting, recovery)-------------
    extract_data_array = [];
    for i = 1 : height
        for j = 1 : width
            switch stego_img1(i, j) - stego_img2(i, j)
                case {-4}
                    extract_data_array(end+1) = 0;
                    recover_img(i,j) = stego_img1(i, j) + 2;
                case {-3}
                    extract_data_array(end+1) = 1;
                    recover_img(i,j) = stego_img1(i, j) + 1;
                case {-2}
                    extract_data_array(end+1) = 2;
                    recover_img(i,j) = stego_img1(i, j) + 1;
                case {-1}
                    extract_data_array(end+1) = 3;
                    recover_img(i,j) = stego_img1(i, j);
                case {0}
                    extract_data_array(end+1) = 4;
                    recover_img(i,j) = stego_img1(i, j);
                case {1}
                    extract_data_array(end+1) = 5;
                    recover_img(i,j) = stego_img1(i, j) - 1;
                case {2}
                    extract_data_array(end+1) = 6;
                    recover_img(i,j) = stego_img1(i, j) - 1;
                case {3}
                    extract_data_array(end+1) = 7;
                    recover_img(i,j) = stego_img1(i, j) - 2;
                case {4}
                    extract_data_array(end+1) = 8;
                    recover_img(i,j) = stego_img1(i, j) - 2;
            end
        end
    end
    %----------(testing)-------------
    % extracting - b9
    data_diff_b9 = 0;
    temp_b10 = 0;
    binStr = "";
    extract_data_array_b2 = [];
    for i = 1 : min(length(secret_array_b9), length(extract_data_array))
        data_diff_b9 = data_diff_b9 + abs(secret_array_b9(i) - extract_data_array(i));
        % b9 to b2 string
        if mod(i,2) == 1
            temp_b10 = temp_b10 + extract_data_array(i) * 9;
        else
            temp_b10 = temp_b10 + extract_data_array(i);
            binStr = binStr + string(dec2bin(temp_b10,6));
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
    stego_img1_MSE = MSE(img, stego_img1);
    stego_img2_MSE = MSE(img, stego_img2);
    %----------(PSNR)-------------
    stego_img1_PSNR = PSNR(stego_img1_MSE);
    stego_img2_PSNR = PSNR(stego_img2_MSE);
    avgPSNR = (stego_img1_PSNR+stego_img2_PSNR) / 2;
    %----------(bpp)-------------
    if length(secret_array_b9) > length(extract_data_array)
        bpp = strlength(binStr) / (height*width*2);
    else
        bpp = strlength(binStr) / (height*width*2);
%         bpp = length(secret_array_b2) / (height*width*2);
    end
    output_array = [output_array, [avgPSNR, bpp]];
    disp(x)
end

end


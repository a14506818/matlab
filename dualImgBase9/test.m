clc
clear

cover_img_path = '..\images\mandrill.tif';
maxbpp = 1.8;
% [ stego_img1_PSNR, stego_img2_PSNR, bpp ] = daul_base9( cover_img_path, maxbpp);

output_array = daul_base9( cover_img_path, maxbpp);
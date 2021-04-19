clc 
clear

cover_img_path = '..\images\lena.tif';
cover=imread(cover_img_path); %原始影像
%Gray=rgb2gray(cover); %轉灰階
% img = (cover);
[height, width] = size(cover);
for i = 1 : height
    for j = 1 : width
        img(i,j) = double(cover(i,j));
    end
end
  
%----------(make secret data 9base)-------------
secret_array = [];
for i = 1 : height*width /2
    secret_array(end+1) = randi(9) - 1;
end



%----------(embedding)-------------
[stego_img1, stego_img2] = embed_dual_base9(img, secret_array);
%----------(extracting)-------------
extract_data_array = extract_dual_base9(stego_img1, stego_img2);
%----------(recovery)-------------
recover_img = recover_dual_base9(stego_img1, stego_img2);

%----------(testing)-------------
% extracting
data_diff = 0;
for i = 1 : height*width
    data_diff = data_diff + abs(secret_array(i) - extract_data_array(i));
end
data_diff
% recovery
pixel_diff = 0;
for i = 1 : height
    for j = 1 : width
        pixel_diff = pixel_diff + (abs(img(i,j) - recover_img(i,j)));
    end
end
pixel_diff 

%----------(mse)-------------
stego_img1_MSE = MSE(img, stego_img1);
stego_img2_MSE = MSE(img, stego_img2);
stego_img1_MSE
stego_img2_MSE
%----------(PSNR)-------------
stego_img1_PSNR = PSNR(stego_img1_MSE);
stego_img2_PSNR = PSNR(stego_img2_MSE);
stego_img1_PSNR
stego_img2_PSNR




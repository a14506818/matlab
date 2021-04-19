function [PSNR MSE]= clacImage(Stego_image,image)
dif = 0.0;
MSE = 0.0;
[height width] = size(Stego_image);
for y=1:height
    for x=1:width  
        dif = double(Stego_image(y,x))-double(image(y,x));
        MSE=MSE+dif*dif;
    end
end

MSE = MSE/(width*height);
PSNR = 10*log10(255*255/MSE);

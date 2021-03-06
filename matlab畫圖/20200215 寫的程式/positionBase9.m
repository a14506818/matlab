function [ backPsnr ] = positionBase9( cover_img_path, maxbpp )

% cover_img_path = '..\images\lena.tif';
cover_img_path = [ 'images\'  cover_img_path '512x512.tif'];
cover=imread(cover_img_path);
% maxbpp = 1;

[height, width] = size(cover);
for i = 1 : height
    for j = 1 : width
        img(i,j) = double(cover(i,j));
    end
end

backPsnr = zeros(20,2); 
PSNR_array = [];
bpp_array = [];
for x = 1 : 20
    bpp = maxbpp/20 * x;

    % make data
    secret_array_b9 = [];
    capacity = 0;
    max_capacity = bpp * height * width * 2;

    while capacity < max_capacity
        temp_b10 = 100;
        while temp_b10 > 80
            temp_b10 = randi(128) - 1;
        end 
        capacity = capacity + 6;
        if temp_b10 > 63
            capacity = capacity + 1;
        end
        temp_bitset_b9 = [floor(temp_b10 / 9), mod(temp_b10,9)];
        secret_array_b9 = [secret_array_b9 , temp_bitset_b9];
    end
    % secret_array_b9 = [8,8];

    % embedding
    secret_array_b9_index = 0;
    for i = 1 : height
        for j = 1 : 2 : width
            if secret_array_b9_index < length(secret_array_b9)
                secret_array_b9_index = secret_array_b9_index + 1;
                w1 = secret_array_b9(1,secret_array_b9_index);
                secret_array_b9_index = secret_array_b9_index + 1;
                w2 = secret_array_b9(1,secret_array_b9_index);
            else
                stego_img1(i, j)  = img(i, j);
                stego_img1(i, j+1)  = img(i, j+1);
                stego_img2(i, j)  = img(i, j);            
                stego_img2(i, j+1)  = img(i, j+1);
                continue
            end        

            switch w1
                case 0
                    stego_img1(i, j)  = img(i, j);
                    stego_img1(i, j+1)  = img(i, j+1);
                    switch w2
                        case 0
                            stego_img2(i, j)  = img(i, j);
                            stego_img2(i, j+1)  = img(i, j+1);
                        case 1
                            stego_img2(i, j)  = img(i, j) - 1;
                            stego_img2(i, j+1)  = img(i, j+1) - 1;
                        case 2
                            stego_img2(i, j)  = img(i, j) - 1;
                            stego_img2(i, j+1)  = img(i, j+1) + 1;
                        case 3
                            stego_img2(i, j)  = img(i, j) + 1;
                            stego_img2(i, j+1)  = img(i, j+1) + 1;
                        case 4
                            stego_img2(i, j)  = img(i, j) + 1;
                            stego_img2(i, j+1)  = img(i, j+1) - 1;
                        case 5
                            stego_img2(i, j)  = img(i, j) - 2;
                            stego_img2(i, j+1)  = img(i, j+1) - 2;
                        case 6
                            stego_img2(i, j)  = img(i, j) - 2;
                            stego_img2(i, j+1)  = img(i, j+1) + 2;
                        case 7
                            stego_img2(i, j)  = img(i, j) + 2;
                            stego_img2(i, j+1)  = img(i, j+1) + 2;
                        case 8
                            stego_img2(i, j)  = img(i, j) + 2;
                            stego_img2(i, j+1)  = img(i, j+1) - 2;
                    end
                case 1
                    stego_img1(i, j)  = img(i, j) - 1;
                    stego_img1(i, j+1)  = img(i, j+1) - 1;
                    switch w2
                        case 0
                            stego_img2(i, j)  = img(i, j) - 1;
                            stego_img2(i, j+1)  = img(i, j+1);
                        case 1
                            stego_img2(i, j)  = img(i, j) - 1;
                            stego_img2(i, j+1)  = img(i, j+1) + 2;
                        case 2
                            stego_img2(i, j)  = img(i, j);
                            stego_img2(i, j+1)  = img(i, j+1) + 1;
                        case 3
                            stego_img2(i, j)  = img(i, j) + 1;
                            stego_img2(i, j+1)  = img(i, j+1);
                        case 4
                            stego_img2(i, j)  = img(i, j) + 1;
                            stego_img2(i, j+1)  = img(i, j+1) - 1;
                        case 5
                            stego_img2(i, j)  = img(i, j)  + 2;
                            stego_img2(i, j+1)  = img(i, j+1)  + 2;
                        case 6
                            stego_img2(i, j)  = img(i, j) + 2;
                            stego_img2(i, j+1)  = img(i, j+1) + 1;
                        case 7
                            stego_img2(i, j)  = img(i, j) + 2;
                            stego_img2(i, j+1)  = img(i, j+1);
                        case 8
                            stego_img2(i, j)  = img(i, j) + 2;
                            stego_img2(i, j+1)  = img(i, j+1) - 2;
                    end
                case 2
                    stego_img1(i, j)  = img(i, j) - 1;
                    stego_img1(i, j+1)  = img(i, j+1) + 1;
                    switch w2
                        case 0
                            stego_img2(i, j)  = img(i, j);
                            stego_img2(i, j+1)  = img(i, j+1) + 1;
                        case 1
                            stego_img2(i, j)  = img(i, j) + 2;
                            stego_img2(i, j+1)  = img(i, j+1) + 1;
                        case 2
                            stego_img2(i, j)  = img(i, j) + 1;
                            stego_img2(i, j+1)  = img(i, j+1);
                        case 3
                            stego_img2(i, j)  = img(i, j);
                            stego_img2(i, j+1)  = img(i, j+1) - 1;
                        case 4
                            stego_img2(i, j)  = img(i, j) - 1;
                            stego_img2(i, j+1)  = img(i, j+1) - 1;
                        case 5
                            stego_img2(i, j)  = img(i, j) + 2;
                            stego_img2(i, j+1)  = img(i, j+1) - 2;
                        case 6
                            stego_img2(i, j)  = img(i, j) + 1;
                            stego_img2(i, j+1)  = img(i, j+1) - 2;
                        case 7
                            stego_img2(i, j)  = img(i, j);
                            stego_img2(i, j+1)  = img(i, j+1) - 2;
                        case 8
                            stego_img2(i, j)  = img(i, j) - 2;
                            stego_img2(i, j+1)  = img(i, j+1) - 2;
                    end
                case 3
                    stego_img1(i, j)  = img(i, j) + 1;
                    stego_img1(i, j+1)  = img(i, j+1) + 1;
                    switch w2
                        case 0
                            stego_img2(i, j)  = img(i, j) + 1;
                            stego_img2(i, j+1)  = img(i, j+1);
                        case 1
                            stego_img2(i, j)  = img(i, j) + 1;
                            stego_img2(i, j+1)  = img(i, j+1) - 2;
                        case 2
                            stego_img2(i, j)  = img(i, j);
                            stego_img2(i, j+1)  = img(i, j+1) - 1;
                        case 3
                            stego_img2(i, j)  = img(i, j) - 1;
                            stego_img2(i, j+1)  = img(i, j+1);
                        case 4
                            stego_img2(i, j)  = img(i, j) - 1;
                            stego_img2(i, j+1)  = img(i, j+1) + 1;
                        case 5
                            stego_img2(i, j)  = img(i, j) - 2;
                            stego_img2(i, j+1)  = img(i, j+1) - 2;
                        case 6
                            stego_img2(i, j)  = img(i, j) - 2;
                            stego_img2(i, j+1)  = img(i, j+1) - 1;
                        case 7
                            stego_img2(i, j)  = img(i, j) - 2;
                            stego_img2(i, j+1)  = img(i, j+1);
                        case 8
                            stego_img2(i, j)  = img(i, j) - 2;
                            stego_img2(i, j+1)  = img(i, j+1) + 2;
                    end
                case 4
                    stego_img1(i, j)  = img(i, j) + 1;
                    stego_img1(i, j+1)  = img(i, j+1) - 1;
                    switch w2
                        case 0
                            stego_img2(i, j)  = img(i, j);
                            stego_img2(i, j+1)  = img(i, j+1) - 1;
                        case 1
                            stego_img2(i, j)  = img(i, j) - 2;
                            stego_img2(i, j+1)  = img(i, j+1) - 1;
                        case 2
                            stego_img2(i, j)  = img(i, j) - 1;
                            stego_img2(i, j+1)  = img(i, j+1);
                        case 3
                            stego_img2(i, j)  = img(i, j);
                            stego_img2(i, j+1)  = img(i, j+1) + 1;
                        case 4
                            stego_img2(i, j)  = img(i, j) + 1;
                            stego_img2(i, j+1)  = img(i, j+1) + 1;
                        case 5
                            stego_img2(i, j)  = img(i, j) - 2;
                            stego_img2(i, j+1)  = img(i, j+1) + 2;
                        case 6
                            stego_img2(i, j)  = img(i, j) - 1;
                            stego_img2(i, j+1)  = img(i, j+1) + 2;
                        case 7
                            stego_img2(i, j)  = img(i, j);
                            stego_img2(i, j+1)  = img(i, j+1) + 2;
                        case 8
                            stego_img2(i, j)  = img(i, j) + 2;
                            stego_img2(i, j+1)  = img(i, j+1) + 2;
                    end
                case 5
                    stego_img1(i, j)  = img(i, j) - 2;
                    stego_img1(i, j+1)  = img(i, j+1) - 2;
                    switch w2
                        case 0
                            stego_img2(i, j)  = img(i, j);
                            stego_img2(i, j+1)  = img(i, j+1) + 1;
                        case 1
                            stego_img2(i, j)  = img(i, j) - 2;
                            stego_img2(i, j+1)  = img(i, j+1) + 2;
                        case 2
                            stego_img2(i, j)  = img(i, j) - 1;
                            stego_img2(i, j+1)  = img(i, j+1) + 2;
                        case 3
                            stego_img2(i, j)  = img(i, j);
                            stego_img2(i, j+1)  = img(i, j+1) + 2;
                        case 4
                            stego_img2(i, j)  = img(i, j) + 1;
                            stego_img2(i, j+1)  = img(i, j+1) + 2;
                        case 5
                            stego_img2(i, j)  = img(i, j) + 2;
                            stego_img2(i, j+1)  = img(i, j+1) + 2;
                        case 6
                            stego_img2(i, j)  = img(i, j) + 2;
                            stego_img2(i, j+1)  = img(i, j+1) + 1;
                        case 7
                            stego_img2(i, j)  = img(i, j) + 2;
                            stego_img2(i, j+1)  = img(i, j+1);
                        case 8
                            stego_img2(i, j)  = img(i, j) + 2;
                            stego_img2(i, j+1)  = img(i, j+1) - 1;
                    end
                case 6
                    stego_img1(i, j)  = img(i, j) - 2;
                    stego_img1(i, j+1)  = img(i, j+1) + 2;
                    switch w2
                        case 0
                            stego_img2(i, j)  = img(i, j) + 1;
                            stego_img2(i, j+1)  = img(i, j+1);
                        case 1
                            stego_img2(i, j)  = img(i, j) + 2;
                            stego_img2(i, j+1)  = img(i, j+1) + 2;
                        case 2
                            stego_img2(i, j)  = img(i, j) + 2;
                            stego_img2(i, j+1)  = img(i, j+1) + 1;
                        case 3
                            stego_img2(i, j)  = img(i, j) + 2;
                            stego_img2(i, j+1)  = img(i, j+1);
                        case 4
                            stego_img2(i, j)  = img(i, j) + 2;
                            stego_img2(i, j+1)  = img(i, j+1) - 1;
                        case 5
                            stego_img2(i, j)  = img(i, j) + 2;
                            stego_img2(i, j+1)  = img(i, j+1) - 2;
                        case 6
                            stego_img2(i, j)  = img(i, j) + 1;
                            stego_img2(i, j+1)  = img(i, j+1) - 2;
                        case 7
                            stego_img2(i, j)  = img(i, j);
                            stego_img2(i, j+1)  = img(i, j+1) - 2;
                        case 8
                            stego_img2(i, j)  = img(i, j) - 1;
                            stego_img2(i, j+1)  = img(i, j+1) - 2;
                    end
                case 7
                    stego_img1(i, j)  = img(i, j) + 2;
                    stego_img1(i, j+1)  = img(i, j+1) + 2;
                    switch w2
                        case 0
                            stego_img2(i, j)  = img(i, j);
                            stego_img2(i, j+1)  = img(i, j+1) - 1;
                        case 1
                            stego_img2(i, j)  = img(i, j) + 2;
                            stego_img2(i, j+1)  = img(i, j+1) - 2;
                        case 2
                            stego_img2(i, j)  = img(i, j) + 1;
                            stego_img2(i, j+1)  = img(i, j+1) - 2;
                        case 3
                            stego_img2(i, j)  = img(i, j);
                            stego_img2(i, j+1)  = img(i, j+1) - 2;
                        case 4
                            stego_img2(i, j)  = img(i, j) - 1;
                            stego_img2(i, j+1)  = img(i, j+1) - 2;
                        case 5
                            stego_img2(i, j)  = img(i, j) - 2;
                            stego_img2(i, j+1)  = img(i, j+1) - 2;
                        case 6
                            stego_img2(i, j)  = img(i, j) - 2;
                            stego_img2(i, j+1)  = img(i, j+1) - 1;
                        case 7
                            stego_img2(i, j)  = img(i, j) - 2;
                            stego_img2(i, j+1)  = img(i, j+1);
                        case 8
                            stego_img2(i, j)  = img(i, j) - 2;
                            stego_img2(i, j+1)  = img(i, j+1) + 1;
                    end
                case 8
                    stego_img1(i, j)  = img(i, j) + 2;
                    stego_img1(i, j+1)  = img(i, j+1) - 2;
                    switch w2
                        case 0
                            stego_img2(i, j)  = img(i, j) - 1;
                            stego_img2(i, j+1)  = img(i, j+1);
                        case 1
                            stego_img2(i, j)  = img(i, j) - 2;
                            stego_img2(i, j+1)  = img(i, j+1) - 2;
                        case 2
                            stego_img2(i, j)  = img(i, j) - 2;
                            stego_img2(i, j+1)  = img(i, j+1) - 1;
                        case 3
                            stego_img2(i, j)  = img(i, j) - 2;
                            stego_img2(i, j+1)  = img(i, j+1);
                        case 4
                            stego_img2(i, j)  = img(i, j) - 2;
                            stego_img2(i, j+1)  = img(i, j+1) + 1;
                        case 5
                            stego_img2(i, j)  = img(i, j) - 2;
                            stego_img2(i, j+1)  = img(i, j+1) + 2;
                        case 6
                            stego_img2(i, j)  = img(i, j) - 1;
                            stego_img2(i, j+1)  = img(i, j+1) + 2;
                        case 7
                            stego_img2(i, j)  = img(i, j);
                            stego_img2(i, j+1)  = img(i, j+1) + 2;
                        case 8
                            stego_img2(i, j)  = img(i, j) + 1;
                            stego_img2(i, j+1)  = img(i, j+1) + 2;
                    end
            end
            % over/underflow
            if stego_img1(i, j) > 255 || stego_img2(i, j) > 255
                stego_img1(i, j)  = img(i, j);
                stego_img1(i, j+1)  = img(i, j+1);
                stego_img2(i, j)  = img(i, j) - 5;
                stego_img2(i, j+1)  = img(i, j+1);
            end
            if stego_img1(i, j+1) > 255 || stego_img2(i, j+1) > 255
                stego_img1(i, j)  = img(i, j);
                stego_img1(i, j+1)  = img(i, j+1);
                stego_img2(i, j)  = img(i, j);
                stego_img2(i, j+1)  = img(i, j+1) - 5;
            end
            if stego_img1(i, j) < 0 || stego_img2(i, j) < 0
                stego_img1(i, j)  = img(i, j) + 5;
                stego_img1(i, j+1)  = img(i, j+1);
                stego_img2(i, j)  = img(i, j);
                stego_img2(i, j+1)  = img(i, j+1);
            end
            if stego_img1(i, j+1) < 0 || stego_img2(i, j+1) < 0
                stego_img1(i, j)  = img(i, j);
                stego_img1(i, j+1)  = img(i, j+1) + 5;
                stego_img2(i, j)  = img(i, j);
                stego_img2(i, j+1)  = img(i, j+1);
            end
        end
    end

    % extracting, recovery
    extract_secret_array_b9 = [];
    for i = 1 : height
        for j = 1 : 2 : width
            dx = stego_img1(i, j) - stego_img2(i, j);
            dy = stego_img1(i, j+1) - stego_img2(i, j+1);

            switch dx
                case -4
                    switch dy
                        case -4
                            extract_secret_array_b9(end+1) = 5;
                            extract_secret_array_b9(end+1) = 5;
                            recover_img(i,j) = stego_img1(i, j)+2;
                            recover_img(i,j+1) = stego_img1(i, j+1)+2;
                        case -3
                            extract_secret_array_b9(end+1) = 5;
                            extract_secret_array_b9(end+1) = 6;
                            recover_img(i,j) = stego_img1(i, j)+2;
                            recover_img(i,j+1) = stego_img1(i, j+1)+2;
                        case -2
                            extract_secret_array_b9(end+1) = 5;
                            extract_secret_array_b9(end+1) = 7;
                            recover_img(i,j) = stego_img1(i, j)+2;
                            recover_img(i,j+1) = stego_img1(i, j+1)+2;
                        case -1
                            extract_secret_array_b9(end+1) = 5;
                            extract_secret_array_b9(end+1) = 8;
                            recover_img(i,j) = stego_img1(i, j)+2;
                            recover_img(i,j+1) = stego_img1(i, j+1)+2;
                        case 0
                            extract_secret_array_b9(end+1) = 6;
                            extract_secret_array_b9(end+1) = 1;
                            recover_img(i,j) = stego_img1(i, j)+2;
                            recover_img(i,j+1) = stego_img1(i, j+1)-2;
                        case 1
                            extract_secret_array_b9(end+1) = 6;
                            extract_secret_array_b9(end+1) = 2;
                            recover_img(i,j) = stego_img1(i, j)+2;
                            recover_img(i,j+1) = stego_img1(i, j+1)-2;
                        case 2
                            extract_secret_array_b9(end+1) = 6;
                            extract_secret_array_b9(end+1) = 3;
                            recover_img(i,j) = stego_img1(i, j)+2;
                            recover_img(i,j+1) = stego_img1(i, j+1)-2;
                        case 3
                            extract_secret_array_b9(end+1) = 6;
                            extract_secret_array_b9(end+1) = 4;
                            recover_img(i,j) = stego_img1(i, j)+2;
                            recover_img(i,j+1) = stego_img1(i, j+1)-2;
                        case 4
                            extract_secret_array_b9(end+1) = 6;
                            extract_secret_array_b9(end+1) = 5;
                            recover_img(i,j) = stego_img1(i, j)+2;
                            recover_img(i,j+1) = stego_img1(i, j+1)-2;
                    end
                case -3
                    switch dy
                        case -4
                            extract_secret_array_b9(end+1) = 5;
                            extract_secret_array_b9(end+1) = 4;
                            recover_img(i,j) = stego_img1(i, j)+2;
                            recover_img(i,j+1) = stego_img1(i, j+1)+2;
                        case -3
                            extract_secret_array_b9(end+1) = 1;
                            extract_secret_array_b9(end+1) = 5;
                            recover_img(i,j) = stego_img1(i, j)+1;
                            recover_img(i,j+1) = stego_img1(i, j+1)+1;
                        case -2
                            extract_secret_array_b9(end+1) = 1;
                            extract_secret_array_b9(end+1) = 6;
                            recover_img(i,j) = stego_img1(i, j)+1;
                            recover_img(i,j+1) = stego_img1(i, j+1)+1;
                        case -1
                            extract_secret_array_b9(end+1) = 1;
                            extract_secret_array_b9(end+1) = 7;
                            recover_img(i,j) = stego_img1(i, j)+1;
                            recover_img(i,j+1) = stego_img1(i, j+1)+1;
                        case 0
                            extract_secret_array_b9(end+1) = 2;
                            extract_secret_array_b9(end+1) = 1;
                            recover_img(i,j) = stego_img1(i, j)+1;
                            recover_img(i,j+1) = stego_img1(i, j+1)-1;
                        case 1
                            extract_secret_array_b9(end+1) = 1;
                            extract_secret_array_b9(end+1) = 8;
                            recover_img(i,j) = stego_img1(i, j)+1;
                            recover_img(i,j+1) = stego_img1(i, j+1)+1;
                        case 2
                            extract_secret_array_b9(end+1) = 6;
                            extract_secret_array_b9(end+1) = 0;
                            recover_img(i,j) = stego_img1(i, j)+2;
                            recover_img(i,j+1) = stego_img1(i, j+1)-2;
                        case 3
                            extract_secret_array_b9(end+1) = 2;
                            extract_secret_array_b9(end+1) = 5;
                            recover_img(i,j) = stego_img1(i, j)+1;
                            recover_img(i,j+1) = stego_img1(i, j+1)-1;
                        case 4
                            extract_secret_array_b9(end+1) = 6;
                            extract_secret_array_b9(end+1) = 6;
                            recover_img(i,j) = stego_img1(i, j)+2;
                            recover_img(i,j+1) = stego_img1(i, j+1)-2;
                    end
                case -2
                    switch dy
                        case -4
                            extract_secret_array_b9(end+1) = 5;
                            extract_secret_array_b9(end+1) = 3;
                            recover_img(i,j) = stego_img1(i, j)+2;
                            recover_img(i,j+1) = stego_img1(i, j+1)+2;
                        case -3
                            extract_secret_array_b9(end+1) = 5;
                            extract_secret_array_b9(end+1) = 0;
                            recover_img(i,j) = stego_img1(i, j)+2;
                            recover_img(i,j+1) = stego_img1(i, j+1)+2;
                        case -2
                            extract_secret_array_b9(end+1) = 0;
                            extract_secret_array_b9(end+1) = 7;
                            recover_img(i,j) = stego_img1(i, j);
                            recover_img(i,j+1) = stego_img1(i, j+1);
                        case -1
                            extract_secret_array_b9(end+1) = 1;
                            extract_secret_array_b9(end+1) = 3;
                            recover_img(i,j) = stego_img1(i, j)+1;
                            recover_img(i,j+1) = stego_img1(i, j+1)+1;
                        case 0
                            extract_secret_array_b9(end+1) = 1;
                            extract_secret_array_b9(end+1) = 4;
                            recover_img(i,j) = stego_img1(i, j)+1;
                            recover_img(i,j+1) = stego_img1(i, j+1)+1;
                        case 1
                            extract_secret_array_b9(end+1) = 2;
                            extract_secret_array_b9(end+1) = 2;
                            recover_img(i,j) = stego_img1(i, j)+1;
                            recover_img(i,j+1) = stego_img1(i, j+1)-1;
                        case 2
                            extract_secret_array_b9(end+1) = 0;
                            extract_secret_array_b9(end+1) = 8;
                            recover_img(i,j) = stego_img1(i, j);
                            recover_img(i,j+1) = stego_img1(i, j+1);
                        case 3
                            extract_secret_array_b9(end+1) = 2;
                            extract_secret_array_b9(end+1) = 6;
                            recover_img(i,j) = stego_img1(i, j)+1;
                            recover_img(i,j+1) = stego_img1(i, j+1)-1;
                        case 4
                            extract_secret_array_b9(end+1) = 6;
                            extract_secret_array_b9(end+1) = 7;
                            recover_img(i,j) = stego_img1(i, j)+2;
                            recover_img(i,j+1) = stego_img1(i, j+1)-2;
                    end
                case -1
                    switch dy
                        case -4
                            extract_secret_array_b9(end+1) = 5;
                            extract_secret_array_b9(end+1) = 2;
                            recover_img(i,j) = stego_img1(i, j)+2;
                            recover_img(i,j+1) = stego_img1(i, j+1)+2;
                        case -3
                            extract_secret_array_b9(end+1) = 4;
                            extract_secret_array_b9(end+1) = 8;
                            recover_img(i,j) = stego_img1(i, j)-1;
                            recover_img(i,j+1) = stego_img1(i, j+1)+1;
                        case -2
                            extract_secret_array_b9(end+1) = 1;
                            extract_secret_array_b9(end+1) = 2;
                            recover_img(i,j) = stego_img1(i, j)+1;
                            recover_img(i,j+1) = stego_img1(i, j+1)+1;
                        case -1
                            extract_secret_array_b9(end+1) = 0;
                            extract_secret_array_b9(end+1) = 3;
                            recover_img(i,j) = stego_img1(i, j);
                            recover_img(i,j+1) = stego_img1(i, j+1);
                        case 0
                            extract_secret_array_b9(end+1) = 2;
                            extract_secret_array_b9(end+1) = 0;
                            recover_img(i,j) = stego_img1(i, j)+1;
                            recover_img(i,j+1) = stego_img1(i, j+1)-1;
                        case 1
                            extract_secret_array_b9(end+1) = 0;
                            extract_secret_array_b9(end+1) = 4;
                            recover_img(i,j) = stego_img1(i, j);
                            recover_img(i,j+1) = stego_img1(i, j+1);
                        case 2
                            extract_secret_array_b9(end+1) = 2;
                            extract_secret_array_b9(end+1) = 3;
                            recover_img(i,j) = stego_img1(i, j)+1;
                            recover_img(i,j+1) = stego_img1(i, j+1)-1;
                        case 3
                            extract_secret_array_b9(end+1) = 2;
                            extract_secret_array_b9(end+1) = 7;
                            recover_img(i,j) = stego_img1(i, j)+1;
                            recover_img(i,j+1) = stego_img1(i, j+1)-1;
                        case 4
                            extract_secret_array_b9(end+1) = 6;
                            extract_secret_array_b9(end+1) = 8;
                            recover_img(i,j) = stego_img1(i, j)+2;
                            recover_img(i,j+1) = stego_img1(i, j+1)-2;
                    end
                case 0
                    switch dy
                        case -4
                            extract_secret_array_b9(end+1) = 5;
                            extract_secret_array_b9(end+1) = 1;
                            recover_img(i,j) = stego_img1(i, j)+2;
                            recover_img(i,j+1) = stego_img1(i, j+1)+2;
                        case -3
                            extract_secret_array_b9(end+1) = 1;
                            extract_secret_array_b9(end+1) = 1;
                            recover_img(i,j) = stego_img1(i, j)+1;
                            recover_img(i,j+1) = stego_img1(i, j+1)+1;
                        case -2
                            extract_secret_array_b9(end+1) = 4;
                            extract_secret_array_b9(end+1) = 4;
                            recover_img(i,j) = stego_img1(i, j)-1;
                            recover_img(i,j+1) = stego_img1(i, j+1)+1;
                        case -1
                            extract_secret_array_b9(end+1) = 1;
                            extract_secret_array_b9(end+1) = 0;
                            recover_img(i,j) = stego_img1(i, j)+1;
                            recover_img(i,j+1) = stego_img1(i, j+1)+1;
                        case 0
                            extract_secret_array_b9(end+1) = 0;
                            extract_secret_array_b9(end+1) = 0;
                            recover_img(i,j) = stego_img1(i, j);
                            recover_img(i,j+1) = stego_img1(i, j+1);
                        case 1
                            extract_secret_array_b9(end+1) = 3;
                            extract_secret_array_b9(end+1) = 0;
                            recover_img(i,j) = stego_img1(i, j)-1;
                            recover_img(i,j+1) = stego_img1(i, j+1)-1;
                        case 2
                            extract_secret_array_b9(end+1) = 2;
                            extract_secret_array_b9(end+1) = 4;
                            recover_img(i,j) = stego_img1(i, j)+1;
                            recover_img(i,j+1) = stego_img1(i, j+1)-1;
                        case 3
                            extract_secret_array_b9(end+1) = 3;
                            extract_secret_array_b9(end+1) = 1;
                            recover_img(i,j) = stego_img1(i, j)-1;
                            recover_img(i,j+1) = stego_img1(i, j+1)-1;
                        case 4
                            extract_secret_array_b9(end+1) = 7;
                            extract_secret_array_b9(end+1) = 1;
                            recover_img(i,j) = stego_img1(i, j)-2;
                            recover_img(i,j+1) = stego_img1(i, j+1)-2;
                    end
                case 1
                    switch dy
                        case -4
                            extract_secret_array_b9(end+1) = 8;
                            extract_secret_array_b9(end+1) = 8;
                            recover_img(i,j) = stego_img1(i, j)-2;
                            recover_img(i,j+1) = stego_img1(i, j+1)+2;
                        case -3
                            extract_secret_array_b9(end+1) = 4;
                            extract_secret_array_b9(end+1) = 7;
                            recover_img(i,j) = stego_img1(i, j)-1;
                            recover_img(i,j+1) = stego_img1(i, j+1)+1;
                        case -2
                            extract_secret_array_b9(end+1) = 4;
                            extract_secret_array_b9(end+1) = 3;
                            recover_img(i,j) = stego_img1(i, j)-1;
                            recover_img(i,j+1) = stego_img1(i, j+1)+1;
                        case -1
                            extract_secret_array_b9(end+1) = 0;
                            extract_secret_array_b9(end+1) = 2;
                            recover_img(i,j) = stego_img1(i, j);
                            recover_img(i,j+1) = stego_img1(i, j+1);
                        case 0
                            extract_secret_array_b9(end+1) = 4;
                            extract_secret_array_b9(end+1) = 0;
                            recover_img(i,j) = stego_img1(i, j)-1;
                            recover_img(i,j+1) = stego_img1(i, j+1)+1;
                        case 1
                            extract_secret_array_b9(end+1) = 0;
                            extract_secret_array_b9(end+1) = 1;
                            recover_img(i,j) = stego_img1(i, j);
                            recover_img(i,j+1) = stego_img1(i, j+1);
                        case 2
                            extract_secret_array_b9(end+1) = 3;
                            extract_secret_array_b9(end+1) = 2;
                            recover_img(i,j) = stego_img1(i, j)-1;
                            recover_img(i,j+1) = stego_img1(i, j+1)-1;
                        case 3
                            extract_secret_array_b9(end+1) = 2;
                            extract_secret_array_b9(end+1) = 8;
                            recover_img(i,j) = stego_img1(i, j)+1;
                            recover_img(i,j+1) = stego_img1(i, j+1)-1;
                        case 4
                            extract_secret_array_b9(end+1) = 7;
                            extract_secret_array_b9(end+1) = 2;
                            recover_img(i,j) = stego_img1(i, j)-2;
                            recover_img(i,j+1) = stego_img1(i, j+1)-2;
                    end
                case 2
                    switch dy
                        case -4
                            extract_secret_array_b9(end+1) = 8;
                            extract_secret_array_b9(end+1) = 7;
                            recover_img(i,j) = stego_img1(i, j)-2;
                            recover_img(i,j+1) = stego_img1(i, j+1)+2;
                        case -3
                            extract_secret_array_b9(end+1) = 4;
                            extract_secret_array_b9(end+1) = 6;
                            recover_img(i,j) = stego_img1(i, j)-1;
                            recover_img(i,j+1) = stego_img1(i, j+1)+1;
                        case -2
                            extract_secret_array_b9(end+1) = 0;
                            extract_secret_array_b9(end+1) = 6;
                            recover_img(i,j) = stego_img1(i, j);
                            recover_img(i,j+1) = stego_img1(i, j+1);
                        case -1
                            extract_secret_array_b9(end+1) = 4;
                            extract_secret_array_b9(end+1) = 2;
                            recover_img(i,j) = stego_img1(i, j)-1;
                            recover_img(i,j+1) = stego_img1(i, j+1)+1;
                        case 0
                            extract_secret_array_b9(end+1) = 3;
                            extract_secret_array_b9(end+1) = 4;
                            recover_img(i,j) = stego_img1(i, j)-1;
                            recover_img(i,j+1) = stego_img1(i, j+1)-1;
                        case 1
                            extract_secret_array_b9(end+1) = 3;
                            extract_secret_array_b9(end+1) = 3;
                            recover_img(i,j) = stego_img1(i, j)-1;
                            recover_img(i,j+1) = stego_img1(i, j+1)-1;
                        case 2
                            extract_secret_array_b9(end+1) = 0;
                            extract_secret_array_b9(end+1) = 5;
                            recover_img(i,j) = stego_img1(i, j);
                            recover_img(i,j+1) = stego_img1(i, j+1);
                        case 3
                            extract_secret_array_b9(end+1) = 7;
                            extract_secret_array_b9(end+1) = 0;
                            recover_img(i,j) = stego_img1(i, j)-2;
                            recover_img(i,j+1) = stego_img1(i, j+1)-2;
                        case 4
                            extract_secret_array_b9(end+1) = 7;
                            extract_secret_array_b9(end+1) = 3;
                            recover_img(i,j) = stego_img1(i, j)-2;
                            recover_img(i,j+1) = stego_img1(i, j+1)-2;
                    end
                case 3
                    switch dy
                        case -4
                            extract_secret_array_b9(end+1) = 8;
                            extract_secret_array_b9(end+1) = 6;
                            recover_img(i,j) = stego_img1(i, j)-2;
                            recover_img(i,j+1) = stego_img1(i, j+1)+2;
                        case -3
                            extract_secret_array_b9(end+1) = 4;
                            extract_secret_array_b9(end+1) = 5;
                            recover_img(i,j) = stego_img1(i, j)-1;
                            recover_img(i,j+1) = stego_img1(i, j+1)+1;
                        case -2
                            extract_secret_array_b9(end+1) = 8;
                            extract_secret_array_b9(end+1) = 0;
                            recover_img(i,j) = stego_img1(i, j)-2;
                            recover_img(i,j+1) = stego_img1(i, j+1)+2;
                        case -1
                            extract_secret_array_b9(end+1) = 3;
                            extract_secret_array_b9(end+1) = 8;
                            recover_img(i,j) = stego_img1(i, j)-1;
                            recover_img(i,j+1) = stego_img1(i, j+1)-1;
                        case 0
                            extract_secret_array_b9(end+1) = 4;
                            extract_secret_array_b9(end+1) = 1;
                            recover_img(i,j) = stego_img1(i, j)-1;
                            recover_img(i,j+1) = stego_img1(i, j+1)+1;
                        case 1
                            extract_secret_array_b9(end+1) = 3;
                            extract_secret_array_b9(end+1) = 7;
                            recover_img(i,j) = stego_img1(i, j)-1;
                            recover_img(i,j+1) = stego_img1(i, j+1)-1;
                        case 2
                            extract_secret_array_b9(end+1) = 3;
                            extract_secret_array_b9(end+1) = 6;
                            recover_img(i,j) = stego_img1(i, j)-1;
                            recover_img(i,j+1) = stego_img1(i, j+1)-1;
                        case 3
                            extract_secret_array_b9(end+1) = 3;
                            extract_secret_array_b9(end+1) = 5;
                            recover_img(i,j) = stego_img1(i, j)-1;
                            recover_img(i,j+1) = stego_img1(i, j+1)-1;
                        case 4
                            extract_secret_array_b9(end+1) = 7;
                            extract_secret_array_b9(end+1) = 4;
                            recover_img(i,j) = stego_img1(i, j)-2;
                            recover_img(i,j+1) = stego_img1(i, j+1)-2;
                    end
                case 4
                    switch dy
                        case -4
                            extract_secret_array_b9(end+1) = 8;
                            extract_secret_array_b9(end+1) = 5;
                            recover_img(i,j) = stego_img1(i, j)-2;
                            recover_img(i,j+1) = stego_img1(i, j+1)+2;
                        case -3
                            extract_secret_array_b9(end+1) = 8;
                            extract_secret_array_b9(end+1) = 4;
                            recover_img(i,j) = stego_img1(i, j)-2;
                            recover_img(i,j+1) = stego_img1(i, j+1)+2;
                        case -2
                            extract_secret_array_b9(end+1) = 8;
                            extract_secret_array_b9(end+1) = 3;
                            recover_img(i,j) = stego_img1(i, j)-2;
                            recover_img(i,j+1) = stego_img1(i, j+1)+2;
                        case -1
                            extract_secret_array_b9(end+1) = 8;
                            extract_secret_array_b9(end+1) = 2;
                            recover_img(i,j) = stego_img1(i, j)-2;
                            recover_img(i,j+1) = stego_img1(i, j+1)+2;
                        case 0
                            extract_secret_array_b9(end+1) = 8;
                            extract_secret_array_b9(end+1) = 1;
                            recover_img(i,j) = stego_img1(i, j)-2;
                            recover_img(i,j+1) = stego_img1(i, j+1)+2;
                        case 1
                            extract_secret_array_b9(end+1) = 7;
                            extract_secret_array_b9(end+1) = 8;
                            recover_img(i,j) = stego_img1(i, j)-2;
                            recover_img(i,j+1) = stego_img1(i, j+1)-2;
                        case 2
                            extract_secret_array_b9(end+1) = 7;
                            extract_secret_array_b9(end+1) = 7;
                            recover_img(i,j) = stego_img1(i, j)-2;
                            recover_img(i,j+1) = stego_img1(i, j+1)-2;
                        case 3
                            extract_secret_array_b9(end+1) = 7;
                            extract_secret_array_b9(end+1) = 6;
                            recover_img(i,j) = stego_img1(i, j)-2;
                            recover_img(i,j+1) = stego_img1(i, j+1)-2;
                        case 4
                            extract_secret_array_b9(end+1) = 7;
                            extract_secret_array_b9(end+1) = 5;
                            recover_img(i,j) = stego_img1(i, j)-2;
                            recover_img(i,j+1) = stego_img1(i, j+1)-2;
                    end
            end
        end
    end

    % testing
    % extracting - b9
    data_diff_b9 = 0;
    temp_b10 = 0;
%     binStr = '';
%     extract_data_array_b2 = [];
    binStr_len = 0;
    for i = 1 : min(length(secret_array_b9), length(extract_secret_array_b9))
        data_diff_b9 = data_diff_b9 + abs(secret_array_b9(i) - extract_secret_array_b9(i));
        % b9 to b2 string
        if mod(i,2) == 1
            temp_b10 = temp_b10 + extract_secret_array_b9(i) * 9;
        else
            temp_b10 = temp_b10 + extract_secret_array_b9(i);
    %             binStr = binStr + string(dec2bin(temp_b10,6));
            binStr_len =  binStr_len + length(dec2bin(temp_b10,6));
            temp_b10 = 0;
        end
    end
    data_diff_b9

    % recovery
    pixel_diff = 0;
    for i = 1 : height
        for j = 1 : width
            pixel_diff = pixel_diff + (abs(img(i,j) - recover_img(i,j)));
        end
    end
    pixel_diff

    %----------(mse)-------------
    MSE1 = 0;
    MSE2 = 0;
    for i = 1 : height
        for j = 1 : width
            MSE1 = MSE1 + abs(img(i,j) - stego_img1(i,j))^2;
            MSE2 = MSE2 + abs(img(i,j) - stego_img2(i,j))^2;
        end
    end
    MSE1 = MSE1/(height*width);
    MSE2 = MSE2/(height*width);
    PSNR1 = 10 * log10(255^2 / MSE1);
    PSNR2 = 10 * log10(255^2 / MSE2);

    PSNR_avg = (PSNR1 + PSNR2) / 2;

    bpp = binStr_len / (height*width*2);

    PSNR_array = [PSNR_array, PSNR_avg];
    bpp_array = [bpp_array, bpp];
end

for i = 1:length(PSNR_array) 
    backPsnr (i,2) = PSNR_array (i); 
    backPsnr (i,1) = bpp_array (i); 
end
backPsnr

       


end


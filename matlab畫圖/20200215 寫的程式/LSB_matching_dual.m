function [PSNRs1] =  LSB_matching_dual (f_attack, f_secret, f_n, file_path, secret_array, isColorImage, file_experiment,  bpp_S, isRSAttack, total_secret)

 
tic;
Time=0;
 count = 0; 
fid= fopen(file_experiment, 'a+');
fid_att= fopen(f_attack, 'a+');

% file_path='C:\image\TIF\TIF\Mandrill512x512.tif';


bouts=1;
Squared = 8;

if isColorImage == 1 %彩色影像
   cover=imread(file_path); %原始影像
   Gray=rgb2gray(cover); 
else
   Gray=imread(file_path); %原始影像
end


image = Gray;
image_stego1 = image;
image_stego2 = image;
[height width] = size(image);
Cap=0;
errorcount=0;
error_index=1;

m1=round(rand());
m2=round(rand());
m3=round(rand());
m4=round(rand());

A1_variable=0.0;
B1_variable=0.0;
A2_variable=0.0;
B2_variable=0.0;
error_count=0.0;

bpp_PSNRs=bpp_S;
Cap_goal = ceil(bpp_PSNRs*height*width);
PSNRs=zeros(20,2);
PSNROriginals=zeros(20,2);
index_PSNRs=1;  

str='';
count = 0 ; 
for y=1:height
    for x=1:2:width
        hiding=0;
        A1_variable=0.0;
        B1_variable=0.0;
        A2_variable=0.0;
        B2_variable=0.0;
        A=zeros(2,1);
        B=zeros(2,1);
        A(1)=double(image_stego1(y,x));
        A(2)=double(image_stego2(y,x));
        B(1)=double(image_stego1(y,x+1));
        B(2)=double(image_stego2(y,x+1));
        
        if (A(1) == 0 | A(1) == 255 | A(2) == 0 | A(2) == 255 | B(1) == 0 | B(1) == 255 | B(2) == 0 | B(2) == 255)
            if double(image(y,x))+4 <= 255
                image_stego1(y,x)=image_stego1(y,x)+4;
            elseif double(image(y,x))+4 > 255
                image_stego1(y,x)=image_stego1(y,x)-4;
            end
            
            continue;
        end
        
        
        if rem(A(1),2) == m1
            if F_LSBmatching(A(1),B(1)) ~= m2
                B(1)=B(1)+1;
                B1_variable=1;
            end
        else
            if F_LSBmatching(A(1)-1,B(1)) == m2
                A(1)=A(1)-1;
                A1_variable=-1;
            else
                A(1)=A(1)+1;
                A1_variable=1;
            end
        end
        
        if rem(A(2),2) == m3
            if F_LSBmatching(A(2),B(2)) ~= m4
                B(2)=B(2)+1;
                B2_variable=1;
            end
        else
            if F_LSBmatching(A(2)-1,B(2)) == m4
                A(2)=A(2)-1;
                A2_variable=-1;
            else
                A(2)=A(2)+1;
                A2_variable=1;
            end
        end
        
        if (floor((A(1)+A(2))/2) == image(y,x) & floor((B(1)+B(2))/2) == image(y,x+1))
            if (A(1) < 0 | A(1) > 255 | A(2) < 0 | A(2) > 255 | B(1) < 0 | B(1) > 255 | B(2) < 0 | B(2) > 255)
                if double(image(y,x))+4 <= 255
                    image_stego1(y,x)=image_stego1(y,x)+4;
                elseif double(image(y,x))+4 > 255
                    image_stego1(y,x)=image_stego1(y,x)-4;
                end
                
                error_count=error_count+1;
            else
                image_stego1(y,x)=A(1);
                image_stego2(y,x)=A(2);
                image_stego1(y,x+1)=B(1);
                image_stego2(y,x+1)=B(2);
                str=[str num2str(m1) num2str(m2) num2str(m3) num2str(m4)];
                Cap=Cap+4;
                m1=round(rand());
                m2=round(rand());
                m3=round(rand());
                m4=round(rand());
                hiding=1;
                count = count + 4; 
                
            end
            
        else
            if A1_variable == 0 & B1_variable == 0 & A2_variable == -1 & B2_variable == 0
                A(1)=image_stego1(y,x)+2;
                B(1)=image_stego1(y,x+1)+1;
                A(2)=image_stego2(y,x)-1;
                B(2)=image_stego2(y,x+1);
            elseif A1_variable == 0 & B1_variable == 1 & A2_variable == 0 & B2_variable == 1
                A(1)=image_stego1(y,x);
                B(1)=image_stego1(y,x+1)+1;
                A(2)=image_stego2(y,x);
                B(2)=image_stego2(y,x+1)-1;
            elseif A1_variable == 0 & B1_variable == 1 & A2_variable == -1 & B2_variable == 0
                A(1)=image_stego1(y,x)+2;
                B(1)=image_stego1(y,x+1);
                A(2)=image_stego2(y,x)-1;
                B(2)=image_stego2(y,x+1);
            elseif A1_variable == -1 & B1_variable == 0 & A2_variable == 0 & B2_variable == 0
                A(1)=image_stego1(y,x)-1;
                B(1)=image_stego1(y,x+1);
                A(2)=image_stego2(y,x)+2;
                B(2)=image_stego2(y,x+1)+1;
            elseif A1_variable == -1 & B1_variable == 0 & A2_variable == 0 & B2_variable == 1
                A(1)=image_stego1(y,x)-1;
                B(1)=image_stego1(y,x+1);
                A(2)=image_stego2(y,x)+2;
                B(2)=image_stego2(y,x+1);
            elseif A1_variable == -1 & B1_variable == 0 & A2_variable == -1 & B2_variable == 0
                A(1)=image_stego1(y,x)-1;
                B(1)=image_stego1(y,x+1)+2;
                A(2)=image_stego2(y,x)+1;
                B(2)=image_stego2(y,x+1)-1;
            elseif A1_variable == 1 & B1_variable == 0 & A2_variable == 1 & B2_variable == 0
                A(1)=image_stego1(y,x)-1;
                B(1)=image_stego1(y,x+1)-1;
                A(2)=image_stego2(y,x)+1;
                B(2)=image_stego2(y,x+1)+2;
            end
            
            if A(1) < 0 | A(1) > 255 | A(2) < 0 | A(2) > 255 | B(1) < 0 | B(1) > 255 | B(2) < 0 | B(2) > 255
                if double(image(y,x))+4 <= 255
                    image_stego1(y,x)=image_stego1(y,x)+4;
                elseif double(image(y,x))+4 > 255
                    image_stego1(y,x)=image_stego1(y,x)-4;
                end
                error_count=error_count+1;
            else
                image_stego1(y,x)=A(1);
                image_stego2(y,x)=A(2);
                image_stego1(y,x+1)=B(1);
                image_stego2(y,x+1)=B(2);
                %                   str=[str num2str(m1) num2str(m2) num2str(m3) num2str(m4)];
                Cap=Cap+4;
                m1=round(rand());
                m2=round(rand());
                m3=round(rand());
                m4=round(rand());
                hiding=1;
                count = count + 4; 
            end
        end
        
        if ( index_PSNRs < 21   )
                    if count-Cap_goal == 0 | (count-Cap_goal <= 100 & count-Cap_goal > 0)
                        bpp = count / (height*width*2);
                        [PSNR1 MSE1]=clacImage(Gray,image_stego1);
                        [PSNR2 MSE2]=clacImage(Gray,image_stego2);
                        if (MSE1 ==0)
                            PSNR1 = 100;
                        end
                        if (MSE2 ==0)
                            PSNR2 = 100;
                        end

                        average1= (PSNR1 + PSNR2)/2;
                            PSNRs1(index_PSNRs,1)=bpp;
                            PSNRs1(index_PSNRs,2)=average1;

                                        if (isRSAttack == 1)

                                                fileword3 = [  'experimental results\stego_' f_n '3.jpg'] ;
                                                imwrite(image_stego1, fileword3, 'jpg');
                                                fileword4 = [   'experimental results\stego_' f_n '4.jpg'] ;
                                                imwrite(image_stego2, fileword4,'jpg');
        %                                         
                                                 [R_FM_G, S_FM_G, U_FM_G, R_M_G, S_M_G, U_M_G] = RSAttack(fileword3);
                                                 fprintf(fid_att,'\n%s \t %8.2f \t %8.2f \t %8.2f \t %8.2f \t %8.2f \t %8.2f \t %8.2f\t', 'stego1', R_FM_G, S_FM_G, U_FM_G, R_M_G, S_M_G, U_M_G, count); 
                                                 [R_FM_G, S_FM_G, U_FM_G, R_M_G, S_M_G, U_M_G] = RSAttack(fileword4);
                                                 fprintf(fid_att,'\n%s \t %8.2f \t %8.2f \t %8.2f \t %8.2f \t %8.2f \t %8.2f \t %8.2f\t', 'stego1', R_FM_G, S_FM_G, U_FM_G, R_M_G, S_M_G, U_M_G, count); 
                                                 
                                        end                     
                         index_PSNRs=index_PSNRs+1;
                         bpp_PSNRs= bpp_PSNRs+bpp_S;
                         Cap_goal = floor(bpp_PSNRs*height*width);
                    end                    
                  end 
        
    end
end

Time=Time+toc;
                        bpp = Cap/ (height*width*2);
                        [PSNR1 MSE1]=clacImage(Gray,image_stego1);
                        [PSNR2 MSE2]=clacImage(Gray,image_stego2);
                        if (MSE1 ==0)
                            PSNR1 = 100;
                        end
                        if (MSE2 ==0)
                            PSNR2 = 100;
                        end

                        average1= (PSNR1 + PSNR2)/2;
                            PSNRs1(index_PSNRs,1)=bpp;
                            PSNRs1(index_PSNRs,2)=average1;

                                        if (isRSAttack == 1)

                                                fileword3 = [  'experimental results\stego_' f_n '3.jpg'] ;
                                                imwrite(image_stego1, fileword3, 'jpg');
                                                fileword4 = [   'experimental results\stego_' f_n '4.jpg'] ;
                                                imwrite(image_stego2, fileword4,'jpg');
        %                                         
                                                 [R_FM_G, S_FM_G, U_FM_G, R_M_G, S_M_G, U_M_G] = RSAttack(fileword3);
                                                 fprintf(fid_att,'\n%s \t %8.2f \t %8.2f \t %8.2f \t %8.2f \t %8.2f \t %8.2f \t %8.2f\t', 'stego1', R_FM_G, S_FM_G, U_FM_G, R_M_G, S_M_G, U_M_G, count); 
                                                 [R_FM_G, S_FM_G, U_FM_G, R_M_G, S_M_G, U_M_G] = RSAttack(fileword4);
                                                 fprintf(fid_att,'\n%s \t %8.2f \t %8.2f \t %8.2f \t %8.2f \t %8.2f \t %8.2f \t %8.2f\t', 'stego1', R_FM_G, S_FM_G, U_FM_G, R_M_G, S_M_G, U_M_G, count); 
                                                 
                                        end                     
                         index_PSNRs=index_PSNRs+1;
                         bpp_PSNRs= bpp_PSNRs+bpp_S;
                         Cap_goal = floor(bpp_PSNRs*height*width);
 
  fileword3 = [ 'experimental results\' 'PNGstego_' f_n '_3'  '.png'  ];
    imwrite(image_stego1,fileword3,'png');
    fileword4 = [ 'experimental results\' 'PNGstego_' f_n '_4' '.png' ] ;
    imwrite(image_stego2,fileword4,'png');
                
    fprintf('\n%s \t %s \t   %s \t %8.2f \t %8.2f \t %8.2f \t  %8.2f \t%8.2f \t %d \t%8.2f \t%8.2f \t%8.2f \t %8.2f \t \t%8.2f',f_secret,  'LSB-M',  f_n, PSNR1, PSNR2, average1, count, bpp,  Time, MSE1, MSE2, count); 
    fprintf(fid,'\n%s \t  %s \t  %s \t %8.2f \t %8.2f \t %8.2f \t  %8.2f \t%8.2f \t %d \t%8.2f \t%8.2f \t%8.2f \t %8.2f \t%8.2f \t ',f_secret, 'LSB-M',   f_n, PSNR1, PSNR2, average1, count, bpp,  Time, MSE1, MSE2, count); 
            
fclose(fid); 


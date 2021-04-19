function PSNRs = changEmbedding2013(bpp_S,bpp_W,file_path, file_experiment, total_secret, message, secret_array, secret_array_String)
fid= fopen(file_experiment, 'a+');

tic;
Squared = 8;
image=imread(file_path);
image_stego1 = image;
image_stego2 = image;
[height width] = size(image);

bpp_PSNRs=bpp_S;
Cap_goal = ceil(bpp_PSNRs*height*width*2);   
PSNRs=zeros(20,2);
index_PSNRs=1;

Cap=0.0;
str='';
Time=0;
T_number = 4; 
Now_embed = 1;
n = T_number ; 

for y=1:height
    for x=1:width
          if ( Now_embed < length(secret_array))
            v1 =   secret_array(Now_embed) ;
            Now_embed =Now_embed+1; 
            v2 =   secret_array(Now_embed) ;
            V=v1 * 16 + v2;
            Now_embed =Now_embed+1; 
          end 
        
        
        x1=double(image_stego1(y,x));
        x2=double(image_stego2(y,x));
        f=F(x1,x2);
        if f == V
           x1=x1;
           x2=x2;
        elseif f == mod((V-2),9)
           x1=x1-1;
           x2=x2+1;
        elseif f == mod((V+5),9) 
           x1=x1-2;
           x2=x2+2;
        elseif f == mod((V+3),9)
           x1=x1-3;
           x2=x2+3;
        elseif f == mod((V+1),9)
           x1=x1-4;
           x2=x2+4;
        elseif f == mod((V+2),9)
           x1=x1+1;
           x2=x2-1;
        elseif f == mod((V+4),9)
           x1=x1+2;
           x2=x2-2;
        elseif f == mod((V+6),9)
           x1=x1+3;
           x2=x2-3;
        elseif f == mod((V-1),9)
           x1=x1+4; 
           x2=x2-4;
        end
               
        if x1 >=0 & x1 <= 255 & x2 >=0 & x2 <= 255
              if (  Now_embed < length(secret_array))
                if V == 8
                    Cap=Cap+4;
                else
                    Cap=Cap+3;
                end
              end 
            image_stego1(y,x)=x1;
            image_stego2(y,x)=x2;
        end

        if index_PSNRs < 21
           if Cap-Cap_goal == 0 | (Cap-Cap_goal <= 4 & Cap-Cap_goal > 0)       
                 bpp = Cap/  (height*width*2);
              [PSNR1 MSE1]=clacImage(image_stego1,image);
              [PSNR2 MSE2]=clacImage(image_stego2,image);
              PSNRs(index_PSNRs,1)=bpp;
              PSNRs(index_PSNRs,2)=(PSNR1+PSNR2)/2;
              index_PSNRs=index_PSNRs+1;
              bpp_PSNRs= bpp_PSNRs+bpp_W;
              Cap_goal = ceil(bpp_PSNRs*height*width*2);
           end
        end
        
    end
end

Time=Time+toc;
count = Cap;
bpp = Cap/ (height*width*2);
[PSNR1 MSE1]=clacImage(image_stego1,image);
[PSNR2 MSE2]=clacImage(image_stego2,image);
PSNRs(index_PSNRs,1)=bpp;
PSNRs(index_PSNRs,2)=(PSNR1+PSNR2)/2;
average1=(PSNR1+PSNR2)/2;

fprintf('\n%s \t %5.0f \t%s \t %8.2f \t %8.2f \t %8.2f \t  %8.2f \t%8.2f \t %d \t%8.2f \t %8.2f \t  %8.2f\t','Chang2013' , 4, file_path, PSNR1, PSNR2, average1, count, bpp, 8, Time, MSE1, MSE2); 
fprintf(fid, '\n%s \t %5.0f \t%s \t %8.2f \t %8.2f \t %8.2f \t  %8.2f \t%8.2f \t %d \t%8.2f \t %8.2f \t  %8.2f\t','Chang2013' , 4, file_path, PSNR1, PSNR2, average1, count, bpp, 8, Time, MSE1, MSE2); 
 

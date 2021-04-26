function [PSNRs] = Lee_Embedding2009(bpp_S,bpp_W,file_path, file_experiment, total_secret, message, secret_array, secret_array_String)
fid= fopen(file_experiment, 'a+');
Squared = 8;
tic;
image = imread(file_path);
image_stego1 = image;
image_stego2 = image;
[height width] = size(image);
Cap=0;
str='';
Time=0;

bpp_PSNRs=bpp_S;
Cap_goal = ceil(bpp_PSNRs*height*width*2);
PSNRs=zeros(20,2);
index_PSNRs=1;
T_number = 4; 
Now_embed = 1;
n = T_number ; 

for y=1:height
    for x=1:2:width
        
        check=0;
          if (  Now_embed < length(secret_array))
            test =   secret_array(Now_embed) ;
            b1 = fix (test / (4*2) ) ;
            test = test - b1*8;
            b2 = fix (test / 4);
            test = test - b2*4;
            b3 = fix (test / 2);
            b4 = test - b3*2;
%             [ num2str(test) ' = ' num2str(b1)   num2str(b2)   num2str(b3)  num2str(b4) '  ==>  Now_embed = ' num2str(Now_embed)]
          end 
        
        
        P11=double(image_stego1(y,x));
        P12=double(image_stego1(y,x+1));
        P21=double(image_stego2(y,x));
        P22=double(image_stego2(y,x+1));
        
%          [ 'pixels:' num2str(P11) ' '  num2str(P12) ' '  num2str(P21) ' '   num2str(P22)  ]
        if P11 <= 0 | P11 >= 255 | P12 <= 0 | P12 >= 255
            image_stego1(y,x)=P11;
            image_stego1(y,x+1)=P12;
            image_stego2(y,x)=P21;
            image_stego2(y,x+1)=P22;
            continue;
        else            
            if b1==0 & b2==0
                P11=P11+1;
            elseif b1==1 & b2==0
                P12=P12+1;
            elseif b1==1 & b2==1
                P11=P11-1;
            elseif b1==0 & b2==1
                P12=P12-1;
            end
            
            if b1==0 & b2==0
                if b3 == 1 & b4 == 1
                    P21=P21-1;
                    check=1;
                elseif b3 == 0 & b4 == 1
                    P22=P22-1;
                    check=1;
                end
            elseif b1==1 & b2==0
                if b3 == 0 & b4 == 1
                    P22=P22-1;
                    check=1;
                elseif b3 == 0 & b4 == 0
                    P21=P21+1;
                    check=1;
                end
            elseif b1==1 & b2==1
                if b3 == 0 & b4 == 0
                    P21=P21+1;
                    check=1;
                elseif b3 == 1 & b4 == 0
                    P22=P22+1;
                    check=1;
                end
            elseif b1==0 & b2== 1
                if b3 == 1 & b4 == 0
                    P22=P22+1;
                    check=1;
                elseif b3 == 1 & b4 == 1
                    P21=P21-1;
                    check=1;
                end
            end
            
            image_stego1(y,x)=P11;
            image_stego1(y,x+1)=P12;
            image_stego2(y,x)=P21;
            image_stego2(y,x+1)=P22;
            
%              [ 'stego:' num2str(P11) ' '  num2str(P12) ' '  num2str(P21)  ' '   num2str(P22)  ]
              if (  Now_embed < length(secret_array) ) 
                if check == 0
                    Cap=Cap+2;
                    Now_embed = Now_embed +1;
                elseif check == 1
                    Cap=Cap+4;
                    Now_embed = Now_embed +1;
                end
              end 
            
            if index_PSNRs < 21
                if Cap-Cap_goal == 0 | (Cap-Cap_goal <= 4 & Cap-Cap_goal > 0)
                     bpp = Cap/  (height*width*2);
                    [PSNR1 MSE1]=clacImage(image_stego1,image);
                    [PSNR2 MSE2]=clacImage(image_stego2,image);
                    if (MSE1 ==0)
                        PSNR1 = 100;
                    end
                    if (MSE2 ==0)
                        PSNR2 = 100;
                    end
                    PSNRs(index_PSNRs,1)=bpp;
                    PSNRs(index_PSNRs,2)=(PSNR1+PSNR2)/2;
                    
                    index_PSNRs=index_PSNRs+1;
                    bpp_PSNRs= bpp_PSNRs+bpp_W;
                    
                    Cap_goal = ceil(bpp_PSNRs*height*width*2);
                end
            end
        end
        
    end
end

Time=Time+toc;

[PSNR1 MSE1]=clacImage(image_stego1,image);
[PSNR2 MSE2]=clacImage(image_stego2,image);
if (MSE1 ==0)
    PSNR1 = 100;
end
if (MSE2 ==0)
    PSNR2 = 100;
end
count = Cap;
bpp = Cap/ (height*width*2);

PSNRs(index_PSNRs,1)=bpp;
PSNRs(index_PSNRs,2)=(PSNR1+PSNR2)/2;
average1=(PSNR1+PSNR2)/2;

fprintf('\n%s \t %5.0f \t%s \t %8.2f \t %8.2f \t %8.2f \t  %8.2f \t%8.2f \t %d \t%8.2f \t %8.2f \t  %8.2f\t','Lee2009' , 4, file_path, PSNR1, PSNR2, average1, count, bpp, 4, Time, MSE1, MSE2); 
fprintf(fid, '\n%s \t %5.0f \t%s \t %8.2f \t %8.2f \t %8.2f \t  %8.2f \t%8.2f \t %d \t%8.2f \t %8.2f \t  %8.2f\t','Lee2009' , 4, file_path, PSNR1, PSNR2, average1, count, bpp, 4, Time, MSE1, MSE2); 
 


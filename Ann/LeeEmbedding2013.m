function [PSNRs] = LeeEmbedding2013(bpp_S,bpp_W,file_path, file_experiment, total_secret, message, secret_array, secret_array_String)
fid= fopen(file_experiment, 'a+');
Squared = 8;
tic;
image = imread(file_path);
image_stego1 = image;
image_stego2 = image;
[height width] = size(image);

Cap=0;
str='';

bpp_PSNRs=bpp_S;
Cap_goal = ceil(bpp_PSNRs*height*width*2);   
PSNRs=zeros(20,2);
index_PSNRs=1;
Time=0;
T_number = 4; 
n = T_number;
Now_embed = 1;

for y=1:height
    for x=1:2:width
        P11=double(image_stego1(y,x));
        P12=double(image_stego1(y,x+1));
        P21=double(image_stego2(y,x));
        P22=double(image_stego2(y,x+1));
        if ( Now_embed < length(secret_array))
                soriginal = secret_array(Now_embed);  
                w1 = fix( soriginal / 4 ); 
                w2 = soriginal - w1 *4; 
                Now_embed = Now_embed+1; 

                 

                if w1 == 0
                    if w2 == 1
                       P21=P21-1;
                       P22=P22-1;
                    elseif w2==2
                       P21=P21-1;
                       P22=P22+1; 
                    elseif w2==3
                       P21=P21+1;
                       P22=P22+1;
                    elseif w2==4
                       P21=P21+1;
                       P22=P22-1;   
                    end
                elseif w1 == 1
                    P11=P11-1;
                    P12=P12-1;
                    if w2==0
                       P22=P22+1;
                    elseif w2 == 1
                       P21=P21-1;
                    elseif w2==2
                       P21=P21+1;
                       P22=P22+1; 
                    elseif w2==3
                       P21=P21+1;
                    elseif w2==4
                       P21=P21+1;
                       P22=P22-1;   
                    end
                elseif w1 == 2
                    P11=P11-1;
                    P12=P12+1;
                    if w2==0
                       P21=P21+1;
                    elseif w2 == 1
                       P21=P21+1;
                       P22=P22-1;
                    elseif w2==2    
                       P22=P22+1; 
                    elseif w2==3
                       P22=P22-1; 
                    elseif w2==4
                       P21=P21-1;
                       P22=P22-1;   
                    end
                elseif w1 == 3
                   P11=P11+1;
                   P12=P12+1; 
                   if w2==0
                       P22=P22-1;
                    elseif w2 == 1
                       P21=P21-1;
                       P22=P22-1;
                    elseif w2==2    
                       P21=P21-1; 
                    elseif w2==3
                        P21=P21+1; 
                    elseif w2==4
                       P21=P21-1;
                       P22=P22+1;   
                    end
                elseif w1 == 4
                   P11=P11+1;
                   P12=P12-1; 
                    if w2==0
                       P21=P21-1;
                    elseif w2 == 1
                       P21=P21-1;
                       P22=P22+1;
                    elseif w2==2    
                       P22=P22+1; 
                    elseif w2==3
                        P21=P21+1; 
                        P22=P22+1;
                    elseif w2==4
                       P22=P22-1;   
                    end
                end
        end 
        if P11 > 255 | P21 > 255
           image_stego2(y,x)=image_stego2(y,x)-3;
           continue;
        elseif P12 > 255 | P22 > 255
           image_stego2(y,x+1)=image_stego2(y,x+1)-3;
           continue;
        elseif P11 < 0 | P21 < 0
           image_stego2(y,x)=image_stego2(y,x)+3;
           continue;
        elseif P12 < 0 | P22 < 0
           image_stego2(y,x+1)=image_stego2(y,x+1)+3;
           continue;
        else
            image_stego1(y,x)=P11;
            image_stego1(y,x+1)=P12;
            image_stego2(y,x)=P21;
            image_stego2(y,x+1)=P22;
              if ( Now_embed < length(secret_array))
                 Cap=Cap+n;     
              end 
                
        end
            
        if index_PSNRs < 21
            if Cap-Cap_goal == 0 | (Cap-Cap_goal <= 4 & Cap-Cap_goal > 0)        
                bpp = Cap/ (height*width*2);
                [PSNR1 MSE1]=clacImage(image_stego1,image);
                [PSNR2 MSE2]=clacImage(image_stego2,image);
                PSNRs(index_PSNRs,1)=bpp;
                PSNRs(index_PSNRs,2)=(PSNR1+PSNR2)/2;
                index_PSNRs=index_PSNRs+1;
                bpp_PSNRs= bpp_PSNRs+bpp_W;
                Cap_goal = ceil(bpp_PSNRs*512*512*2);
                
            end
        end
    end
end

Time=toc;
count = Cap;
bpp = Cap/ (height*width*2);
[PSNR1 MSE1]=clacImage(image_stego1,image);
[PSNR2 MSE2]=clacImage(image_stego2,image);
PSNRs(index_PSNRs,1)=bpp;
PSNRs(index_PSNRs,2)=(PSNR1+PSNR2)/2;
average1=(PSNR1+PSNR2)/2;


fprintf('\n%s \t %5.0f \t%s \t %8.2f \t %8.2f \t %8.2f \t  %8.2f \t%8.2f \t %d \t%8.2f \t %8.2f \t  %8.2f\t','Lee2013' , 4, file_path, PSNR1, PSNR2, average1, count, bpp, 4, Time, MSE1, MSE2); 
fprintf(fid, '\n%s \t %5.0f \t%s \t %8.2f \t %8.2f \t %8.2f \t  %8.2f \t%8.2f \t %d \t%8.2f \t %8.2f \t  %8.2f\t','Lee2013' , 4, file_path, PSNR1, PSNR2, average1, count, bpp, 4, Time, MSE1, MSE2); 

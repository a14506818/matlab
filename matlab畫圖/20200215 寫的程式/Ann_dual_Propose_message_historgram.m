function [PSNRs1 PSNRs2 PSNRs3]= Ann_dual_Propose_message_historgram(bpp_S, bpp_W, file_name, T_number, isDrawFigure, isColorImage, file_experiment, total_secret , message, secret_array)
                                                                   
tic;
 fid= fopen(file_experiment, 'a+');
 type=1;
 file_path = file_name;
 
%   Hiding_bit =  zeros(T_number+1,1);  
%   Hiding_bit(1,1) = first_hiddingbit; %1 ==>1234 or 2 ==>2345 or 3 ==>3456

 %要用幾個門檻值 T_number  

  
if isColorImage == 1 %彩色影像
   cover=imread(file_path); %原始影像
   Gray=rgb2gray(cover); 
else
   Gray=imread(file_path); %原始影像
end
 

%        Gray =  [5 10 20 15; 20 20 15 20; 5 10 20 15; 20 20 15 20] 


% rand('seed',0); %固定亂數種子，使亂數不會因重跑而跑掉。
[rows,cols]=size(Gray); %設定長與寬=Gray的長與寬
 

bpp_PSNRs=bpp_S;
Cap_goal = ceil(bpp_PSNRs*rows*cols);
PSNRs=zeros(20,2);
PSNROriginals=zeros(20,2);
index_PSNRs=1;  
% His= zeros(1000,1);

%fold + secre message histogram
Stego1=Gray;  
Stego2=Gray;  

%fold
Stego3=Gray;  
Stego4=Gray;  

%original
Stego5=Gray;  
Stego6=Gray;  

count=0; %計算藏入量(capacity)
Now_embed = 1;
nonembedding = 0; 
n = T_number ; 
Time=0;

[srow scols] = size (secret_array);
for i=1:rows 
    for j=1:cols
            if (n > 0)
                  pixel = double(Stego1(i,j));
                  if (count < (total_secret*n-n))
                        s=message(Now_embed); %產生機密訊息，範圍：0-15。 folded secret message
                        if (Now_embed < scols)
                           soriginal = secret_array(Now_embed); %original secret message 
                        else 
                            soriginal = randi(15)-1;  
                        end 
%                          [ 'pixel = ' num2str(pixel) ]
                        
%                          [ ' Now_embed = ' num2str(Now_embed) ' s= ' num2str(s) ' soriginal = ' num2str(soriginal)] 
%                        
                         %fold + secret histogram
                         [A, B, embeddable] = Ann_dual_Embedding(n, pixel, s );
                         if (embeddable == 0)
                             Stego1(i,j) = pixel; 
                             Stego2(i,j) = pixel; 
                         else
                             Stego1(i,j) = A; 
                             Stego2(i,j) = B;  
                             count = count + n;
                             Now_embed = Now_embed + 1; 
%                              if( s ~= 0 )
%                                 [ 'embeddable = ' num2str(embeddable) ' pixel = ' num2str(pixel) ' s =' num2str(s) ' A = ' num2str(A) ' B = '  num2str(B)]
%                              end 
                         end 
                        
                         %fold
                         s = soriginal - (2^(n-1));
                         [C, D, embeddable] = Ann_dual_Embedding(n, pixel, s );
                         if (embeddable == 0)
                             Stego3(i,j) = pixel; 
                             Stego4(i,j) = pixel; 
                         else
                             Stego3(i,j) = C; 
                             Stego4(i,j) = D;  
%                               [ 'embeddable = ' num2str(embeddable) ' C = ' num2str(C) ' D = '  num2str(D)]
                         end 
                         
                        
                         %original
                         s = soriginal ;
                         [E, F, embeddable] = Ann_dual_Embedding(n, pixel, s );
                         if (embeddable == 0)
                             Stego5(i,j) = pixel; 
                             Stego6(i,j) = pixel; 
                         else
                             Stego5(i,j) = E; 
                             Stego6(i,j) = F;  
%                              [ 'embeddable = ' num2str(embeddable) ' E = ' num2str(E) ' F = '  num2str(F)]
                         end 

                  end 
           else 
               nonembedding = nonembedding +1;
           end 
           
          if index_PSNRs < 21
            if count-Cap_goal == 0 | (count-Cap_goal <= 100 & count-Cap_goal > 0)
                bpp = count/ (rows*cols*2);
                [PSNR1 MSE1]=clacImage(Gray,Stego1);
                [PSNR2 MSE2]=clacImage(Gray,Stego2);
                if (MSE1 ==0)
                    PSNR1 = 100;
                end
                if (MSE2 ==0)
                    PSNR2 = 100;
                end
                average1= (PSNR1 + PSNR2)/2;
                    PSNRs1(index_PSNRs,1)=bpp;
                    PSNRs1(index_PSNRs,2)=average1;

               [PSNR3 MSE3]=clacImage(Gray,Stego3);
               [PSNR4 MSE4]=clacImage(Gray,Stego4);
                average2= (PSNR3 + PSNR4)/2;
                    PSNRs2(index_PSNRs,1)=bpp;
                    PSNRs2(index_PSNRs,2)=average2;

               [PSNR5 MSE5]=clacImage(Gray,Stego5);
               [PSNR6 MSE6]=clacImage(Gray,Stego6);
                average3= (PSNR5 + PSNR6)/2;
                    PSNRs3(index_PSNRs,1)=bpp;
                    PSNRs3(index_PSNRs,2)=average3;
                index_PSNRs=index_PSNRs+1;
                bpp_PSNRs= bpp_PSNRs+bpp_W;
                Cap_goal = floor(bpp_PSNRs*rows*cols);
            end
        end

    end
end 
% nonembedding
 
                bpp = count/ (rows*cols*2);
                [PSNR1 MSE1]=clacImage(Gray,Stego1);
                [PSNR2 MSE2]=clacImage(Gray,Stego2);
                if (MSE1 ==0)
                    PSNR1 = 100;
                end
                if (MSE2 ==0)
                    PSNR2 = 100;
                end
                average1= (PSNR1 + PSNR2)/2;
                    PSNRs1(index_PSNRs,1)=bpp;
                    PSNRs1(index_PSNRs,2)=average1;

               [PSNR3 MSE3]=clacImage(Gray,Stego3);
               [PSNR4 MSE4]=clacImage(Gray,Stego4);
                average2= (PSNR3 + PSNR4)/2;
                    PSNRs2(index_PSNRs,1)=bpp;
                    PSNRs2(index_PSNRs,2)=average2;

               [PSNR5 MSE5]=clacImage(Gray,Stego5);
               [PSNR6 MSE6]=clacImage(Gray,Stego6);
                average3= (PSNR5 + PSNR6)/2;
                    PSNRs3(index_PSNRs,1)=bpp;
                    PSNRs3(index_PSNRs,2)=average3;

Time=Time+toc;

if (isDrawFigure == 1)
     for i=1:6
         nam = ['Stego' int2str(i)];
         titleWord = [  file_name '_T_'  int2str(T_number) '_Stego ' int2str(i) ];
         figure(i); imshow(nam);title(titleWord);
         
         fileword = [int2str(T_number) '_' file_name '_' int2str(i)];
         filesaveName = ['experimental results\' fileword];
         saveas(figure(i),filesaveName,'tif');

     end 

end 
 


fprintf('\n%s \t %5.0f \t%s \t %8.2f \t %8.2f \t %8.2f \t  %8.2f \t%8.2f \t %d \t%8.2f \t%8.2f \t%8.2f \t %8.2f','Lu2016' , T_number, file_name, PSNR1, PSNR2, average1, count, bpp, T_number, Time, MSE1, MSE2, total_secret); 
fprintf(fid, '\n%s \t %5.0f \t%s \t %8.2f \t %8.2f \t %8.2f \t  %8.2f \t%8.2f \t %d \t%8.2f \t%8.2f \t%8.2f\t %8.2f','Lu2016' , T_number, file_name, PSNR1, PSNR2, average1, count, bpp, T_number, Time, MSE1, MSE2, total_secret); 

fprintf('\n%s \t %5.0f \t%s \t %8.2f \t %8.2f \t %8.2f \t  %8.2f \t%8.2f \t %d \t%8.2f \t%8.2f \t%8.2f\t','CenterFolding' , T_number, file_name, PSNR3, PSNR4, average2, count, bpp, T_number, Time, MSE3, MSE4); 
fprintf(fid, '\n%s \t %5.0f \t%s \t %8.2f \t %8.2f \t %8.2f \t  %8.2f \t%8.2f \t %d \t%8.2f \t%8.2f \t%8.2f\t','CenterFolding' , T_number, file_name, PSNR3, PSNR4, average2, count, bpp, T_number, Time, MSE3, MSE4); 

fprintf('\n%s \t %5.0f \t%s \t %8.2f \t %8.2f \t %8.2f \t  %8.2f \t%8.2f \t %d \t%8.2f \t%8.2f \t%8.2f\t','NonFolding' , T_number, file_name, PSNR5, PSNR6, average3, count, bpp, T_number, Time, MSE5, MSE6); 
fprintf(fid, '\n%s \t %5.0f \t%s \t %8.2f \t %8.2f \t %8.2f \t  %8.2f \t%8.2f \t %d \t%8.2f \t%8.2f \t%8.2f\t','NonFolding' , T_number, file_name, PSNR5, PSNR6, average3, count, bpp, T_number, Time, MSE5, MSE6); 


fclose(fid);



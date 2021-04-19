function [PSNRs1 PSNRs2]= Ann_dual_two_Difference_zone_Block(CompairWithMySelf, f_attack, bpp_S, bpp_W, file_name, T_number, isDrawFigure, isColorImage, file_experiment, total_secret , message, secret_array,  reEncode_A, reEncode_B, showdetail, return_indicator, Block_array_size, code, isRSAttack)
                                                                   
tic;
 fid= fopen(file_experiment, 'a+');
 
     fid_att= fopen(f_attack, 'a+');
  type=1;
 file_path = file_name;
 k = T_number; 
 
fail = 0 ;
 
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
 fail = 0 ; 
 
for i=1:rows 
   j = 1; 
    while( j<=cols)
           
            countx = 1;
            while (countx <= Block_array_size & j <= cols)
                if (Gray (i,j) <= (255-8) & Gray (i,j) >= 8 )
                     x(1,countx) = double(Gray (i,j)) ;  
                    position(1,countx) = j; 
                    countx=countx+1; 
                    
                else 
%                     不能藏則設跟原始像素一樣即可 
                    if (Gray (i,j) > (255-8) )
%                            Stego2(i,j) = Gray (i,j)- 9; 
%                            Stego4(i,j) = Gray (i,j)- 9; 
                           Stego2(i,j) = Gray (i,j) ; 
                           Stego4(i,j) = Gray (i,j) ; 
                    else
                        if (Stego1 (i,j) < 8 )
%                           Stego2(i,j) =Gray (i,j) + 9; 
%                           Stego4(i,j) =Gray (i,j) + 9; 
                          Stego2(i,j) =Gray (i,j)  ; 
                          Stego4(i,j) =Gray (i,j)  ; 
                        end 
                    end 
                    fail= fail+1; 
                end 
                j=j+1; 
            end 

             
             
            for countMesage =1:(Block_array_size-1)
                 count = count + T_number;
                if ( Now_embed  < size(secret_array,2))
                     getM_A= reEncode_A(Now_embed);  
                     getM_B= reEncode_B(Now_embed);  
                     m_A(1,countMesage) =  getM_A;
                     m_B(1,countMesage) =  getM_B;
                else 
                      
                      value =   floor(rand * (2^k))+1;
                     code;
                      m_A(1,countMesage) = code(4, value );
                      m_B(1,countMesage)= code(5, value);
                 end 
                Now_embed = Now_embed + 1; 
               
            end 
                  
%               if (Now_embed < total_secret)
                                          
                     [stegoI stegoII stego_fold_I stego_fold_II] = centerfolding_fivePixel (k, x, m_A, m_B, showdetail, return_indicator);
                    for t=1:size(stegoI,2)
                            location = position(1,t);
                            Stego1(i,location) = stegoI(1, t);
                            Stego2(i,location) = stegoII(1, t);
                    end

                  for t=1:size(stego_fold_I,2)
                            location = position(1,t);
                            Stego3(i,location) = stego_fold_I(1, t);
                            Stego4(i,location) = stego_fold_II(1, t);
                  end
                  
                   
%               end 

          if ( index_PSNRs < 21 && CompairWithMySelf <= 6 )
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
               if (MSE3 ==0)
                    PSNR3 = 100;
                end
                if (MSE4 ==0)
                    PSNR4 = 100;
                end
                average2= (PSNR3 + PSNR4)/2;
                    PSNRs2(index_PSNRs,1)=bpp;
                    PSNRs2(index_PSNRs,2)=average2;
                    

                    
                    
                                if (isRSAttack == 1)
                                       foutname = file_name(8:size(file_name,2)-4); 
                                        fileword3 = [  'experimental results\stego_' foutname '_1_' int2str(T_number) '_' int2str(Block_array_size) '.jpg'] ;
                                        imwrite(Stego3, fileword3, 'jpg');
                                        fileword4 = [   'experimental results\stego_' foutname '_2_' int2str(T_number) '_' int2str(Block_array_size) '.jpg'] ;
                                        imwrite(Stego4,fileword4,'jpg');
%                                         
                                         [R_FM_G, S_FM_G, U_FM_G, R_M_G, S_M_G, U_M_G] = RSAttack(fileword3);
                                        fprintf(fid_att,'\n%s \t %5.0f \t%s \t %8.2f \t %8.2f \t %8.2f \t %8.2f \t %8.2f \t %8.2f \t %8.2f \t %8.2f\t', 'stego1',T_number, file_name, Block_array_size,R_FM_G, S_FM_G, U_FM_G, R_M_G, S_M_G, U_M_G, count); 

                                         [R_FM_G, S_FM_G, U_FM_G, R_M_G, S_M_G, U_M_G] = RSAttack(fileword4);
                                        fprintf(fid_att,'\n%s \t %5.0f \t%s \t %8.2f \t %8.2f \t %8.2f \t %8.2f \t %8.2f \t %8.2f \t %8.2f \t %8.2f\t', 'stego2',T_number, file_name, Block_array_size,R_FM_G, S_FM_G, U_FM_G, R_M_G, S_M_G, U_M_G, count); 
                                end                     
                    
                    
                    
                    
                    
                index_PSNRs=index_PSNRs+1;
                bpp_PSNRs= bpp_PSNRs+bpp_W;
                Cap_goal = floor(bpp_PSNRs*rows*cols);
            end
       
          end
          
    end
end 
% nonembedding
                  if (isRSAttack == 1 && CompairWithMySelf <=6 )
                                        foutname = file_name(8:size(file_name,2)-4); 
                                        fileword3 = [ 'experimental results\' 'stego_' foutname '_1_' int2str(T_number) '_' int2str(Block_array_size) '.jpg'  ];
                                        imwrite(Stego3,fileword3,'jpg');
                                        fileword4 = [ 'experimental results\' 'stego_' foutname '_2_' int2str(T_number) '_' int2str(Block_array_size)  '.jpg' ] ;
                                        imwrite(Stego4,fileword4,'jpg');
                                         [R_FM_G, S_FM_G, U_FM_G, R_M_G, S_M_G, U_M_G] = RSAttack(fileword3);
                                        fprintf(fid_att,'\n%s \t %5.0f \t%s \t %8.2f \t %8.2f \t %8.2f \t %8.2f \t %8.2f \t %8.2f \t %8.2f \t %8.2f\t', 'stego1',T_number, file_name, Block_array_size,R_FM_G, S_FM_G, U_FM_G, R_M_G, S_M_G, U_M_G, count); 

                                         [R_FM_G, S_FM_G, U_FM_G, R_M_G, S_M_G, U_M_G] = RSAttack(fileword4);
                                        fprintf(fid_att,'\n%s \t %5.0f \t%s \t %8.2f \t %8.2f \t %8.2f \t %8.2f \t %8.2f \t %8.2f \t %8.2f \t %8.2f\t', 'stego2',T_number, file_name, Block_array_size,R_FM_G, S_FM_G, U_FM_G, R_M_G, S_M_G, U_M_G, count); 
                end 

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
               if (MSE3 ==0)
                    PSNR3 = 100;
                end
                if (MSE4 ==0)
                    PSNR4 = 100;
                end
                average2= (PSNR3 + PSNR4)/2;
                    PSNRs2(index_PSNRs,1)=bpp;
                    PSNRs2(index_PSNRs,2)=average2;
                    
Time=Time+toc;

if ( CompairWithMySelf <=6 )
    foutname = file_name(8:size(file_name,2)-4); 
    fileword3 = [ 'experimental results\' 'PNGstego_' foutname '_1_' int2str(T_number) '_' int2str(Block_array_size) '.png'  ];
    imwrite(Stego3,fileword3,'png');
    fileword4 = [ 'experimental results\' 'PNGstego_' foutname '_2_' int2str(T_number) '_' int2str(Block_array_size)  '.png' ] ;
    imwrite(Stego4,fileword4,'png');
end 

if (isDrawFigure == 1)
     for i=1:2
            switch (CompairWithMySelf)
                case {6}
                    foutname =   file_name(8:size(file_name,2)-4); 
                    titleWord = [foutname ' Stego1(K=' int2str(T_number) ',B=' int2str(Block_array_size) ')']; 
                    computeHistogram (Gray, Stego3 ,  titleWord, i); 
                     titleWord = [foutname ' Stego2(K=' int2str(T_number) ',B=' int2str(Block_array_size) ')']; 
                    computeHistogram (Gray, Stego4 ,  titleWord, i); 
            end 
     end 

end 

                        
if ( CompairWithMySelf <=6 ) 
    fprintf('\n%s \t %5.0f \t%s \t %8.2f \t %8.2f \t %8.2f \t  %8.2f \t%8.2f \t %d \t%8.2f \t%8.2f \t%8.2f \t %8.2f \t %8.2f \t %8.2f','BlockFolding' , T_number, file_name, PSNR1, PSNR2, average1, count, bpp, T_number, Time, MSE1, MSE2, total_secret, fail, Block_array_size); 
    fprintf(fid, '\n%s \t %5.0f \t%s \t %8.2f \t %8.2f \t %8.2f \t  %8.2f \t%8.2f \t %d \t%8.2f \t%8.2f \t%8.2f\t %8.2f \t %8.2f \t %8.2f','BlockFolding' , T_number, file_name, PSNR1, PSNR2, average1, count, bpp, T_number, Time, MSE1, MSE2, total_secret, fail, Block_array_size); 
    % 
    fprintf('\n%s \t %5.0f \t%s \t %8.2f \t %8.2f \t %8.2f \t  %8.2f \t%8.2f \t %d \t%8.2f \t%8.2f \t%8.2f \t %8.2f \t %8.2f \t %8.2f','BlockFolding(RE)' , T_number, file_name, PSNR3, PSNR4, average2, count, bpp, T_number, Time, MSE3, MSE4, total_secret, fail, Block_array_size); 
    fprintf(fid, '\n%s \t %5.0f \t%s \t %8.2f \t %8.2f \t %8.2f \t  %8.2f \t%8.2f \t %d \t%8.2f \t%8.2f \t%8.2f\t %8.2f \t %8.2f \t %8.2f','BlockFolding(RE)' , T_number, file_name, PSNR3, PSNR4, average2, count, bpp, T_number, Time, MSE3, MSE4, total_secret, fail, Block_array_size); 
end  

fclose(fid);



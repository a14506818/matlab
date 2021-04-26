  function [PSNRs1]= Ann_dual_ZoneChange0716(f_secret, secret_array, CompairWithMySelf, bpp_S, f_n, file_path, n, NZ, f_attack, isDrawFigure, isColorImage, file_experiment, isRSAttack)

tic;
 fid= fopen(file_experiment, 'a+');
%  
       fid_att= fopen(f_attack, 'a+');
 
% k = T_number; 
%  
% fail = 0 ;
 
% 
%  %要用幾個門檻值 T_number  
% 
%   
if isColorImage == 1 %彩色影像
   cover=imread(file_path); %原始影像
   Gray=rgb2gray(cover); 
else
   Gray=imread(file_path); %原始影像
end
 
Tdebug = 0; 
 
%  Gray =  [5 0 20 15; 20 20 15 20; 5 10 20 15; 20 20 15 20] 
% Gray =  [5 0 20 15; 20 255 15 20] ;

Zlength = (2*n+1) * NZ; 
% rand('seed',0); %固定亂數種子，使亂數不會因重跑而跑掉。
[rows,cols]=size(Gray); %設定長與寬=Gray的長與寬
 
% 
bpp_PSNRs=bpp_S;
Cap_goal = ceil(bpp_PSNRs*rows*cols);
PSNRs=zeros(20,2);
PSNROriginals=zeros(20,2);
index_PSNRs=1;  

Stego1=Gray;  
Stego2=Gray;  

count = 0; 

%  
count=0; %計算藏入量(capacity)
% Now_embed = 1;
% nonembedding = 0; 
 
Time=0;
   fail = 0 ; 
logSize = floor(log2(Zlength-1));
logSize_number = 2^logSize;
logSize1 = logSize + 1 ;

['each size = ' int2str(logSize1)] 

if ( Tdebug == 1) 
     ['n=' int2str(n) 'NZ=' int2str(NZ) 'Zlength=' int2str(Zlength) 'logSize=' int2str(logSize)] 
end 

 step_count = 1; 
 [secre_row secre_col] = size(secret_array ); 
%  總藏入機密符號數
total_hiding_symbol = 0;  
for i=1:rows 
    j = 1; 
    while( j<=cols)
            countx = 1;
            x=[-1,-1];
            while (countx <= 2 & j <= cols)
                if (Gray (i,j) <= (255-ceil(n/2)) & Gray (i,j) >= ceil(n/2) )
                    x(1,countx) = double(Gray (i,j)) ;  
                    position(1,countx) = j; 
                    countx=countx+1; 
                else 
%                     不能藏則設跟原始像素一樣即可 
                    if (Gray (i,j) >  (255- ceil(n/2)) )
                          Stego1(i,j) = Gray (i,j) ; 
                          Stego2(i,j) = Gray (i,j) ; 
                    else
                        if (Gray (i,j) < ceil(n/2) )
                            Stego1(i,j) = Gray (i,j) ; 
                            Stego2(i,j) = Gray (i,j)  ; 
                        end 
                    end 
                    fail= fail+1; 
                end 
                j=j+1; 
            end 
            
            if (any(x==-1) == 0)
                x;

%                 d = randi(Zlength) - 1  ;  
                if (step_count < secre_col)
                   d = secret_array(step_count);
                   step_count=step_count+1; 
                else
                   d = randi(Zlength) - 1  ;    
                end 
                if (d < logSize_number)
                        count = count + logSize; 
                else 
                        count = count + logSize1; 
                end 
                 
                
                if (Tdebug == 1)
                    ['d=' int2str(d) ]
                end 
                z = floor(d/(2*n+1)) ;
                z2 = z - floor(NZ/2);

                c = z * (2 * n + 1) + n ; 
                d2 = d - c; 

                if (Tdebug == 1) 
                     ['(z,d)' int2str(z2) int2str(d2)] 
                end 

                Dz1 = ceil(z2/2) ;
                Dz2 = floor(z2/2) ;
                if (Tdebug == 1)
                     ['(z1,z2)' int2str(Dz1) int2str(Dz2)] 
                end 
                 
                
                Stego1(i, position(1,1) ) =  x(1,1) -  Dz1 ;
                Stego2(i, position(1,1) ) =  x(1,1) +  Dz2 ;



                Dd1 = ceil(d2/2) ;
                Dd2 = floor(d2/2) ;
                Stego1(i, position(1,2) ) =  x(1,2) -  Dd1 ;
                Stego2(i, position(1,2) ) =  x(1,2) +  Dd2 ;


                  if (Tdebug == 1) 
                      Stego1 
                  end 
                  if (Tdebug == 1) 
                      Stego2 
                  end 
            end 
            
          if ( index_PSNRs < 21 && CompairWithMySelf <= 7 )
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
 
                    
                    
                                if (isRSAttack == 1)
                                        
                                        fileword1 = [  'experimental results\stego_' f_n '_1_' int2str(n) '_' int2str(NZ) '.jpg'] ;
                                        imwrite(Stego1, fileword1, 'jpg');
                                        fileword2 = [   'experimental results\stego_' f_n '_2_' int2str(n) '_' int2str(NZ) '.jpg'] ;
                                        imwrite(Stego2,fileword2,'jpg');
%                                         
                                         [R_FM_G, S_FM_G, U_FM_G, R_M_G, S_M_G, U_M_G] = RSAttack(fileword1);
                                        fprintf(fid_att,'\n%s \t %5.0f \t%s \t %8.2f \t %8.2f \t %8.2f \t %8.2f \t %8.2f \t %8.2f \t %8.2f \t %8.2f\t', 'stego1',n, f_n, NZ,R_FM_G, S_FM_G, U_FM_G, R_M_G, S_M_G, U_M_G, count); 

                                         [R_FM_G, S_FM_G, U_FM_G, R_M_G, S_M_G, U_M_G] = RSAttack(fileword2);
                                        fprintf(fid_att,'\n%s \t %5.0f \t%s \t %8.2f \t %8.2f \t %8.2f \t %8.2f \t %8.2f \t %8.2f \t %8.2f \t %8.2f\t', 'stego2',n, f_n, NZ,R_FM_G, S_FM_G, U_FM_G, R_M_G, S_M_G, U_M_G, count); 
                                end                     
                 index_PSNRs=index_PSNRs+1;
                 bpp_PSNRs= bpp_PSNRs+bpp_S;
                 Cap_goal = floor(bpp_PSNRs*rows*cols);
            end
       
          end
          
    end
end 
count
 
% % nonembedding
                  if (isRSAttack == 1 && CompairWithMySelf <=7 )
                                         fileword1 = [  'experimental results\stego_' f_n '_1_' int2str(n) '_' int2str(NZ) '.jpg'] ;
                                        imwrite(Stego1, fileword1, 'jpg');
                                        fileword2 = [   'experimental results\stego_' f_n '_2_' int2str(n) '_' int2str(NZ) '.jpg'] ;
                                        imwrite(Stego2,fileword2,'jpg');
                                          
                                         [R_FM_G, S_FM_G, U_FM_G, R_M_G, S_M_G, U_M_G] = RSAttack(fileword1);
                                        fprintf(fid_att,'\n%s \t %5.0f \t%s \t %8.2f \t %8.2f \t %8.2f \t %8.2f \t %8.2f \t %8.2f \t %8.2f \t %8.2f\t', 'stego1',n, f_n, NZ,R_FM_G, S_FM_G, U_FM_G, R_M_G, S_M_G, U_M_G, count); 

                                         [R_FM_G, S_FM_G, U_FM_G, R_M_G, S_M_G, U_M_G] = RSAttack(fileword2);
                                        fprintf(fid_att,'\n%s \t %5.0f \t%s \t %8.2f \t %8.2f \t %8.2f \t %8.2f \t %8.2f \t %8.2f \t %8.2f \t %8.2f\t', 'stego2',n, f_n, NZ,R_FM_G, S_FM_G, U_FM_G, R_M_G, S_M_G, U_M_G, count);  
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
%                 
                
                average1= (PSNR1 + PSNR2)/2;
                    PSNRs1(index_PSNRs,1)=bpp;
                    PSNRs1(index_PSNRs,2)=average1;
 Time=Time+toc;

if ( CompairWithMySelf <=7 )
 
    fileword1 = [ 'experimental results\' 'PNGstego_' f_n '_1_' int2str(n) '_' int2str(NZ) '.png'  ];
    imwrite(Stego1,fileword1,'png');
    fileword2 = [ 'experimental results\' 'PNGstego_' f_n '_2_' int2str(n) '_' int2str(NZ)  '.png' ] ;
    imwrite(Stego2,fileword2,'png');
end 
 
if (isDrawFigure == 1)
     for i=1:2
            switch (CompairWithMySelf)
                case {6, 7}
                    titleWord = [f_n ' Stego1(n=' int2str(n) ',NZ=' int2str(NZ) ')']; 
                    computeHistogram (Gray, Stego1 ,  titleWord, i); 
                     titleWord = [f_n ' Stego2(n=' int2str(n) ',NZ=' int2str(NZ) ')']; 
                    computeHistogram (Gray, Stego2 ,  titleWord, i); 
            end 
     end 

end 
% 
%                         
if ( CompairWithMySelf <=7 ) 
     
    fprintf('\n%s \t %s \t  %5.0f \t %5.0f \t %s \t %8.2f \t %8.2f \t %8.2f \t  %8.2f \t%8.2f \t %d \t%8.2f \t%8.2f \t%8.2f \t %8.2f \t \t%8.2f',f_secret,  'proposed', n, NZ, f_n, PSNR1, PSNR2, average1, count, bpp,  Time, MSE1, MSE2, step_count); 
    fprintf(fid,'\n%s \t  %s \t %5.0f \t %5.0f \t %s \t %8.2f \t %8.2f \t %8.2f \t  %8.2f \t%8.2f \t %d \t%8.2f \t%8.2f \t%8.2f \t %8.2f \t%8.2f \t ',f_secret, 'proposed', n, NZ, f_n, PSNR1, PSNR2, average1, count, bpp,  Time, MSE1, MSE2, step_count); 
    
    
end  

fclose(fid); 
 



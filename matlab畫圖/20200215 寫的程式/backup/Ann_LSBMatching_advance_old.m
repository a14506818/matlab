function [PSNRs1 PSNRs2] =  Ann_LSBMatching_advance (f_attack, f_secret, f_n, file_path, secret_array, isColorImage, file_experiment,  bpp_S, isRSAttack, total_secret, sorted_ind_odd, sorted_ind_even)
sorted_ind_even

sorted_ind_even = sorted_ind_even  - 1  
sorted_ind_odd= sorted_ind_odd  - 1  
 even_newValue = [1 0 3 2]; 
 odd_newValue = [2 0 3 1];  

 
tic;
Time=0;
  

 
fid= fopen(file_experiment, 'a+');
fid_att= fopen(f_attack, 'a+');


if isColorImage == 1 %彩色影像
   cover=imread(file_path); %原始影像
   Gray=rgb2gray(cover); 
else
   Gray=imread(file_path); %原始影像
end
  [rows,cols]=size(Gray); %設定長與寬=Gray的長與寬
bpp_PSNRs=bpp_S;
Cap_goal = ceil(bpp_PSNRs*rows*cols);
PSNRs=zeros(20,2);
PSNROriginals=zeros(20,2);
index_PSNRs=1;  

%  
% Tdebug = 0;  
%  
%  Gray =  [5 0 20 15; 20 20 15 20; 5 10 20 15; 20 20 15 20] 
%    Gray =  [5 0 20 15; 20 255 15 20] 
%  

%  
% % 
% bpp_PSNRs=bpp_S;
% Cap_goal = ceil(bpp_PSNRs*rows*cols);
% PSNRs=zeros(20,2);
% PSNROriginals=zeros(20,2);
% index_PSNRs=1;  
% 
Stego1=Gray;  
Stego2=Gray;  

Stego3=Gray;  
Stego4=Gray;  

count = 0; 
% 
% %  
% % Now_embed = 1;
% % nonembedding = 0; 
%  
% Time=0;
%    fail = 0 ; 

 step_count = 1; 
 [secre_row secre_col] = size(secret_array ); 
 

% %  總藏入機密符號數
% total_hiding_symbol = 0;  
 Zlength = 4; 
%  
 
for i=1:rows 
    j = 1; 
    while( j <= cols)
             pixel = Gray (i,j)  ; 
             mod (pixel,2) ;
%                     不能藏則設跟原始像素一樣即可 
            if (Gray (i,j) >=  255 || Gray (i,j) <= 0 )
                  Stego1(i,j) = Gray (i,j) ; 
                  Stego2(i,j) = Gray (i,j) ; 
                  Stego3(i,j) = Gray (i,j) ; 
                  Stego4(i,j) = Gray (i,j) ;                   
            else
                if (step_count < secre_col)
                   d = secret_array(step_count);
                   step_count=step_count+1; 
                else
                   d = randi(Zlength) - 1  ;    
                end 
                d ;
                count = count + 2; 
                if ( mod (pixel,2) == 0 )
%                   even 
                    switch (d)
                        case {0}
                             Stego1(i, j ) =  Stego1(i, j )   ;
                             Stego2(i, j ) = Stego2(i, j ) - 1;
                             
                        case {1}
                             Stego1(i, j ) =  Stego1(i, j )   ;
                             Stego2(i, j ) = Stego2(i, j ) ;

                             
                        case {2}
                              Stego1(i, j ) =  Stego1(i, j )  +1 ;
                             Stego2(i, j ) = Stego2(i, j ) - 1;

                            
                        case {3}
                             Stego1(i, j ) =  Stego1(i, j )  -1 ;
                             Stego2(i, j ) = Stego2(i, j ) ;
                    end
                    
                    new_d = even_newValue ( find(sorted_ind_even ==  d)  )  ;
%                     re-encode 
                     switch (new_d)
                        case {0}
                             Stego3(i, j ) =  Stego3(i, j )   ;
                             Stego4(i, j ) = Stego4(i, j ) - 1;
                             
                        case {1}
                             Stego3(i, j ) =  Stego3(i, j )   ;
                             Stego4(i, j ) = Stego4(i, j ) ;

                             
                        case {2}
                              Stego3(i, j ) =  Stego3(i, j )  +1 ;
                              Stego4(i, j ) = Stego4(i, j ) - 1;
                        case {3}
                             Stego3(i, j ) =  Stego3(i, j )  -1 ;
                             Stego4(i, j ) = Stego4(i, j ) ;
                    end
                    Stego1;
                    Stego2;
                    
                else 
                    
                    switch (d)
                        case {0}
                             Stego1(i, j ) =  Stego1(i, j ) - 1  ;
                             Stego2(i, j ) = Stego2(i, j ) ;
                             
                        case {1}
                             Stego1(i, j ) =  Stego1(i, j )  +1  ;
                             Stego2(i, j ) = Stego2(i, j ) - 1;

                             
                        case {2}
                              Stego1(i, j ) =  Stego1(i, j )  ;
                             Stego2(i, j ) = Stego2(i, j ) ;

                            
                        case {3}
                             Stego1(i, j ) =  Stego1(i, j )  ;
                             Stego2(i, j ) = Stego2(i, j ) -1 ;
                    end      
                    
                    new_d = odd_newValue ( find(sorted_ind_odd ==  d)  )  ;
%                     re-encode 
                     switch (new_d)
                        case {0}
                             Stego3(i, j ) =  Stego3(i, j ) - 1  ;
                             Stego4(i, j ) = Stego4(i, j ) ;
                             
                        case {1}
                             Stego3(i, j ) =  Stego3(i, j )  +1  ;
                             Stego4(i, j ) = Stego4(i, j ) - 1;

                             
                        case {2}
                              Stego3(i, j ) =  Stego3(i, j )  ;
                             Stego4(i, j ) = Stego4(i, j ) ;

                            
                        case {3}
                             Stego3(i, j ) =  Stego3(i, j )  ;
                             Stego4(i, j ) = Stego4(i, j ) -1 ;
                    end
                    
                    Stego3;
                    Stego4;
                    
                  if ( index_PSNRs < 21   )
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
                            PSNR4= 100;
                        end

                        average2= (PSNR3 + PSNR4)/2;
                            PSNRs2(index_PSNRs,1)=bpp;
                            PSNRs2(index_PSNRs,2)=average2;                            

                                        if (isRSAttack == 1)

                                                fileword3 = [  'experimental results\stego_' f_n '3.jpg'] ;
                                                imwrite(Stego3, fileword3, 'jpg');
                                                fileword4 = [   'experimental results\stego_' f_n '4.jpg'] ;
                                                imwrite(Stego4, fileword4,'jpg');
        %                                         
                                                 [R_FM_G, S_FM_G, U_FM_G, R_M_G, S_M_G, U_M_G] = RSAttack(fileword3);
                                                 fprintf(fid_att,'\n%s \t %8.2f \t %8.2f \t %8.2f \t %8.2f \t %8.2f \t %8.2f \t %8.2f\t', 'stego1', R_FM_G, S_FM_G, U_FM_G, R_M_G, S_M_G, U_M_G, count); 
                                                 [R_FM_G, S_FM_G, U_FM_G, R_M_G, S_M_G, U_M_G] = RSAttack(fileword4);
                                                 fprintf(fid_att,'\n%s \t %8.2f \t %8.2f \t %8.2f \t %8.2f \t %8.2f \t %8.2f \t %8.2f\t', 'stego1', R_FM_G, S_FM_G, U_FM_G, R_M_G, S_M_G, U_M_G, count); 
                                                 
                                        end                     
                         index_PSNRs=index_PSNRs+1;
                         bpp_PSNRs= bpp_PSNRs+bpp_S;
                         Cap_goal = floor(bpp_PSNRs*rows*cols);
                    end                    
                  end 
                    
                end 
            end 
            j=j+1 ;
    end
end 
count

Time=Time+toc;

                bpp = count/ (rows*cols*2);
                [PSNR1 MSE1]=clacImage(Gray,Stego1) 
                [PSNR2 MSE2]=clacImage(Gray,Stego2) 
                
                
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
 
                 
                [PSNR3 MSE3]=clacImage(Gray,Stego3) 
                [PSNR4 MSE4]=clacImage(Gray,Stego4) 
                
                
                if (MSE3 ==0)
                    PSNR3 = 100;
                end
                if (MSE4 ==0)
                    PSNR4 = 100;
                end
%                 
                
                average2= (PSNR3 + PSNR4)/2;
                    PSNRs2(index_PSNRs,1)=bpp;
                    PSNRs2(index_PSNRs,2)=average2;
                    
                                         if (isRSAttack == 1)

                                                fileword3 = [  'experimental results\stego_' f_n '_3.jpg'] ;
                                                imwrite(Stego3, fileword3, 'jpg');
                                                fileword4 = [   'experimental results\stego_' f_n '_4.jpg'] ;
                                                imwrite(Stego4, fileword4,'jpg');
        %                                         
                                                 [R_FM_G, S_FM_G, U_FM_G, R_M_G, S_M_G, U_M_G] = RSAttack(fileword3);
                                                 fprintf(fid_att,'\n%s \t %8.2f \t %8.2f \t %8.2f \t %8.2f \t %8.2f \t %8.2f \t %8.2f\t', 'stego1', R_FM_G, S_FM_G, U_FM_G, R_M_G, S_M_G, U_M_G, count); 
                                                 [R_FM_G, S_FM_G, U_FM_G, R_M_G, S_M_G, U_M_G] = RSAttack(fileword4);
                                                 fprintf(fid_att,'\n%s \t %8.2f \t %8.2f \t %8.2f \t %8.2f \t %8.2f \t %8.2f \t %8.2f\t', 'stego1', R_FM_G, S_FM_G, U_FM_G, R_M_G, S_M_G, U_M_G, count); 
                                                 
                                         end            
                                        
    fileword3 = [ 'experimental results\' 'PNGstego_' f_n '_3'  '.png'  ];
    imwrite(Stego3,fileword3,'png');
    fileword4 = [ 'experimental results\' 'PNGstego_' f_n '_4' '.png' ] ;
    imwrite(Stego4,fileword4,'png');
 
%   
%      for i=1:2
%             titleWord = [f_n ' Stego1 ']; 
%             computeHistogram (Gray, Stego3 ,  titleWord, i); 
%             titleWord = [f_n ' Stego2']; 
%             computeHistogram (Gray, Stego4 ,  titleWord, i); 
%      end 

 % 
%                         
    fprintf('\n%s \t %s \t   %s \t %8.2f \t %8.2f \t %8.2f \t  %8.2f \t%8.2f \t %d \t%8.2f \t%8.2f \t%8.2f \t %8.2f \t \t%8.2f',f_secret,  'Tseng',  f_n, PSNR1, PSNR2, average1, count, bpp,  Time, MSE1, MSE2, step_count); 
    fprintf(fid,'\n%s \t  %s \t  %s \t %8.2f \t %8.2f \t %8.2f \t  %8.2f \t%8.2f \t %d \t%8.2f \t%8.2f \t%8.2f \t %8.2f \t%8.2f \t ',f_secret, 'Tseng',   f_n, PSNR1, PSNR2, average1, count, bpp,  Time, MSE1, MSE2, step_count); 

    fprintf('\n%s \t %s \t   %s \t %8.2f \t %8.2f \t %8.2f \t  %8.2f \t%8.2f \t %d \t%8.2f \t%8.2f \t%8.2f \t %8.2f \t \t%8.2f',f_secret,  'proposed',  f_n, PSNR3, PSNR4, average2, count, bpp,  Time, MSE3, MSE4, step_count); 
    fprintf(fid,'\n%s \t  %s \t  %s \t %8.2f \t %8.2f \t %8.2f \t  %8.2f \t%8.2f \t %d \t%8.2f \t%8.2f \t%8.2f \t %8.2f \t%8.2f \t ',f_secret, 'proposed',   f_n, PSNR3, PSNR4, average2, count, bpp,  Time, MSE3, MSE4, step_count); 
            
fclose(fid); 

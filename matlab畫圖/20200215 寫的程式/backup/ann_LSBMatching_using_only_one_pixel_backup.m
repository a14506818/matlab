function [PSNRs1 ] = ann_LSBMatching_using_only_one_pixel(f_attack, f_secret, f_n, file_path,  kindImage, file_experiment,  bpp_S, total_count, secret_image_array, secret_array_String, sorted , sorted_ind, histogram_total)
 
is_debug = 0;   %�O�_�ndebug 1 �O 0 �_
% kindImage = 1;  %Ū���v�������� 1:�Ƕ�  2:��� 3:�۳а}�C
is_extraction = 0;  %�O�_�n���X 1 �O 0 �_

secret_file =   f_secret  ; %'images/Dolphin.tif'; 
orginalImage =  file_path  ; %'images/Airplane362.tif'; 

k = f_n; 
file1 = 'error.xls'; 
fileID = fopen(file1,'w');
fprintf(fileID,'A \t LSB \t F \t m1 \t m2 \t d \t co_d \t SA1 \t SA2 \t adj_1 \t adj_2 \t coveredA \t error');
 
 
 switch (kindImage)
     case {1}
        Gray = imread(orginalImage) ; %��l�v��     
        secret_image =imread(secret_file); %��l�v��     
      case {2}
        Gray = rgb2gray(imread(orginalImage) ); %��l�v��  
        secret_image =  rgb2gray(imread(secret_file) ) ;
     case {3}
        Gray =  [5 0 10 15; 20 20 15 20; 5 10 20 15; 20 20 15 20] ; 
        secretFile =  [35 70 80 105; 220 220 125 210; 35 130 230 135; 230 220 215 220] ; 
 end 
 
 ['�v�����R��']

%  Ū���K�ɮשM���� �έp historgram 
%      [total_count ,  secret_image_array, secret_array_String, sorted , sorted_ind, histogram_total] =	 ReadSecretImage_withOrignalImage_20200215(secret_image, kindImage, 2, fid_his, Gray );  % proposed scheme read secret Image   ReadSecretImage_withOrignalImage(secret_file , kindImage, k, fid_his, orginalImage) 
%  [secre_row secre_col] = size(secret_image_array ); 
 
tic;
Time=0;

 
fid= fopen(file_experiment, 'a+');
fid_att= fopen(f_attack, 'a+');

[rows,cols]=size(Gray); %�]�w���P�e=Gray�����P�e
bpp_PSNRs=bpp_S;
Cap_goal = ceil(bpp_PSNRs*rows*cols);
PSNRs=zeros(20,2);
PSNROriginals=zeros(20,2);
index_PSNRs=1;  
 

stego1 = Gray; 
stego2 =  Gray; 
  
count = 0; 
secret_array_index = 0; 
edge_pixel = 0; 

case_count = zeros(1,4); 
payload = 0; 



for i=1:rows 
    j = 1; 
    while( j <= cols)
             A = double( Gray (i,j) )   ;
             
%           �����ëh�������t������ 3 
            if (A ==  255 || A == 0 )
                  edge_pixel  = edge_pixel + 1; 
%                 �����첣�ͮ�
                  if ( A ==  255  )
                      SA1 = 255; 
                      SA2 = 252;
                  else 
                      SA1 = 3; 
                      SA2 = 0;
                  end 
            else
%                 �i�H�ê���X�@�Өp�K�T��
                  count = count + 2 ;
                 
                     %�@�Өp�K�T���A�N���äJ�G�Ӧ줸
                     secret_array_index = secret_array_index + 1; 
                     
                    if ( total_count >= secret_array_index )
                          d = secret_image_array(secret_array_index) ;
                    else 
                          d  = randi(2^k)-1; 
                    end 
                    d = double (d); 
                    
                    m1 = floor(d/2)    ;
                    m2 = mod(d,2)  ; 
                    
                    %LSB �O��l�������_����
                    LSB =  mod( A , 2) ;
                     
                    %F �� �O��l������F ��ƭ�
                    F = mod( floor(A/2) + A , 2) ;
                    F2 = mod( floor((A+1)/2) + A , 2) ;
                    if ( LSB == m1 )
                        if (F == m2)
                            ['case 1'];
                            case_count(1) = case_count(1) + 1; 
                            SA1 = A;
                            SA2 = A;
                        else 
                            ['case 2'];
                            case_count(2) = case_count(2) + 1; 
                            SA1 = A ;
                            SA2 = A + 1;
                        end 
                    else
                        if (F2 == m2)
                            ['case 3'];
                            case_count(3) = case_count(3) + 1; 
                            SA1 = A + 1;
                            SA2 = A;
                        else
                             ['case 4'];
                             case_count(4) = case_count(4) + 1; 
                            SA1 = A - 1;
                            SA2 = A + 1;
                        end 

                    end 
                 
                  if (is_debug == 1)
                      ['A = ' num2str(A) ' d = ' num2str(d) ' LSB = ' num2str(LSB) ' LSB = ' num2str(F) ' LSB = ' num2str(F2) ' SA1 = ' num2str(SA1) ' SA2 = ' num2str(SA2)]
                  end 
            end 
            stego1 (i,j)  = SA1;
            stego2 (i,j)  = SA2;
           
            j=j+1 ;
           
            
            if ( index_PSNRs < 21   )
                    if count  - Cap_goal == 0 | ( count - Cap_goal <= 100 & count-Cap_goal > 0 )
                        bpp = count/ (rows*cols*2);
                        [PSNR1 MSE1]=clacImage(Gray,stego1);
                        [PSNR2 MSE2]=clacImage(Gray,stego2);
                        if (MSE1 ==0)
                            PSNR1 = 100;
                        end
                        if (MSE2 ==0)
                            PSNR2 = 100;
                        end

                        average1= (PSNR1 + PSNR2)/2;
                            PSNRs1(index_PSNRs,1)=bpp;
                            PSNRs1(index_PSNRs,2)=average1;


%                         [PSNR3 MSE3]=clacImage(Gray,Stego3);
%                         [PSNR4 MSE4]=clacImage(Gray,Stego4);
%                         if (MSE3 ==0)
%                             PSNR3 = 100;
%                         end
%                         if (MSE4 ==0)
%                             PSNR4= 100;
%                         end

%                         average2= (PSNR3 + PSNR4)/2;
%                             PSNRs2(index_PSNRs,1)=bpp;
%                             PSNRs2(index_PSNRs,2)=average2;                            

%                                         if (isRSAttack == 1)
% 
%                                                 fileword3 = [  'experimental results\stego_' f_n '3.jpg'] ;
%                                                 imwrite(Stego3, fileword3, 'jpg');
%                                                 fileword4 = [   'experimental results\stego_' f_n '4.jpg'] ;
%                                                 imwrite(Stego4, fileword4,'jpg');
%         %                                         
%                                                  [R_FM_G, S_FM_G, U_FM_G, R_M_G, S_M_G, U_M_G] = RSAttack(fileword3);
%                                                  fprintf(fid_att,'\n%s \t %8.2f \t %8.2f \t %8.2f \t %8.2f \t %8.2f \t %8.2f \t %8.2f\t', 'stego1', R_FM_G, S_FM_G, U_FM_G, R_M_G, S_M_G, U_M_G, count); 
%                                                  [R_FM_G, S_FM_G, U_FM_G, R_M_G, S_M_G, U_M_G] = RSAttack(fileword4);
%                                                  fprintf(fid_att,'\n%s \t %8.2f \t %8.2f \t %8.2f \t %8.2f \t %8.2f \t %8.2f \t %8.2f\t', 'stego1', R_FM_G, S_FM_G, U_FM_G, R_M_G, S_M_G, U_M_G, count); 
%                                                  
%                                         end                     
                         index_PSNRs=index_PSNRs+1;
                         bpp_PSNRs= bpp_PSNRs+bpp_S;
                         Cap_goal = floor(bpp_PSNRs*rows*cols);
                    end                    
                  end 
            
             
    end
end 
payload = count; 
PSNR_1 = clacImage(Gray, stego1)   
PSNR_2 = clacImage(Gray, stego2) 
PSNR_avg = ( PSNR_1 + PSNR_2 ) / 2 
bpp =double( payload ) / double((rows * cols)*2 )

['�|�� case �����G']
case_count

Time=Time+toc;
                bpp = count/ (rows*cols*2);
                [PSNR1 MSE1]=clacImage(Gray,stego1) 
                [PSNR2 MSE2]=clacImage(Gray,stego2) 
                
                
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
 
                 
%                 [PSNR3 MSE3]=clacImage(Gray,stego3) 
%                 [PSNR4 MSE4]=clacImage(Gray,stego4) 
%                 
%                 
%                 if (MSE3 ==0)
%                     PSNR3 = 100;
%                 end
%                 if (MSE4 ==0)
%                     PSNR4 = 100;
%                 end
% %                 
%                 
%                 average2= (PSNR3 + PSNR4)/2;
%                     PSNRs2(index_PSNRs,1)=bpp;
%                     PSNRs2(index_PSNRs,2)=average2;
%                     
%                                          if (isRSAttack == 1)
% 
%                                                 fileword3 = [  'experimental results\stego_' f_n '_3.jpg'] ;
%                                                 imwrite(stego3, fileword3, 'jpg');
%                                                 fileword4 = [   'experimental results\stego_' f_n '_4.jpg'] ;
%                                                 imwrite(stego4, fileword4,'jpg');
%         %                                         
%                                                  [R_FM_G, S_FM_G, U_FM_G, R_M_G, S_M_G, U_M_G] = RSAttack(fileword3);
%                                                  fprintf(fid_att,'\n%s \t %8.2f \t %8.2f \t %8.2f \t %8.2f \t %8.2f \t %8.2f \t %8.2f\t', 'stego1', R_FM_G, S_FM_G, U_FM_G, R_M_G, S_M_G, U_M_G, count); 
%                                                  [R_FM_G, S_FM_G, U_FM_G, R_M_G, S_M_G, U_M_G] = RSAttack(fileword4);
%                                                  fprintf(fid_att,'\n%s \t %8.2f \t %8.2f \t %8.2f \t %8.2f \t %8.2f \t %8.2f \t %8.2f\t', 'stego1', R_FM_G, S_FM_G, U_FM_G, R_M_G, S_M_G, U_M_G, count); 
%                                                  
%                                          end            
%                                         
%     fileword3 = [ 'experimental results\' 'PNGstego_' f_n '_3'  '.png'  ];
%     imwrite(stego3,fileword3,'png');
%     fileword4 = [ 'experimental results\' 'PNGstego_' f_n '_4' '.png' ] ;
%     imwrite(stego4,fileword4,'png');
%     
    fprintf('\n%s \t %s \t   %s \t %8.2f \t %8.2f \t %8.2f \t  %8.2f \t%8.2f \t %d \t%8.2f \t%8.2f \t%8.2f \t %8.2f \t \t%8.2f',f_secret,  'p-nonorder',  f_n, PSNR1, PSNR2, average1, count, bpp,  Time, MSE1, MSE2, payload); 
    fprintf(fid,'\n%s \t  %s \t  %s \t %8.2f \t %8.2f \t %8.2f \t  %8.2f \t%8.2f \t %d \t%8.2f \t%8.2f \t%8.2f \t %8.2f \t%8.2f \t ',f_secret, 'p-nonorder',   f_n, PSNR1, PSNR2, average1, count, bpp,  Time, MSE1, MSE2, payload); 

%     fprintf('\n%s \t %s \t   %s \t %8.2f \t %8.2f \t %8.2f \t  %8.2f \t%8.2f \t %d \t%8.2f \t%8.2f \t%8.2f \t %8.2f \t \t%8.2f',f_secret,  'proposed',  f_n, PSNR3, PSNR4, average2, count, bpp,  Time, MSE3, MSE4, payload); 
%     fprintf(fid,'\n%s \t  %s \t  %s \t %8.2f \t %8.2f \t %8.2f \t  %8.2f \t%8.2f \t %d \t%8.2f \t%8.2f \t%8.2f \t %8.2f \t%8.2f \t ',f_secret, 'proposed',   f_n, PSNR3, PSNR4, average2, count, bpp,  Time, MSE3, MSE4, payload); 
            
fclose(fid); 




% recover �L�{
if (is_extraction  == 1)
    ['���X�L�{���R��....']
    secret_array_index = 0 ; 
    recover = floor( ( double (stego1) + double (stego2) )/ 2  ); 
    error_c = 0; 
    for i=1:rows 
       for j=1:cols
            A = double( Gray (i,j) )  ;
            %LSB �O��l�������_����
            LSB =  mod( A , 2) ;

            %F �� �O��l������F ��ƭ�
            F = mod( floor(A/2) + A , 2) ;

             SA1 = double( stego1(i,j));
             SA2 =  double( stego2(i,j));
             CoveredA = floor( (SA1 + SA2) / 2 );

             if ( abs(SA1 - SA2) <= 2)
                      if ( CoveredA ~= A )
                            error_c = error_c +1 ;
                            CoveredA;
                            A;
                       end 
                      m1 =  mod( SA1 , 2) ;
                     if ( abs(SA1 - SA2) < 2  )
                         eF = mod( floor(SA1/2) + SA2 , 2);
                         m2 =  mod (eF ,2) ;
                    else
        %             �Y�ϥβĥ|�ؤ覡�äJ�A A+1, A-1 �]�G�Ӯt���j�󵥩� 2�^�A�h���X�ɧQ�� SA1 �M Covered �����X�ĤG�ӰT��

                         eF = mod( floor(SA1/2) + CoveredA , 2);
                         m2 =  mod (eF ,2) ;

                     end 
                      co_d = m1* 2 + m2; 

                      secret_array_index = secret_array_index + 1; 
                     if ( total_count >= secret_array_index )
                          d = secret_image_array(secret_array_index) ;
                          if ( d ~= co_d)
                               error_c = error_c +1 ;
                               d;
                               co_d;

                          end 


                             [ num2str(d) ' ' num2str(m1) ' ' num2str(m2) ' ' num2str(A) ' ' num2str(LSB) ' ' num2str(F)   num2str(SA1) ' ' num2str(SA2)] ;
                            fprintf(fileID,'\n%d \t %d \t %d \t %d \t %d \t %d \t %d \t %d \t %d \t %d \t %d \t %d \t %d ', A,LSB ,F, m1, m2, d, co_d, SA1,SA2, (SA1-A), (SA2-A), CoveredA, error_c );


                     end 

             end 



       end 
    end 

error_c
fclose(fileID); 
['���X����']
end 
 
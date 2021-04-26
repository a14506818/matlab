
clc;
clear all;
isDrawFigure=0;
isColorImage = 0;
file_experiment='';
isRSAttack = 0 ; 

file_path2='images'; %修改路徑位置
CompairWithMySelf = 7; 
%  CompairWithMySelf :
%                     0 =  
%                             array_name=char ( 'BlockFolding(B=3,K=3,RE=0)', 'BlockFolding(B=3,K=3,RE=1)', 'BlockFolding(B=3,K=4,RE=0)', 'BlockFolding(B=3,K=4,RE=1)',  'BlockFolding(B=5,K=3,RE=0)', 'BlockFolding(B=5,K=3,RE=1)',  'BlockFolding(B=5,K=4,RE=0)', 'BlockFolding(B=5,K=4,RE=1)'); 
%                     1 = 
%                             array_name=char ( 'BlockFolding(B=3,K=3,RE=0)', 'BlockFolding(B=3,K=3,RE=1)',   'BlockFolding(B=5,K=4,RE=0)', 'BlockFolding(B=5,K=4,RE=1)', 'Lu2016(K=3)', 'Lu2015(K=3)' , 'NonFolding(K=3)', 'Lu2016(K=4)', 'Lee2009', 'Lee2013', 'Chang2013' ); 
%                     3 = 
%                             array_name=char ( 'BlockFolding(B=3,K=3,RE=0)', 'BlockFolding(B=3,K=3,RE=1)', 'BlockFolding(B=3,K=4,RE=0)', 'BlockFolding(B=3,K=4,RE=1)',  'BlockFolding(B=5,K=3,RE=0)', 'BlockFolding(B=5,K=3,RE=1)',  'BlockFolding(B=5,K=4,RE=0)', 'BlockFolding(B=5,K=4,RE=1)', 'Lee2009', 'Lee2013', 'Chang2013', 'Lu2015(K=3)', 'NonFolding(K=3)' ); 
%                     4 = stegona analysis  
%                             PSNRs16 - 20 , lu2015 ... 
%                     5 = RSAttack
%                     6 = compute histogram
%                     7 = 單方法比較

file_title_word = ['com_' int2str(CompairWithMySelf) '_'];
 
% 一般灰階
kindImage = 1; 

% stego_image_array = char('Logo', 'Logo350', 'Dolphin',   'Brain', 'Leg', 'MandrillSec', 'TiffanySec'  ); 
%  stego_image_array = char( 'Dolphin' ); 
stego_image_array = char('random'); 

%    file_name_array = char('Airplane', 'Tiffany', 'Lake',  'Mandrill' ,'Pepper'); 
file_name_array = char( 'Lena'); 
[Img_num, data] = size(file_name_array); 
[secret_Img_num, data] = size(stego_image_array); 
max_point = 0; 
for p = 1:secret_Img_num
     stego_image =  deblank(stego_image_array(p,:));
     secretFile =  ['images\' stego_image '.tif'];
     f_his = [ 'experimental results\' file_title_word 'histogram_' stego_image '_'  datestr(now,7) '.xls'];
     fid_his= fopen(f_his, 'w');
      
     
       for k = 1:Img_num %Img_num  %那些影像要進去 1:6
            f_n = deblank(file_name_array(k,:));
            file_path=[ 'images\' f_n '512x512.tif'];  %輸入圖片路徑

            fprintf('\nPROPOSE=%s\n', file_path);
            file_title = [ 'experimental results\' stego_image '_Experiment_T=2'  ];
            file_experiment = [ file_title '.xls'];
             f_attack = [  file_title '_RS.xls' ] ;
             T_number =2; 
            
             [total_count ,  secret_image_array, secret_array_String, sorted , sorted_ind, histogram_total] =	 ReadSecretImage_withOrignalImage_20200215(secretFile, kindImage, 2, fid_his, file_path );  % proposed scheme read secret Image   ReadSecretImage_withOrignalImage(secret_file , kindImage, k, fid_his, orginalImage) 
             bpp_S=( total_count*2/512/512/20 );
             
              [PSNRs1 PSNRs2] = ann_LSBMatching_using_only_one_pixel(f_attack, secretFile, f_n, file_path,  kindImage, file_experiment,  bpp_S, total_count ,  secret_image_array, secret_array_String, sorted , sorted_ind, histogram_total) ; 
               PSNRs1 = clearPSNRZero(PSNRs1);
                        if (max_point <  PSNRs1(length(PSNRs1), 1)) 
                            max_point = PSNRs1(length(PSNRs1), 1) + 0.3; 
                        end
                PSNRs2 = clearPSNRZero(PSNRs2);
                        if (max_point <  PSNRs2(length(PSNRs2), 1)) 
                            max_point = PSNRs2(length(PSNRs2), 1) + 0.3; 
                        end
                    PSNRArray =  {PSNRs1,PSNRs2 };
                    array_name=char ( 'P-nonOrder', 'P-Order'); % array_name=char ( 'P_nonOrder', 'LSB-MA'); 
                    createfigure_BLOCK(PSNRArray, array_name, f_n, stego_image, 2, max_point, 0);
       end 
       
     
     
end 
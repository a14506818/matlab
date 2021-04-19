clc;
clear all;
isDrawFigure=0;
isColorImage = 0;
file_experiment='';
%當MSE = 0 時 PSNR設為 100 才畫得出線

 showdetail = 0 ; 
 
% 一般灰階
kindImage = 1; 
% stego_image_array = char('Logo', 'Logo350', 'Dolphin', 'IM', 'Brain', 'Leg', 'MandrillSec', 'TiffanySec', 'Google','PepperSec','AirplaneSec','LakeSec','LenaSec', 'random'); 
 stego_image_array = char( 'MandrillSec','random','Dolphin'); 


 
% 測試醫學影像
% kindImage = 2; 
% stego_image = '000005';
% secretFile =  ['images\' stego_image '.dcm'];

file_name_array = char('Airplane', 'Tiffany', 'Lake', 'Lena', 'Mandrill' ,'Pepper'); 
%  file_name_array = char('Tiffany'); 
[Img_num, data] = size(file_name_array); 

[secret_Img_num, data] = size(stego_image_array); 
 bpp = 3.0;

 Proposed_T_number = 3; % 2 or 3 
 T_number = 4; 
 k = Proposed_T_number; 
 for p = 1:secret_Img_num
     stego_image =  deblank(stego_image_array(p,:));
     secretFile =  ['images\' stego_image '.tif'];
     f_his = ['experimental results\' stego_image '\histogram_' stego_image '_' num2str(month(date)) '_' num2str(day(date)) '.xls'];
     fid_his= fopen(f_his, 'w');
     
    %the number of secret bits concealed in a pixel 
    fprintf(fid_his, '\n Secret Image= %s \t T_number \t %d', secretFile, Proposed_T_number);
    [total_secret_T , message_T, secret_array_T, secret_array_String_T,  reEncode_A, reEncode_B, return_indicator] = ReadSecretImage(secretFile, kindImage, Proposed_T_number, fid_his) ; % proposed scheme read secret Image
    fprintf('read Secret Image= %s  Proposed_T_number = %8.2f', secretFile, Proposed_T_number); 
   
    
    fprintf(fid_his, '\n Secret Image= %s \t T_number \t %d', secretFile, 4);
    [total_secret , message, secret_array, secret_array_String, reEncode_A_T4, reEncode_B_T4, return_indicator_T] = ReadSecretImage(secretFile, kindImage, 4, fid_his) ; % read secret Image
    fprintf('read Secret Image= %s', secretFile); 
    
     
    file_experiment = ['experimental results\' stego_image 'Experiment_' num2str(month(date)) '_' num2str(day(date)) '_Gray_T_' num2str(Proposed_T_number) '_' stego_image '.xls'];

    fid= fopen(file_experiment, 'w');
    fprintf(fid,'\nmethod \t first_hidding_bit \t file_name \t Stego 1 \t Stego 2 \t average1 \t  Capacity \t bpp \t Proposed_T_number \t time \t MSE1 \t MSE2 \t total_Secret \t m \t n \t fail');
     max_point = 0; 
        Block_array_size = 3; 
     for k = 1:Img_num %Img_num  %那些影像要進去 1:6
            f_n = deblank(file_name_array(k,:));
            file_path=[ 'images\' f_n '512x512.tif'];  %輸入圖片路徑

            fprintf('\nPROPOSE=%s\n', file_path);

             first_hiddingbit = T_number; 
    %  proposed scheme with T_nmber = 3
            bpp_S=( total_secret*3/512/512/20 );
%             
%           T= 3
 
            [PSNRs8 PSNRs9] = Ann_dual_two_Difference_zone_Block(bpp_S,bpp_S, file_path,   Proposed_T_number, isDrawFigure, isColorImage, file_experiment, total_secret, message, secret_array, reEncode_A, reEncode_B,  showdetail, return_indicator ,Block_array_size  );
            PSNRs8 = clearPSNRZero(PSNRs8);
            PSNRs9 = clearPSNRZero(PSNRs9);
            
%           T= 4
          
            [PSNRs10 PSNRs11] = Ann_dual_two_Difference_zone_Block(bpp_S,bpp_S, file_path,   4, isDrawFigure, isColorImage, file_experiment, total_secret, message, secret_array, reEncode_A_T4, reEncode_B_T4,  showdetail, return_indicator_T,Block_array_size   );
            PSNRs10 = clearPSNRZero(PSNRs10);
            PSNRs11 = clearPSNRZero(PSNRs11);           
            
            
            [PSNRs1 PSNRs2 PSNRs3] = Ann_dual_Propose_message_historgram( bpp_S, bpp_S, file_path,Proposed_T_number, isDrawFigure, isColorImage, file_experiment, total_secret_T , message_T, secret_array_T);
            PSNRs1 = clearPSNRZero(PSNRs1);
            PSNRs2 = clearPSNRZero(PSNRs2);
            PSNRs3 = clearPSNRZero(PSNRs3);

            max_point = PSNRs1(length(PSNRs1), 1) + 0.3; 
            
    %  proposed scheme with T_nmber = 4
            bpp_S=( total_secret*4/512/512/20 );
            [PSNRs7 PSNRsd PSNRsf] = Ann_dual_Propose_message_historgram(bpp_S,bpp_S, file_path, 4, isDrawFigure, isColorImage, file_experiment, total_secret , message, secret_array);
            PSNRs7 = clearPSNRZero(PSNRs7);
    
            if (max_point <  PSNRs7(length(PSNRs7), 1)) 
                max_point = PSNRs7(length(PSNRs7), 1) + 0.3; 
            end 
    %         Lee_2009
            bpp_S=(total_secret*2/512/512/20 );
            [PSNRs4] =  Lee_Embedding2009(bpp_S,bpp_S,file_path, file_experiment, total_secret, message, secret_array, secret_array_String);
            PSNRs4 = clearPSNRZero(PSNRs4);

            if (max_point <  PSNRs4(length(PSNRs4), 1)) 
                max_point = PSNRs4(length(PSNRs4), 1) + 0.3; 
            end
            
    %         Lee_2013       s
            bpp_S=(total_secret*2/512/512/20 );
            [PSNRs5] =  LeeEmbedding2013(bpp_S,bpp_S,file_path, file_experiment, total_secret, message, secret_array, secret_array_String);
            PSNRs5 = clearPSNRZero(PSNRs5);
            if (max_point <  PSNRs5(length(PSNRs5), 1)) 
                max_point = PSNRs5(length(PSNRs5), 1) + 0.3; 
            end

     %         Chang_2013       
            bpp_S=(total_secret*2/512/512/20 );
            [PSNRs6] =  changEmbedding2013(bpp_S,bpp_S,file_path, file_experiment, total_secret, message, secret_array, secret_array_String);
            PSNRs6 = clearPSNRZero(PSNRs6);
            if (max_point <  PSNRs6(length(PSNRs6), 1)) 
                max_point = PSNRs6(length(PSNRs6), 1) + 0.3; 
            end

            createfigure(PSNRs1,PSNRs2,PSNRs3,PSNRs4,PSNRs5,PSNRs6,PSNRs7, PSNRs8, PSNRs9,  PSNRs10,  PSNRs11, f_n, stego_image, T_number, max_point);

     end 
 end 
 


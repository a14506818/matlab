clc;
clear all;
isDrawFigure=0;
isColorImage = 0;
file_experiment='';
isRSAttack = 0 ; 
file_path2='images'; %修改路徑位置

% file_path2='d:\ucid.v2'; %修改路徑位置


  
  CompairWithMySelf = 10; 
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

%                    10 = 
%                             array_name=char ( 'BlockFolding(B=3,K=3,RE=0)', 'BlockFolding(B=3,K=3,RE=1)', 'BlockFolding(B=3,K=4,RE=0)', 'BlockFolding(B=3,K=4,RE=1)',  'BlockFolding(B=5,K=3,RE=0)', 'BlockFolding(B=5,K=3,RE=1)',  'BlockFolding(B=5,K=4,RE=0)', 'BlockFolding(B=5,K=4,RE=1)', 'Lee2009', 'Lee2013', 'Chang2013', 'Lu2015(K=3)', 'NonFolding(K=3)' ); 

%                    11 =加入秉中的


    file_title_word = ['com_' int2str(CompairWithMySelf) '_'];
    
    switch (CompairWithMySelf)
        case {5}
            isRSAttack = 1; 
            isDrawFigure=1;
        case {6}
             isDrawFigure=1;
        case {11}
             isDrawFigure=1;   
    end 
     
%當MSE = 0 時 PSNR設為 100 才畫得出線

 showdetail = 0; 
 
% 一般灰階
kindImage = 1; 
%  stego_image_array = char('Logo', 'Logo350', 'Dolphin',   'Brain', 'Leg', 'MandrillSec', 'TiffanySec'  ); 
% stego_image_array = char('random',   'Dolphin',   'Brain',  'MandrillSec',  'TiffanySec' ); 

  stego_image_array = char( 'random'); 


 
% 測試醫學影像
% kindImage = 2; 
% stego_image = '000005';
% secretFile =  ['images\' stego_image '.dcm'];

   %   file_name_array = char('Lena',  'Airplane', 'Tiffany', 'Lake',  'Mandrill' ,'Pepper'); 
  file_name_array = char( 'Lena'); 
% file_name_array = char ('Mandrill' ,'Pepper'); 
[Img_num, data] = size(file_name_array); 

[secret_Img_num, data] = size(stego_image_array); 
 bpp = 3.0;

 Proposed_T_number = 3; % 2 or 3 
 T_number = 4; 
 k = Proposed_T_number; 
 
%  parameter = [ [1 2]; [1 3]; [2 4]; [3 5]; [4 8]; [2 26]; [2 52]; [4 57]; [6 79]; [10 98] ]; 
  parameter = [ [3 7]; [2 7]; [2 4]; [1 3]; [1 2]; [1 1] ; [5 12] ; [4 8] ; [2 2]]; 
  
 %  parameter = [ [1 2]; [3 3]; [1 3]; [2 2]; [2 4]; [5 12]  ]; 

  
 for p = 1:secret_Img_num
     stego_image =  deblank(stego_image_array(p,:));
     secretFile =  ['images\' stego_image '.tif'];
     f_his = [ 'experimental results\' file_title_word 'histogram_' stego_image '_'  datestr(now,7) '.xls'];
     fid_his= fopen(f_his, 'w');
    
    %the number of secret bits concealed in a pixel 
    fprintf(fid_his, '\n Secret Image= %s \t T_number \t %d', secretFile, Proposed_T_number);
    [total_secret , message, secret_array, secret_array_String,  reEncode_A, reEncode_B, return_indicator, code] = ReadSecretImage(secretFile, kindImage, 3, fid_his) ; % proposed scheme read secret Image
    fprintf('read Secret Image= %s  Proposed_T_number = %8.2f', secretFile, Proposed_T_number); 
   
    original_message_3 = secret_array; 
    original_total_secret_3 = total_secret;
    
    fprintf(fid_his, '\n Secret Image= %s \t T_number \t %d', secretFile, 4);
    [total_secret_T , message_T, secret_array_T, secret_array_String_T, reEncode_A_T, reEncode_B_T, return_indicator_T, code_T] = ReadSecretImage(secretFile, kindImage, 4, fid_his) ; % read secret Image
    fprintf('read Secret Image= %s', secretFile); 
    original_message_4 = secret_array_T;
    original_total_secret_4 = total_secret_T;
     
    file_title = [ 'experimental results\'  file_title_word stego_image '_Experiment_Gray_T_' num2str(Proposed_T_number)  ]
    file_experiment = [ file_title '.xls'];

    f_attack = [  file_title '_RS.xls' ] 
    fid_att= fopen(f_attack, 'w');
    fprintf(fid_att,'\nT_number \t file_name \t Block_array_size \t R_FM_G \t S_FM_G \t U_FM_G \t R_M_G \t S_M_G\t U_M_G \t count');
    
    fid= fopen(file_experiment, 'w');
    fprintf(fid,'\nmethod \t first_hidding_bit \t file_name \t Stego 1 \t Stego 2 \t average1 \t  Capacity \t bpp \t Proposed_T_number \t time \t MSE1 \t MSE2 \t total_Secret  \t fail \t Block_array_size');
     max_point = 0; 
     Block_array_size = 3; 
     
     for k = 1:Img_num %Img_num  %那些影像要進去 1:6
            f_n = deblank(file_name_array(k,:));
            file_path=[ 'images\' f_n '512x512.tif'];  %輸入圖片路徑

            fprintf('\nPROPOSE=%s\n', file_path);

             first_hiddingbit = T_number; 
    %  proposed scheme with T_nmber = 3
            bpp_S=( total_secret*3/512/512/20 );
            switch (CompairWithMySelf)
                case {0, 1,2,3,4, 10, 11}
%             
        %           T= 3
%                     Block_array_size = 3;
%                         T_number =3; 
%                         
%                         [in_total_secret, in_message, in_secret_array, in_reEncode_A, in_reEncode_B, in_return_indicator, in_code] = get_message (T_number, total_secret, message, secret_array,reEncode_A, reEncode_B,return_indicator,total_secret_T, message_T, secret_array_T,reEncode_A_T, reEncode_B_T,return_indicator_T, code, code_T);
%                          bpp_S=( in_total_secret*T_number/512/512/40 );
%                         [PSNRs8 PSNRs9] = Ann_dual_two_Difference_zone_Block(CompairWithMySelf, f_attack, bpp_S,bpp_S, file_path,   T_number, isDrawFigure, isColorImage, file_experiment, in_total_secret, in_message, in_secret_array, in_reEncode_A, in_reEncode_B,  showdetail, in_return_indicator ,Block_array_size , in_code, isRSAttack );
%         %                nonfolding
%                         PSNRs8 = clearPSNRZero(PSNRs8); 
%         %                 folding
%                         PSNRs9 = clearPSNRZero(PSNRs9);
%                          
%             %           T= 4
%                         T_number =4; 
%                         [in_total_secret, in_message, in_secret_array, in_reEncode_A, in_reEncode_B, in_return_indicator, in_code] = get_message (T_number, total_secret, message, secret_array,reEncode_A, reEncode_B,return_indicator,total_secret_T, message_T, secret_array_T,reEncode_A_T, reEncode_B_T,return_indicator_T, code, code_T);
%                         bpp_S=( in_total_secret*T_number/512/512/40 );
% % 
%                         [PSNRs10 PSNRs11] = Ann_dual_two_Difference_zone_Block(CompairWithMySelf, f_attack, bpp_S,bpp_S, file_path,   4, isDrawFigure, isColorImage, file_experiment, in_total_secret, in_message, in_secret_array, in_reEncode_A, in_reEncode_B,  showdetail, in_return_indicator ,Block_array_size  , in_code, isRSAttack  );
%                         %                nonfolding
%                         PSNRs10 = clearPSNRZero(PSNRs10);
%                         %                folding
%                         PSNRs11 = clearPSNRZero(PSNRs11);           

                    Block_array_size = 5;
                        T_number =3; 
                        [in_total_secret, in_message, in_secret_array, in_reEncode_A, in_reEncode_B, in_return_indicator, in_code] = get_message (T_number, total_secret, message, secret_array,reEncode_A, reEncode_B,return_indicator,total_secret_T, message_T, secret_array_T,reEncode_A_T, reEncode_B_T,return_indicator_T, code, code_T);
                        bpp_S=( in_total_secret*T_number/512/512/40 );
                        [PSNRs12 PSNRs13] = Ann_dual_two_Difference_zone_Block(CompairWithMySelf, f_attack, bpp_S,bpp_S, file_path,  T_number, isDrawFigure, isColorImage, file_experiment, in_total_secret, in_message, in_secret_array, in_reEncode_A, in_reEncode_B,  showdetail, in_return_indicator ,Block_array_size, in_code , isRSAttack  );
                        PSNRs12 = clearPSNRZero(PSNRs12);
                        PSNRs13 = clearPSNRZero(PSNRs13);

            %           T= 4
                        T_number =4; 
                        [in_total_secret, in_message, in_secret_array, in_reEncode_A, in_reEncode_B, in_return_indicator, in_code] = get_message (T_number, total_secret, message, secret_array,reEncode_A, reEncode_B,return_indicator,total_secret_T, message_T, secret_array_T,reEncode_A_T, reEncode_B_T,return_indicator_T, code, code_T);
                        bpp_S=( in_total_secret*T_number/512/512/40 );
                        [PSNRs14 PSNRs15] = Ann_dual_two_Difference_zone_Block(CompairWithMySelf, f_attack, bpp_S,bpp_S, file_path,   T_number, isDrawFigure, isColorImage, file_experiment, in_total_secret, in_message, in_secret_array, in_reEncode_A, in_reEncode_B,  showdetail, in_return_indicator ,Block_array_size , in_code , isRSAttack  );
                        PSNRs14 = clearPSNRZero(PSNRs14);
                        PSNRs15 = clearPSNRZero(PSNRs15);           

%                     max_point = PSNRs11(length(PSNRs11), 1) + 0.3; 

                         T_number =3; 
                        [in_total_secret, in_message, in_secret_array, in_reEncode_A, in_reEncode_B, in_return_indicator, in_code] = get_message (T_number, total_secret, message, secret_array,reEncode_A, reEncode_B,return_indicator,total_secret_T, message_T, secret_array_T,reEncode_A_T, reEncode_B_T,return_indicator_T, code, code_T);
                        bpp_S=( in_total_secret*T_number/512/512/40 );
                        

               
            end 
            switch (CompairWithMySelf)
               case {1,2,3, 4, 10, 11}
                        [PSNRs1 PSNRs2 PSNRs3] = Ann_dual_Propose_message_historgram( bpp_S, bpp_S, file_path,Proposed_T_number, isDrawFigure, isColorImage, file_experiment, in_total_secret, in_message, in_secret_array);
                        PSNRs1 = clearPSNRZero(PSNRs1);
        %                 centerfolding
                        PSNRs2 = clearPSNRZero(PSNRs2); 
        %                 original
                        PSNRs3 = clearPSNRZero(PSNRs3);

                       if (max_point <  PSNRs1(length(PSNRs1), 1)) 
                            max_point = PSNRs1(length(PSNRs1), 1) + 0.3; 
                        end


                %  proposed scheme with T_nmber = 4
                        T_number =3; 
                        [in_total_secret, in_message, in_secret_array, in_reEncode_A, in_reEncode_B, in_return_indicator, in_code] = get_message (T_number, total_secret, message, secret_array,reEncode_A, reEncode_B,return_indicator,total_secret_T, message_T, secret_array_T,reEncode_A_T, reEncode_B_T,return_indicator_T, code, code_T);
                        bpp_S=( in_total_secret*T_number/512/512/40 );

%                         bpp_S=( total_secret*4/512/512/20 );
%                         [PSNRs7 PSNRsd PSNRsf] = Ann_dual_Propose_message_historgram(bpp_S,bpp_S, file_path, 4, isDrawFigure, isColorImage, file_experiment, in_total_secret, in_message, in_secret_array);
%                         PSNRs7 = clearPSNRZero(PSNRs7);

%                         if (max_point <  PSNRs7(length(PSNRs7), 1) &  ( CompairWithMySelf  == 2 ) ) 
%                             max_point = PSNRs7(length(PSNRs7), 1) + 0.3; 
%                         end 
                %         Lee_2009
                        bpp_S=(total_secret*2/512/512/40 );
                        [PSNRs4] =  Lee_Embedding2009(bpp_S,bpp_S,file_path, file_experiment, total_secret, message, secret_array, secret_array_String);
                        PSNRs4 = clearPSNRZero(PSNRs4);

                        if (max_point <  PSNRs4(length(PSNRs4), 1)) 
                            max_point = PSNRs4(length(PSNRs4), 1) + 0.3; 
                        end

                %         Lee_2013       s
                        bpp_S=(total_secret*2/512/512/40 );
                        [PSNRs5] =  LeeEmbedding2013(bpp_S,bpp_S,file_path, file_experiment, total_secret, message, secret_array, secret_array_String);
                        PSNRs5 = clearPSNRZero(PSNRs5);
                        if (max_point <  PSNRs5(length(PSNRs5), 1)) 
                            max_point = PSNRs5(length(PSNRs5), 1) + 0.3; 
                        end

                 %         Chang_2013       
                        bpp_S=(total_secret*2/512/512/40 );
                        [PSNRs6] =  changEmbedding2013(bpp_S,bpp_S,file_path, file_experiment, total_secret, message, secret_array, secret_array_String);
                        PSNRs6 = clearPSNRZero(PSNRs6);
                        if (max_point <  PSNRs6(length(PSNRs6), 1)) 
                            max_point = PSNRs6(length(PSNRs6), 1) + 0.3; 
                        end
						
				       [PSNRs27] =  LSB_matching_dual (f_attack, stego_image, f_n, file_path, secret_array, isColorImage, file_experiment,  bpp_S, isRSAttack, total_secret);
 
            end 
           
%               [PSNRs28] = daul_base9( f_n, 1.7);
              [PSNRs28] = positionBase9( f_n, 1.7);
              PSNRs28 = clearPSNRZero(PSNRs28);
              if (max_point <  PSNRs28(length(PSNRs28), 1)) 
                max_point = PSNRs28(length(PSNRs28), 1) + 0.3; 
              end
              
              switch (CompairWithMySelf )
                      case { 4, 5, 6, 10}      
                             [total_count ,  secret_image_array, secret_array_String, sorted , sorted_ind, histogram_total] =	 ReadSecretImage_withOrignalImage_20200215(secretFile, kindImage, 2, fid_his, file_path );  % proposed scheme read secret Image   ReadSecretImage_withOrignalImage(secret_file , kindImage, k, fid_his, orginalImage) 
                             bpp_S=( total_count*2/512/512/20 );

                              [PSNRs25 PSNRs26] = ann_LSBMatching_using_only_one_pixel(f_attack, secretFile, f_n, file_path,  kindImage, file_experiment,  bpp_S, total_count ,  secret_image_array, secret_array_String, sorted , sorted_ind, histogram_total, isRSAttack, isDrawFigure) ; 
                               PSNRs25 = clearPSNRZero(PSNRs25);
                                        if (max_point <  PSNRs25(length(PSNRs25), 1)) 
                                            max_point = PSNRs25(length(PSNRs25), 1) + 0.3; 
                                        end
                                PSNRs26 = clearPSNRZero(PSNRs26);
                                        if (max_point <  PSNRs26(length(PSNRs26), 1)) 
                                            max_point = PSNRs26(length(PSNRs26), 1) + 0.3; 
                                        end
                            bpp_S=( total_secret*3/512/512/20 );
                            
                                        
%                             pa =   parameter(1,:);
%                             n = pa (1, 1); 
%                             NZ = pa (1, 2); 
%                             kindImage = 1; 
%                            [count,  secret_array] = ReadSecretImage_differentBit(secretFile , kindImage, n , NZ, f_his ) ;
%                            [PSNRs16] = Ann_dual_ZoneChange0716(stego_image, secret_array, CompairWithMySelf, bpp_S , f_n,  file_path, n, NZ,f_attack, isDrawFigure, isColorImage, file_experiment, isRSAttack);
% 
%                             pa =   parameter(2,:);
%                             n = pa (1, 1); 
%                             NZ = pa (1, 2); 
%                             kindImage = 1; 
%                            [count,  secret_array] = ReadSecretImage_differentBit(secretFile , kindImage, n , NZ, f_his ) ;
%                            [PSNRs17] = Ann_dual_ZoneChange0716(stego_image, secret_array, CompairWithMySelf, bpp_S , f_n,  file_path, n, NZ, f_attack,isDrawFigure, isColorImage, file_experiment, isRSAttack);
%                            
%                             pa =   parameter(3,:);
%                             n = pa (1, 1); 
%                             NZ = pa (1, 2); 
%                             kindImage = 1; 
%                            [count,  secret_array] = ReadSecretImage_differentBit(secretFile , kindImage, n , NZ, f_his ) ;
%                            [PSNRs18] = Ann_dual_ZoneChange0716(stego_image, secret_array, CompairWithMySelf, bpp_S , f_n,  file_path, n, NZ,f_attack, isDrawFigure, isColorImage, file_experiment, isRSAttack);
% 
%                             pa =   parameter(4,:);
%                             n = pa (1, 1); 
%                             NZ = pa (1, 2); 
%                             kindImage = 1; 
%                            [count,  secret_array] = ReadSecretImage_differentBit(secretFile , kindImage, n , NZ, f_his ) ;
%                            [PSNRs19] = Ann_dual_ZoneChange0716(stego_image, secret_array, CompairWithMySelf, bpp_S , f_n,  file_path, n, NZ,f_attack, isDrawFigure, isColorImage, file_experiment, isRSAttack);
%                            
%                             pa =   parameter(5,:);
%                             n = pa (1, 1); 
%                             NZ = pa (1, 2); 
%                             kindImage = 1; 
%                            [count,  secret_array] = ReadSecretImage_differentBit(secretFile , kindImage, n , NZ, f_his ) ;
%                            [PSNRs20] = Ann_dual_ZoneChange0716(stego_image, secret_array, CompairWithMySelf, bpp_S , f_n,  file_path, n, NZ,f_attack, isDrawFigure, isColorImage, file_experiment, isRSAttack);
% 
%                             pa =   parameter(6,:);
%                             n = pa (1, 1); 
%                             NZ = pa (1, 2); 
%                             kindImage = 1; 
%                            [count,  secret_array] = ReadSecretImage_differentBit(secretFile , kindImage, n , NZ, f_his ) ;
%                            [PSNRs21] = Ann_dual_ZoneChange0716(stego_image, secret_array, CompairWithMySelf, bpp_S , f_n,  file_path, n, NZ,f_attack, isDrawFigure, isColorImage, file_experiment, isRSAttack);
% 
%                             pa =   parameter(7,:);
%                             n = pa (1, 1); 
%                             NZ = pa (1, 2); 
%                             kindImage = 1; 
%                            [count,  secret_array] = ReadSecretImage_differentBit(secretFile , kindImage, n , NZ, f_his ) ;
%                            [PSNRs22] = Ann_dual_ZoneChange0716(stego_image, secret_array, CompairWithMySelf, bpp_S , f_n,  file_path, n, NZ,f_attack, isDrawFigure, isColorImage, file_experiment, isRSAttack);
%                             
%                            pa =   parameter(8,:);
%                             n = pa (1, 1); 
%                             NZ = pa (1, 2); 
%                             kindImage = 1; 
%                            [count,  secret_array] = ReadSecretImage_differentBit(secretFile , kindImage, n , NZ, f_his ) ;
%                            [PSNRs23] = Ann_dual_ZoneChange0716(stego_image, secret_array, CompairWithMySelf, bpp_S , f_n,  file_path, n, NZ,f_attack, isDrawFigure, isColorImage, file_experiment, isRSAttack);
% 
%                              pa =   parameter(9,:);
%                             n = pa (1, 1); 
%                             NZ = pa (1, 2); 
%                             kindImage = 1; 
%                            [count,  secret_array] = ReadSecretImage_differentBit(secretFile , kindImage, n , NZ, f_his ) ;
%                            [PSNRs24] = Ann_dual_ZoneChange0716(stego_image, secret_array, CompairWithMySelf, bpp_S , f_n,  file_path, n, NZ,f_attack, isDrawFigure, isColorImage, file_experiment, isRSAttack);
%                           

                           
              end 
            switch (CompairWithMySelf )
                case {0}
                    array_name=char ( 'BlockFolding(B=3,K=3,RE=0)', 'BlockFolding(B=3,K=3,RE=1)', 'BlockFolding(B=3,K=4,RE=0)', 'BlockFolding(B=3,K=4,RE=1)',  'BlockFolding(B=5,K=3,RE=0)', 'BlockFolding(B=5,K=3,RE=1)',  'BlockFolding(B=5,K=4,RE=0)', 'BlockFolding(B=5,K=4,RE=1)'); 
                    PSNRArray = {PSNRs8,PSNRs9,PSNRs10, PSNRs11, PSNRs12,PSNRs13,PSNRs14,PSNRs15};
                    createfigure_BLOCK(PSNRArray, array_name, f_n, stego_image, T_number, max_point, CompairWithMySelf);
                
                case {1}
                    %             createfigure(PSNRs1,PSNRs2,PSNRs3,PSNRs4,PSNRs5,PSNRs6,PSNRs7, PSNRs8, PSNRs9,  PSNRs10,  PSNRs11, f_n, stego_image, T_number, max_point);
    %                 array_name=char ( 'BlockFolding(B=3,K=3,RE=0)', 'BlockFolding(B=3,K=3,RE=1)',  'BlockFolding(B=3,K=4,RE=1)',  'BlockFolding(B=5,K=3,RE=1)',  'BlockFolding(B=5,K=4,RE=0)', 'BlockFolding(B=5,K=4,RE=1)', 'Lu2016(K=3)', 'Lu2015(K=3)' , 'NoFolding(K=3)', 'Lu2016(K=4)', 'Lee2009', 'Lee2013', 'Chang2013' ); 
    %                 PSNRArray = {PSNRs8,PSNRs9,PSNRs11,PSNRs13,PSNRs14, PSNRs15, PSNRs1,PSNRs2,PSNRs3, PSNRs7, PSNRs4,PSNRs5,PSNRs6};
    %                 
                    array_name=char ( 'BlockFolding(B=3,K=3,RE=0)', 'BlockFolding(B=3,K=3,RE=1)',   'BlockFolding(B=5,K=4,RE=0)', 'BlockFolding(B=5,K=4,RE=1)', 'Lu2016(K=3)', 'Lu2015(K=3)' , 'NonFolding(K=3)', 'Lu2016(K=4)', 'Lee2009', 'Lee2013', 'Chang2013' ); 
                    PSNRArray = {PSNRs8,PSNRs9,PSNRs14, PSNRs15, PSNRs1,PSNRs2,PSNRs3, PSNRs7, PSNRs4,PSNRs5,PSNRs6};
                    createfigure_BLOCK(PSNRArray, array_name, f_n, stego_image, T_number, max_point, CompairWithMySelf);
                case {3}
                    array_name=char ( 'BlockFolding(B=3,K=3,RE=0)', 'BlockFolding(B=3,K=3,RE=1)', 'BlockFolding(B=3,K=4,RE=0)', 'BlockFolding(B=3,K=4,RE=1)',  'BlockFolding(B=5,K=3,RE=0)', 'BlockFolding(B=5,K=3,RE=1)',  'BlockFolding(B=5,K=4,RE=0)', 'BlockFolding(B=5,K=4,RE=1)', 'Lee2009', 'Lee2013', 'Chang2013', 'Lu2015(K=3)', 'NonFolding(K=3)' , 'Lu2016(K=3)',  'Lu2016(K=4)'); 
                    PSNRArray = {PSNRs8,PSNRs9,PSNRs10, PSNRs11, PSNRs12,PSNRs13,PSNRs14,PSNRs15,PSNRs4, PSNRs5,  PSNRs6,  PSNRs2, PSNRs3, PSNRs1,PSNRs7};
                    createfigure_BLOCK(PSNRArray, array_name, f_n, stego_image, T_number, max_point, CompairWithMySelf);
               case {4}
                   % array_name=char ( 'BlockFolding(B=3,K=3,RE=0)', 'BlockFolding(B=3,K=4,RE=0)', 'BlockFolding(B=5,K=3,RE=1)',  'BlockFolding(B=5,K=4,RE=1)', 'Lee2009', 'Lee2013', 'Chang2013', 'CenterFolding(K=3)', 'NonFolding(K=3)' ); 
                   % PSNRArray = {PSNRs8,PSNRs10, PSNRs13,PSNRs15,PSNRs4, PSNRs5,  PSNRs6,  PSNRs2, PSNRs3};
                   % createfigure_BLOCK(PSNRArray, array_name, f_n, stego_image, T_number, max_point, CompairWithMySelf);   
                   
% 					array_name=char ( 'Proposed(n=1, NZ=2)','Proposed(n=1, NZ=3)','Proposed(n=2, NZ=4)','Proposed(n=3, NZ=5)','Proposed(n=4, NZ=8)', 'BlockFolding(B=3,K=3,RE=0)', 'BlockFolding(B=3,K=4,RE=0)', 'BlockFolding(B=5,K=3,RE=1)',  'BlockFolding(B=5,K=4,RE=1)', 'Lee2009', 'Lee2013', 'Chang2013', 'CenterFolding(K=3)', 'NonFolding(K=3)' ); 
%                     PSNRArray = {PSNRs16,PSNRs17,PSNRs18,PSNRs19,PSNRs20,PSNRs8,PSNRs10, PSNRs13,PSNRs15, PSNRs4, PSNRs5,  PSNRs6,  PSNRs2, PSNRs3};
%                     createfigure_BLOCK(PSNRArray, array_name, f_n, stego_image, T_number, max_point, CompairWithMySelf);    
% 					array_name=char ( 'Lu(n=3, NZ=7)','Lu(n=2, NZ=7)','Lu(n=2, NZ=4)','Lu(n=1, NZ=3)','Lu(n=1, NZ=2)','Lu(n=1, NZ=1)','Lu(n=5, NZ=12)','Lu(n=4, NZ=8)','Lu(n=2, NZ=2)', 'Lee2009', 'Lee2013', 'Chang2013', 'CenterFolding(K=3)', 'NonFolding(K=3)', 'LSB-M', 'LSB-MA' ); 
%                     PSNRArray = {PSNRs16,PSNRs17,PSNRs18,PSNRs19,PSNRs20,PSNRs21,PSNRs22,PSNRs23,PSNRs24,PSNRs4, PSNRs5,  PSNRs6,  PSNRs2, PSNRs3, PSNRs25, PSNRs26};
%                     createfigure_BLOCK(PSNRArray, array_name, f_n, stego_image, T_number, max_point, CompairWithMySelf);    

					array_name=char ( 'Lee2009', 'Lee2013', 'Chang2013', 'CenterFolding(K=3)',   'LSB-M', 'LSB-MA', 'LSB-MA-ordering' ); 
                    PSNRArray = {PSNRs4, PSNRs5,  PSNRs6,  PSNRs2,  PSNRs27, PSNRs25, PSNRs26};
                    createfigure_BLOCK(PSNRArray, array_name, f_n, stego_image, T_number, max_point, CompairWithMySelf);    

                 
                case {10}
					array_name=char ('BlockFolding(B=5,K=3,RE=0)', 'BlockFolding(B=5,K=3,RE=1)',  'BlockFolding(B=5,K=4,RE=0)', 'BlockFolding(B=5,K=4,RE=1)', 'Lee2009', 'Lee2013', 'Chang2013', 'CenterFolding(K=3)', 'LSB-Matching', 'P-nonOrder', 'P-order', 'Yang'  ); 
                    PSNRArray = {PSNRs12 PSNRs13 PSNRs14 PSNRs15 PSNRs4, PSNRs5,  PSNRs6,  PSNRs2,  PSNRs27, PSNRs25, PSNRs26,  PSNRs28};
                    createfigure_BLOCK(PSNRArray, array_name, f_n, stego_image, T_number, max_point, CompairWithMySelf);    
%                  case {11}
% 					array_name=char ('BlockFolding(B=5,K=3,RE=0)', 'BlockFolding(B=5,K=3,RE=1)',  'BlockFolding(B=5,K=4,RE=0)', 'BlockFolding(B=5,K=4,RE=1)', 'Lee2009', 'Lee2013', 'Chang2013', 'CenterFolding(K=3)', 'LSB-Matching', 'P-nonOrder', 'P-order', 'Yang' ); 
%                     PSNRArray = {PSNRs12 PSNRs13 PSNRs14 PSNRs15 PSNRs4, PSNRs5,  PSNRs6,  PSNRs2,  PSNRs27, PSNRs25, PSNRs26,  PSNRs28};
%                     createfigure_BLOCK(PSNRArray, array_name, f_n, stego_image, T_number, max_point, CompairWithMySelf);    
                  
            end 

     end 
 end 
 [ 'compute end']
 


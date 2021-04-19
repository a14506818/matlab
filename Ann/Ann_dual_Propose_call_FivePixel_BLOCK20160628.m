clc;
clear all;
isDrawFigure=0;
isColorImage = 0;
file_experiment='';
isRSAttack = 0 ; 

 CompairWithMySelf = 4; 
%  CompairWithMySelf :
%                     0 =  
%                             array_name=char ( 'BlockFolding(B=3,K=3,RE=0)', 'BlockFolding(B=3,K=3,RE=1)', 'BlockFolding(B=3,K=4,RE=0)', 'BlockFolding(B=3,K=4,RE=1)',  'BlockFolding(B=5,K=3,RE=0)', 'BlockFolding(B=5,K=3,RE=1)',  'BlockFolding(B=5,K=4,RE=0)', 'BlockFolding(B=5,K=4,RE=1)'); 
%                     1 = 
%                             array_name=char ( 'BlockFolding(B=3,K=3,RE=0)', 'BlockFolding(B=3,K=3,RE=1)',   'BlockFolding(B=5,K=4,RE=0)', 'BlockFolding(B=5,K=4,RE=1)', 'Lu2016(K=3)', 'Lu2015(K=3)' , 'NonFolding(K=3)', 'Lu2016(K=4)', 'Lee2009', 'Lee2013', 'Chang2013' ); 
%                     3 = 
%                             array_name=char ( 'BlockFolding(B=3,K=3,RE=0)', 'BlockFolding(B=3,K=3,RE=1)', 'BlockFolding(B=3,K=4,RE=0)', 'BlockFolding(B=3,K=4,RE=1)',  'BlockFolding(B=5,K=3,RE=0)', 'BlockFolding(B=5,K=3,RE=1)',  'BlockFolding(B=5,K=4,RE=0)', 'BlockFolding(B=5,K=4,RE=1)', 'Lee2009', 'Lee2013', 'Chang2013', 'Lu2015(K=3)', 'NonFolding(K=3)' ); 
%                     4 = stegona analysis  
%                             PSNRs8 - 15 , lu2015 ... 
%                     5 = RSAttack
%                     6 = compute histogram
    
   
    file_title_word = ['com_' int2str(CompairWithMySelf) '_'];
    
    switch (CompairWithMySelf)
        case {5}
            isRSAttack = 1; 
             
%             isDrawFigure=1;
        case {6}
            
    end 
     
%當MSE = 0 時 PSNR設為 100 才畫得出線

 showdetail = 0; 
 
% 一般灰階
kindImage = 1; 
% stego_image_array = char('Logo', 'Logo350', 'Dolphin',   'Brain', 'Leg', 'MandrillSec', 'TiffanySec', 'random'); 
 stego_image_array = char('Dolphin'); 


 
% 測試醫學影像
% kindImage = 2; 
% stego_image = '000005';
% secretFile =  ['images\' stego_image '.dcm'];

 file_name_array = char('Airplane', 'Tiffany', 'Lake', 'Lena', 'Mandrill' ,'Pepper'); 
%file_name_array = char( 'Lena'); 
%  file_name_array = char('Lena'); 
[Img_num, data] = size(file_name_array); 

[secret_Img_num, data] = size(stego_image_array); 
 bpp = 3.0;

 Proposed_T_number = 3; % 2 or 3 
 T_number = 4; 
 k = Proposed_T_number; 
 for p = 1:secret_Img_num
     stego_image =  deblank(stego_image_array(p,:));
     secretFile =  ['images\' stego_image '.tif'];
     f_his = [ 'experimental results\' file_title_word 'histogram_' stego_image '_' num2str(month(date)) '_' num2str(day(date)) '.xls'];
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
     
    file_title = [ 'experimental results\'  file_title_word stego_image '_Experiment_' num2str(month(date)) '_' num2str(day(date)) '_Gray_T_' num2str(Proposed_T_number)  ]
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
                case {0, 1,2,3,4,5,6}
%             
        %           T= 3
                    Block_array_size = 3;
                        T_number =3; 
                        [in_total_secret, in_message, in_secret_array, in_reEncode_A, in_reEncode_B, in_return_indicator, in_code] = get_message (T_number, total_secret, message, secret_array,reEncode_A, reEncode_B,return_indicator,total_secret_T, message_T, secret_array_T,reEncode_A_T, reEncode_B_T,return_indicator_T, code, code_T);
                         bpp_S=( in_total_secret*T_number/512/512/40 );
                        [PSNRs8 PSNRs9] = Ann_dual_two_Difference_zone_Block(CompairWithMySelf, f_attack, bpp_S,bpp_S, file_path,   T_number, isDrawFigure, isColorImage, file_experiment, in_total_secret, in_message, in_secret_array, in_reEncode_A, in_reEncode_B,  showdetail, in_return_indicator ,Block_array_size , in_code, isRSAttack );
        %                nonfolding
                        PSNRs8 = clearPSNRZero(PSNRs8); 
        %                 folding
                        PSNRs9 = clearPSNRZero(PSNRs9);
                         
            %           T= 4
                        T_number =4; 
                        [in_total_secret, in_message, in_secret_array, in_reEncode_A, in_reEncode_B, in_return_indicator, in_code] = get_message (T_number, total_secret, message, secret_array,reEncode_A, reEncode_B,return_indicator,total_secret_T, message_T, secret_array_T,reEncode_A_T, reEncode_B_T,return_indicator_T, code, code_T);
                        bpp_S=( in_total_secret*T_number/512/512/40 );

                        [PSNRs10 PSNRs11] = Ann_dual_two_Difference_zone_Block(CompairWithMySelf, f_attack, bpp_S,bpp_S, file_path,   4, isDrawFigure, isColorImage, file_experiment, in_total_secret, in_message, in_secret_array, in_reEncode_A, in_reEncode_B,  showdetail, in_return_indicator ,Block_array_size  , in_code, isRSAttack  );
                        %                nonfolding
                        PSNRs10 = clearPSNRZero(PSNRs10);
                        %                folding
                        PSNRs11 = clearPSNRZero(PSNRs11);           

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

                    max_point = PSNRs11(length(PSNRs11), 1) + 0.3; 

                         T_number =3; 
                        [in_total_secret, in_message, in_secret_array, in_reEncode_A, in_reEncode_B, in_return_indicator, in_code] = get_message (T_number, total_secret, message, secret_array,reEncode_A, reEncode_B,return_indicator,total_secret_T, message_T, secret_array_T,reEncode_A_T, reEncode_B_T,return_indicator_T, code, code_T);
                        bpp_S=( in_total_secret*T_number/512/512/40 );
            end 
            switch (CompairWithMySelf)
               case {1,2,3,4}
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

                        bpp_S=( total_secret*4/512/512/20 );
                        [PSNRs7 PSNRsd PSNRsf] = Ann_dual_Propose_message_historgram(bpp_S,bpp_S, file_path, 4, isDrawFigure, isColorImage, file_experiment, in_total_secret, in_message, in_secret_array);
                        PSNRs7 = clearPSNRZero(PSNRs7);

                        if (max_point <  PSNRs7(length(PSNRs7), 1) &  ( CompairWithMySelf  == 2 ) ) 
                            max_point = PSNRs7(length(PSNRs7), 1) + 0.3; 
                        end 
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
                    array_name=char ( 'BlockFolding(B=3,K=3,RE=0)', 'BlockFolding(B=3,K=4,RE=0)', 'BlockFolding(B=5,K=3,RE=1)',  'BlockFolding(B=5,K=4,RE=1)', 'Lee2009', 'Lee2013', 'Chang2013', 'CenterFolding(K=3)', 'NonFolding(K=3)' ); 
                    PSNRArray = {PSNRs8,PSNRs10, PSNRs13,PSNRs15,PSNRs4, PSNRs5,  PSNRs6,  PSNRs2, PSNRs3};
                    createfigure_BLOCK(PSNRArray, array_name, f_n, stego_image, T_number, max_point, CompairWithMySelf);                    
            end 
            

     end 
 end 
 [ 'compute end']
 


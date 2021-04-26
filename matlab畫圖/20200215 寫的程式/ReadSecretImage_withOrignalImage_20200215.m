function [count ,  secret_array, secret_array_String, sorted , sorted_ind, histogram_total] =	 ReadSecretImage_withOrignalImage_20200215 (secret_file , kindImage, k, fid_his, cover_original) 



Tdebug = 0; 
 
      
     
     switch (kindImage)
         case {1}
            secret_image =imread(secret_file); %原始影像     
            original_image = imread(cover_original) ; %原始影像     
          case {2}
            secret_image = dicomread(secret_file); %醫學影像        
            original_image = rgb2gray(cover_original); %原始影像  
          case {3}
            secret_image =  [5 0 10 15; 20 20 15 20; 5 10 20 15; 20 20 15 20] ; 
            original_image =  [35 70 80 105; 220 220 125 210; 35 130 230 135; 230 220 215 220] ; 
     end 
 
  
  
     
%      secret_image =  [5 0 10 15; 20 20 15 20; 5 10 20 15; 20 20 15 20] ; 
%      original_image =  [7 123 223 212; 220 210 115 210; 15 110 210 115; 120 220 215 220] ; 
     
     
      A = reshape (original_image,1, numel(original_image)); %one dimension secret image
     [rows_A,cols_A]=size(A);
     
     cols_A;
       
     B = reshape (secret_image,1, numel(secret_image)); %one dimension secret image
     [rows,cols]=size(B);
     
     count = 1; 
%      histogram_odd = zeros(1, 2^k);
%      histogram_even = zeros(1, 2^k);
%  
%      Indicator_histogram_odd = zeros(1, 20);
%      Indicator_histogram_even = zeros(1, 20); 

% 統計出現次數 
 histogram_total =  zeros(4, 2^k);     
     
     secret_array = zeros(1 , 2*cols);
     
%      value_array_odd = zeros(1, 8);
%      value_array_even = zeros(1, 8);
     
     v1 = 0 ; 
     v2 = 0 ; 
     v3 = 0 ; 
     v4 = 0 ; 
     
     if (k ==3)
         cols = cols - 2; 
     end 
     

     orign_count = 1; 
     
     for  i=1:cols
%          i
         va = double(B(i));
         switch (k)
             case {2}
                 v1 = fix( va / 64 )  ;
                 va = va - v1*64 ;
                 v2 = fix( va / 16 )  ;
                 va = va - v2*16 ;
                 v3 = fix( va / 4 )  ;
                 v4 = va - v3*4 ;
                 if( B(i) ~= (v1*64 + v2*16 + v3*4 + v4) )
                    ['b(i) = ' num2str(B(i)) '  v1=   ' num2str( v1  ) '  v2=  '  num2str( v2)    ]
                    
                 end
                 value_array = [v1 v2 v3 v4] ;
             case {3}
                 %一次抓三個
                 
                 v1 = fix( va / 32 )  ;
                 va = va - v1*32 ;
                 v2 = fix( va / 4 )  ;
                 v3 = va - v2*4 ;
                 i = i + 1; 
                 va2 = double(B(i));
                 vtemp = fix( va2 / 128 );
                 v3 = v3 * 2 + vtemp; 
                 va2 =  va2 - vtemp*128 ;
                 v4 = fix( va2 / 16 )  ;
                 va2 = va2 - v4*16 ;
                 v5 = fix( va2 / 2 )  ;
                 vtemp = va2 - v5*2 ;
                 i = i + 1; 
                 va3 = double(B(i));
                 v6 = vtemp * 4 + fix( va3 / 64 );
                 va3 =  va3 - fix( va3 / 64 )*64 ;
                 v7 = fix( va3 / 8 )  ;
                 v8 = va3 - v7*8 ;

                 value_array = [v1 v2 v3 v4 v5 v6 v7 v8];
             case {4}
                 v1 = fix( va / 16 )  ;
                 v2 = va - v1*16 ;
                 v3 = 0 ;
                 v4 = 0;
                 if( B(i) ~= v1*16 + v2)
                    ['b(i) = ' num2str(B(i)) '  v1=   ' num2str( v1  ) '  v2=  '  num2str( v2)    ]
                    fix( va / 16 )
                 end 
                 value_array = [v1 v2];
         end 
         
         
         
         for t=1:length(value_array)
              secret_array(count) = value_array(t) ;
              if (  orign_count   <=  cols_A    )
                   cover_pixel =  double(A(orign_count))  ;
                   
                   if (cover_pixel > 0 & cover_pixel < 255)
                      LSB =  mod( cover_pixel , 2) ; 
                      F = mod( floor(cover_pixel/2) + cover_pixel , 2);
                   
                      index_compute = LSB * 2 + F + 1;  
                      histogram_total (index_compute, (value_array(t)+1)  ) =  histogram_total (index_compute, (value_array(t)+1)  )  + 1;     
  
                      orign_count =orign_count + 1; 
                   end 
              end 
 
             count = count+ 1;     
         end
          
         secret_array_String (i, :) = sprintf('%08s',num2str( dec2bin( B(i) ) ));
     end 
     
     
     histogram_total
      
    sorted =  zeros(4, 2^k); 
    sorted_ind =  zeros(4, 2^k);    

     for i=1:4
        histogram_temp =  histogram_total (i, :);
       
        [temp, ind]  = sort(histogram_temp,'descend');
        sorted(i, :) = temp(1:1:end) ;
        sorted_ind(i, :) = ind(1:1:end)  ;
        
     end 
  
     
     sorted
     sorted_ind

end
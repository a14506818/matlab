function [count , message, secret_array, secret_array_String, reEncode_A, reEncode_B, return_indicator, code] = ReadSecretImage(file , kindImage, k, fid_his) 
%      file = 'secret.tif';
 
      file
      kindImage
     switch (kindImage)
         case {1}
            secret_image =imread(file); %原始影像        
            
         case {2}
            secret_image = dicomread(file); %醫學影像        
           
     end 
     
     B = reshape (secret_image,1, numel(secret_image)); %one dimension secret image
     [rows,cols]=size(B);
     
     
     count = 1; 
     histogram = zeros(1, 2^k+1);
     Indicator_histogram = zeros(1, 20);
     secret_array = zeros(1 , 2*cols);
     value_array = zeros(1, 8);
     
     v1 = 0 ; 
     v2 = 0 ; 
     v3 = 0 ; 
     v4 = 0 ; 
     
     if (k ==3)
         cols = cols - 2; 
     end 
     
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
                 value_array = [v1 v2 v3 v4];
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
             histogram( (value_array(t)+1) ) = histogram( (value_array(t) +1) ) + 1 ;
             count = count+ 1;     
         end 
         
%          secret_array(count) = v1 ;
%          histogram(v1+1) = histogram(v1+1) + 1; 
%          count = count+ 1; 
%          secret_array(count) = v2 ;
%          histogram(v2+1 ) = histogram(v2+1 ) + 1; %
%          count = count+ 1; 
%          
%          if (k >= 2)
%              secret_array(count) = v3 ;
%              histogram(v3+1 ) = histogram(v3+1 ) + 1; %
%              count = count+ 1; 
%              secret_array(count) = v4 ;
%              histogram(v4+1 ) = histogram(v4+1 ) + 1; %
%              count = count+ 1; 
%          end 
%          
%         
         
         secret_array_String (i, :) = sprintf('%08s',num2str( dec2bin( B(i) ) )) ;
     end 
     
       histogram;
       
     
     
%      histogram = [5446 ,	7157,	2320	,1718	,1711,	1711,	1666,	1858,1913,	4170,	14091,	4517,	19424,	5135	,11797	,499430];
     [temp, ind]  = sort(histogram);
     sorted = temp(end:-1:1);
     sorted_ind = ind(end:-1:1);
    
     Now_Value = 0; %0, 1, -1, 2, -2, 3, -3, 4, -4 .....
     code = zeros(3, 2^k); 
     for i=1:2^k
         now = i - 1;
         X = round( now / 2 );
         Y= rem(now,  2);
         Now_Value = X;
         if (Y == 0)
             Now_Value = 0 - X;
         end 
         sorted_ind(i);
         
         code (1, sorted_ind(i) ) =  Now_Value;
         code (2, sorted_ind(i) ) =  sorted(i);
         code (3, sorted_ind(i) ) =  i;
         
%          再分成二區
         number_i = i - 1; 
         
%          number_i
         
         if ( number_i == 0)
             code (4, sorted_ind(i) ) =  0;
             code (5, sorted_ind(i) ) =  0;
         else
             B = 0; 
             if (mod ( number_i, 4) == 0 || mod ( (number_i+1), 4) == 0 )
                 B = 1; 
             end 
             
%              B
             
             rem_num = ceil( number_i / 4 )  ;
             
             
             sign = 1; 
             if ( mod(number_i, 2) == 0 )
                 sign = -1; 
             end 
             
             code (4, sorted_ind(i) ) =  B;
             code (5, sorted_ind(i) ) =  sign * rem_num ;
         end 
          
     end 
    code;
    count = count - 1; 
    
    message = zeros(1, count);
    Indicator_historgram = zeros(1, count);
    for  i=1:count
        message (i) = code(1, secret_array(i)+1 );
        reEncode_A(i)= code(4, secret_array(i)+1 );
        reEncode_B(i) = code(5, secret_array(i)+1 );
    end 
     histogram
     code
     
%     重新編碼 indicator 
     number_jump = 1; 
     for jump = 1:4:size(reEncode_A, 2)
         indicator  = 1 ; 
         for j = 1: 4
           indicator = indicator  +  reEncode_A(1,number_jump)* 2^(4 - j); 
           number_jump = number_jump + 1; 
         end 
         Indicator_histogram (indicator) =  Indicator_histogram (indicator) + 1; 
     end 

     [temp_indicator, ind_indicator]  = sort(Indicator_histogram);
     sorted_temp_indicator = temp_indicator(end:-1:1)
     sorted_ind_indicator = ind_indicator(end:-1:1)
     
     return_indicator = zeros(1,size(sorted_ind_indicator,2) );
     for j=1:size(sorted_ind_indicator,2)
         now = j - 1 ;
         X = round( now / 2 ) ;
         Y= rem(now,  2) ;
         Now_Value = X ;
         if (Y == 0)
             Now_Value = 0 - X ;
         end 
         
         return_indicator (1, sorted_ind_indicator(j) ) =  Now_Value ;
%          code (2, sorted_ind(i) ) =  sorted(i);
%          code (3, sorted_ind(i) ) =  i;
%          
%          value = ( j - 1 )  
%          s_i = mod(value , 2); 
%          signal = 1; 
%          if (s_i == 0)
%              signal = -1 ; 
%          end 
%          reencod_value = ceil(value/2)  
%           
%          sorted_ind_indicator (1,j)
%          
%          return_indicator (1,sorted_ind_indicator (1,j)) = reencod_value * signal   
     end 
     Indicator_histogram
     return_indicator
     
    for j=1:5
        fprintf(fid_his, '\n');
        for i=1:2^k
             fprintf(fid_his, '%8.2f \t',code(j,i));
        end 
    end 
    fprintf(fid_his, '\n rows \t %d \tcols \t %d ', rows,cols); 
  
    fprintf(fid_his, '\n original indicator sorting'); 
    fprintf(fid_his, '\n');
    for j=1:size(temp_indicator, 2)
        fprintf(fid_his, '%8.2f \t',Indicator_histogram(1,j));
    end 
     
    fprintf(fid_his, '\n reencoded indicator'); 
    fprintf(fid_his, '\n');
    for j=1:size(return_indicator, 2)
        fprintf(fid_his, '%8.2f \t',return_indicator(1,j));
    end 
    
end



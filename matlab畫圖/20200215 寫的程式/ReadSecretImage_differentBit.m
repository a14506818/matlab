 function [count,  secret_array] = ReadSecretImage_differentBit(file , kindImage, n , NZ, f_his ) 
% clc 
% clear 
%      file = 'images/Airplane362.tif';
%      kindImage = 1; 
     fid_his= fopen(f_his, 'a+');
     switch (kindImage)
         case {1}
            secret_image =imread(file); %原始影像        
            
         case {2}
            secret_image = dicomread(file); %醫學影像        
           
     end 
 
     B = reshape (secret_image,1, numel(secret_image)); %one dimension secret image
     [rows,cols]=size(B);
     
     count = 1; 
     Indicator_histogram = zeros(1, 20);
     secret_array = [];
     
     total_size = (n*2 +1) * NZ ;
     histogram = zeros(1, total_size);
     
     log_bit = floor(log2(total_size - 1));
     
     get_number = floor((total_size  - 2^(log_bit))/2 );
     
       
     from_value = 2^(log_bit-1);
     to_value = from_value + get_number -1 ;
     
     % from_value to to_value could add one more hiding bit 
       left_string = ''; 
       i = 0; 
       exit_out  = 0; 
       while ( length(left_string) > 0  || i < cols)
               if (length(left_string) < log_bit)
                    i = i+1;
                    if ( i <= cols )
                        va = double(B(i));
                        bin_va = sprintf('%08s',num2str( dec2bin(  va ) ));
                        left_string = strcat(left_string, bin_va);
                    else 
                        exit_out = 1; 
                        left_string =''; 
                    end 
               end 
               if (exit_out == 0)
                    d = bin2dec(left_string(1:log_bit));
                    f1 = log_bit + 1;

                    if (d >= from_value  & d <= to_value)
                         % from_value to to_value could add one more hiding bit 
                          add_bit = log_bit + 1 ; 
                          if (add_bit > length(left_string))
                                    i = i+1;
                                    if ( i <= cols )
                                        va = double(B(i));
                                        bin_va = sprintf('%08s',num2str( dec2bin(  va ) ));
                                        left_string = strcat(left_string, bin_va);
                                    else 
                                        exit_out = 1; 
                                        left_string =''; 
                                    end 
                          end 
                          if (length(left_string) > add_bit )
                              temp_d = bin2dec(left_string(1:add_bit));
                              if (temp_d < total_size)
                                 f1 = add_bit + 1;    
                                 d= temp_d; 
                              end 
                          end 
                    end 
                    count = count + 1; 
                    secret_array = [secret_array d ];
                    histogram( d+1) = histogram( (d +1) ) + 1  ;
                  
                   
                    f2 = length( left_string );
                    if (f1 < f2)
                        left_string = left_string(f1:f2);
                    else 
                        left_string = '';
                    end 
                    
               end 
                
       end 
       
    fprintf(fid_his, '\n different Bit'); 
     fprintf(fid_his, '\tN=%8.2f \tNZ=%8.2f \t',n, NZ);
    fprintf(fid_his, '\n');
    for j=1:size(histogram, 2)
        fprintf(fid_his, '%8.2f \t',(j-1));
    end 
    fprintf(fid_his, '\n');
    for j=1:size(histogram, 2)
        fprintf(fid_his, '%8.2f \t',histogram(1,j));
    end 
 
 
 

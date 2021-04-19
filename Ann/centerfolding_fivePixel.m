function [stegoI stegoII stego_fold_I stego_fold_II] = centerfolding_fivePixel (k, x, m_A, m_B, showdetail, return_indicator)
stegoI = double(x); 
stegoII = double(x); 
stego_fold_I = double(x); 
stego_fold_II = double(x);  
clear ID; 
arraysize = size(m_A,2); 
ID = zeros(1,arraysize);
    
for i=1:arraysize
%     m = floor(rand() * 2^k)
%     s = double( m(1,i) ) ; 
%     sd = s - 2^(k-1);
%     F = floor( s / (2^(k-1)));
%     if (F == 0)
%        B =  sd + 2^(k-2);
%     else 
%        B =  sd - 2^(k-2); 
%     end 
     
   
     B = m_B(1,i); 
    [StegoA, StegoB, embeddable]=Ann_dual_Embedding(k, x(1,i) , B );
    stegoI(1,i) = StegoA;
    stegoII(1,i) = StegoB;
    stego_fold_I(1,i) = StegoA; 
    stego_fold_II(1,i) = StegoB; 
end 


indicator  = 0 ; 
for j = 1: arraysize
   indicator = indicator  +  m_A(1,j)* 2^(arraysize - j); 
end 
% sd_indicator = indicator - 2 ^ (arraysize - 1 ); 

 
% indicator 重編碼
if (indicator >= 21)
    indicator = 19;
end 
m_A;
indicator+1;
sd_indicator = return_indicator (1, indicator+1)  ;

  
% 不對折
 [StegoA, StegoB, embeddable]=Ann_dual_Embedding(k, x(1,arraysize+1) , indicator );
 stegoI(1, arraysize+1) = StegoA; 
 stegoII(1, arraysize+1) = StegoB; 
 
%  對折
 [StegoA, StegoB, embeddable]=Ann_dual_Embedding(k, x(1,arraysize+1) ,sd_indicator  );
 stego_fold_I(1, arraysize+1) = StegoA; 
 stego_fold_II(1, arraysize+1) = StegoB; 
 
 if (showdetail == 1)
       
        m_A
        m_B
    indicator
 
     sd_indicator
            x
          ['不對折']
          stegoI
          stegoII
          ['對折']
          stego_fold_I
          stego_fold_II
end  
 
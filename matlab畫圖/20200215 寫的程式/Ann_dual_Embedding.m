function [StegoA, StegoB, embeddable]=Ann_dual_Embedding(n, pixel, s )

% n = hidding bit
StegoA = pixel; 
StegoB = pixel; 
embeddable = 0;

 
if ( (pixel > 2^(n-1)) & pixel < (255-2^(n-1)) )
    d1 = fix(s/2); 
    d2 = ceil(s/2); 
    StegoA = pixel + d1; 
    StegoB = pixel - d2; 
    embeddable = 1; 
%         [ 'pixel  = ' num2str(pixel) ' StegoA =' num2str(StegoA) ' StegoB =' num2str(StegoB) ' s =' num2str(s)]

else
   embeddable = 0; 
end 
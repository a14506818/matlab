function [psnrBack] = clearPSNRZero (psnr)


psnrBack = psnr;

    last = 0; 
    [rows, cols] = size(psnr);
    for  j = 1: rows
        if (last <  psnr(j, 1) )
            last = psnr(j, 1);
             psnrBack(j, 1) = psnr(j, 1); 
        else
            psnrBack(j, 1) = last; 
        end 
    end 
    
    last = 999; 
    for  j = 1: rows
        if (psnr(j, 2) > 0 )
             last = psnr(j, 2);
             psnrBack(j, 2) = psnr(j, 2); 
        else
             psnrBack(j, 2) = last; 
        end 
    end 

    

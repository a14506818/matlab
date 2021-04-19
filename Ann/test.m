clc
clear
Stego1 = [255 247 125 8 7 10 254 128 254 10 20 30 40 90 ]
Stego2 = Stego1
cols = size (Stego1,2)
i = 1;
fail = 0;
j = 1; 
k = 3; 
           countx = 1; 
             while (countx <= 5 & j <= cols)
                 dis_add = 2^(k-2)+1; 
                 if (countx == 5 )
                     dis_add = 9; 
                 end 
                if (Stego1 (i,j) <= (255-8) & Stego1 (i,j) >= 8 )
                     x(1,countx) = double(Stego1 (i,j))    
                    position(1,countx) = j 
                    countx=countx+1 
                else 
                    
                    if (Stego1 (i,j) > (255-8) )
                           Stego2(i,j) = Stego1 (i,j)- 9 
                           
                    else
                        if (Stego1 (i,j) < 8 )
                          Stego2(i,j) =Stego1 (i,j) + 9  
                          
                        end 
                    end 
                    fail= fail+1; 
                end 
                j=j+1; 
             end 
            
             x
             Stego2
             fail
             ['========================================================================']
Stego2 = Stego1;
cols = size (Stego1,2)
i = 1;
fail = 0;
j = 1; 
k = 3;              
             countx = 1; 
             while (countx <= 5 & j <= cols)
                 dis_add = 2^(k-2)+1  
                 if (countx == 5 )
                     dis_add = 9; 
                 end 
                if (Stego1 (i,j) <  (255-dis_add) & Stego1 (i,j)  > dis_add )
                    x(1,countx) = double(Stego1 (i,j))    
                    position(1,countx) = j 
                    countx=countx+1 
                else 
                    
                    if (Stego1 (i,j) >= (255-dis_add) )
                           Stego2(i,j) = Stego1 (i,j)- dis_add
                           Stego2(i,j) 
                    else
                        if (Stego1 (i,j) <= dis_add )
                          Stego2(i,j) =Stego1 (i,j) + dis_add  
                          
                        end 
                    end 
                    fail= fail+1  
                end 
                j=j+1  
             end 
             
             
             Stego2
             fail
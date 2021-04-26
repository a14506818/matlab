function [adj1_new, adj2_new]  = proposed_ann_LSBMatching_using_only_one_pixel_ordering_GenerateMapTable_GetHidingPixel (A, d, map_table )

A = 71;
d = 2;

d = double (d); 

m1 = floor(d/2)    ;
m2 = mod(d,2)  ; 

%LSB 是原始像素的奇偶數
LSB =  mod( A , 2) ;

%F 值 是原始像素的F 函數值
F = mod( floor(A/2) + A , 2) ;
F2 = mod( floor((A+1)/2) + A , 2) ;
 
dimension = LSB*2 + F + 1 ;
location = d + 1;

% adj1 = map_table(1,location,dimension)
% adj2 = map_table(2,location,dimension)
% pri =  map_table(3,location,dimension)
order_pri =  map_table(6,location,dimension);
new_location = find ( map_table(3,:,dimension) == order_pri);
adj1_new = map_table(1,new_location,dimension);
adj2_new = map_table(2,new_location,dimension);

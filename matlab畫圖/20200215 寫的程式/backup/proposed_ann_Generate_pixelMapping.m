function [map_table]  = proposed_ann_LSBMatching_using_only_one_pixel_ordering_GenerateMapTable (histogram_total, sorted_ind )
% histogram_total = [17492,14438,14601,18914;17652,14375,14609,18756;17385,14535,14871,19037;17520,14588,14651,18720];
% sorted_ind = [4,1,3,2;4,1,3,2;4,1,3,2;4,1,3,2];

map_table = zeros (6,4,4); 
map_table (:,:,1) = [0	0	1	-1;0	1	0	1;1 2 3 4;0	0	0	0;0	0	0	0;0	0	0	0];
map_table (:,:,2) =[0 0 -1 1 ;1 0 1 0 ;2 1 4 3 ;0 0 0 0 ;0 0 0 0;0	0	0	0];
map_table (:,:,3) =[-1 1 0 0 ;1 0 0 1 ;4 3 1 2 ;0 0 0 0 ;0 0 0 0;0	0	0	0];
map_table (:,:,4) =[1 -1 0 0 ;0 1 1 0 ;3 4 2 1 ;0 0 0 0 ;0 0 0 0;0	0	0	0];
for i = 1:4
   map_table (4,:,i)  = histogram_total (i,:);
   map_table (5,:,i)  = sorted_ind (i,:);
end 

% map_table

for i = 1:4
   for j = 1:4 
        [tempi tempj] = find ( map_table(5,:,i) == j)
        map_table (6,j,i) = tempj 
   end 
end 

  map_table

% A = 71;
% d = 2;
% 
% d = double (d); 
% 
% m1 = floor(d/2)    ;
% m2 = mod(d,2)  ; 
% 
% %LSB 是原始像素的奇偶數
% LSB =  mod( A , 2) ;
% 
% %F 值 是原始像素的F 函數值
% F = mod( floor(A/2) + A , 2) ;
% F2 = mod( floor((A+1)/2) + A , 2) ;
%  
% dimension = LSB*2 + F + 1 ;
% location = d + 1;
% 
% % adj1 = map_table(1,location,dimension)
% % adj2 = map_table(2,location,dimension)
% % pri =  map_table(3,location,dimension)
% order_pri =  map_table(6,location,dimension);
% new_location = find ( map_table(3,:,dimension) == order_pri);
% adj1_new = map_table(1,new_location,dimension);
% adj2_new = map_table(2,new_location,dimension);


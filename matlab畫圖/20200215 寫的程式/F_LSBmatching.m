function LSB = F_LSBmatching(A,B)
%F_LSBMATCHING Summary of this function goes here
%   Detailed explanation goes here
A=floor(A/2);
if rem(A+B,2) == 1
   LSB=1;
else
    LSB=0;
end

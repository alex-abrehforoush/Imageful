clc
clear
close all
imtool close all
%%%%%%%%%%%%%%%%
x = [32 33 24 14 43;
     32 25 24 25 26;
     15 35 34 19 26;
     45 47 58 67 20];
y = zeros(4, 5, 3);
y(:, :, 1) = x;
y(:, :, 2) = x;
y(:, :, 3) = x;
s = getOptimalSeam(y, 0, x, 1);
clc
clear
close all
imtool close all
%%%%%%%%%%%%%%%%choose image and ratio
name = 'Diana';
percentage = 0.5;
%%%%%%%%reading images
I = imread(['images\Samples\' name '.png']);
dmap = double(imread(['images\Samples\' name '_DMap.png']));
smap = double(imread(['images\Samples\' name '_SMap.png']));
%%%%%%%%
J = cair(I, dmap, smap, 0, 0.5);
imwrite(uint8(J), ['Output\' name '_' num2str(100 * percentage) '_percent.png']);
imshow(uint8(J), []);
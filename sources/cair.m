function J = cair(I, dmap, smap, dimension, percentage)
%CAIR method implemented for content-aware image retargeting
%   Detailed explanation goes here
height = size(I, 1);
width = size(I, 2);
%%%%%%%%morphological operations
K = medfilt2(rgb2gray(I), [7 7]);
gmap = imgradient(K);
%figure, imshow(gmap, []);

d135line_kernel = [-2 -1  0;
                   -1  0  1;
                    0  1  2];
d45line_kernel = [0 -1 -2;
                  1  0 -1;
                  2  1  0];

g135map = double(imfilter(K, d135line_kernel));
g45map = double(imfilter(K, d45line_kernel));

importance_map = 3*normalize(dmap) + normalize(smap) + normalize(gmap) + 3*normalize(max(g45map, g135map));



%figure, imshow(importance_map, []);
J = seamCarve(I, 0, 0.7 * percentage, importance_map, 1);
J = imresize(J, [height percentage*width], 'bicubic');
end


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

J = seamCarve(I, dimension, 0.7 * percentage, importance_map, 1);
if (dimension == 0)
    J = imresize(J, [height percentage * width], 'bicubic');
else
    J = imresize(J, [percentage * height width], 'bicubic');
end
end


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [J, last_importance_map] = seamCarve(I, dimension, percentage, importance_map, k)
%SEAMCARVE Summary of this function goes here
%   Detailed explanation goes here
J = I;
for i = 1: round(percentage * size(I, 2 - dimension))
    S = getOptimalSeam(J, dimension, importance_map, k);
    imshow(uint8(showSeam(J, S)), []);
    [J, seam_val] = removeSeam(J, dimension, S);
    importance_map = updateImportance(importance_map, 0, S);
    [importance_map, seam_val] = removeSeam(importance_map, dimension, S);
end
end


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function S = getOptimalSeam(I, dimension, importance_map, k)
%GETOPTIMALSEAM Summary of this function goes here
%   Detailed explanation goes here
if (dimension == 0)%modifying width size
    S = squeeze(zeros(1, size(I, 1)));
    seams_table = double(zeros(size(importance_map)));
    navigator = zeros(size(importance_map));
    for i = 1: size(I, 1)
        for j = 1: size(I, 2)
            upper_nodes = realmax * squeeze(ones(1, 2 * k + 1));
            upper_nodes(k + 1) = 0;
            for l = -k: k
                if (j + l >= 1 && j + l <= size(I, 2) && i - 1 >= 1)
                    upper_nodes(l + k + 1) = seams_table(i - 1, j + l);
                end
            end
            [val, idx] = min(upper_nodes);
            seams_table(i, j) = importance_map(i, j) + val;
            navigator(i, j) = j + idx - k - 1;
        end
    end
    [min_seam_val, min_seam_idx] = min(squeeze(seams_table(size(I, 1), :)));
    x = min_seam_idx;
    for i = size(I, 1): -1: 1
        S(i) = x;
        x = navigator(i, x);
    end
else%modifying height size
    S = zeros(size(I, 2));
    seams_table = double(zeros(size(importance_map)));
    navigator = zeros(size(importance_map));
    for j = 1: size(I, 2)
        for i = 1: size(I, 1)
            upper_nodes = realmax * squeeze(ones(1, 2 * k + 1));
            upper_nodes(k + 1) = 0;
            for l = -k: k
                if (i + l >= 1 && i + l <= size(I, 1) && j - 1 >= 1)
                    upper_nodes(l + k + 1) = seams_table(i + l, j - 1);
                end
            end
            [val, idx] = min(upper_nodes);
            seams_table(i, j) = importance_map(i, j) + val;
            navigator(i, j) = j + idx - k - 1;
        end
    end
    [min_seam_val, min_seam_idx] = min(squeeze(seams_table(:, size(I, 2))));
    x = min_seam_idx;
    for i = size(I, 2): -1: 1
        S(i) = x;
        x = navigator(x, i);
    end
end
end


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [J, seam_val] = removeSeam(I, dimension, S)
%REMOVESEAM Summary of this function goes here
%   Detailed explanation goes here
seam_val = 0;
if (dimension == 0)%modifying width size
    J = zeros(size(I, 1), size(I, 2) - 1, size(I, 3));
    for i = 1: size(J, 1)
        seam_val = seam_val + double(I(i, S(i)));
        J(i, :, :) = squeeze(I(i, 1: end ~= S(i), :));
    end
else%modifying height size
    J = zeros(size(I, 1) - 1, size(I, 2), size(I, 3));
    for i = 1: size(J, 2)
        seam_val = seam_val + double(I(S(i), i));
        J(:, i, :) = squeeze(I(1: end ~= S(i), i, :));
    end
end

end


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function new_importance_map = updateImportance(importance_map, dimension, S)
%UPDATEIMPORTANCE Summary of this function goes here
%   Detailed explanation goes here
new_importance_map = importance_map;
if (dimension == 0)
    for i = 1: size(importance_map, 1)
        if (S(i) - 1 >= 1 && S(i) + 1 <= size(importance_map, 2))
            new_importance_map(i, S(i) - 1) = new_importance_map(i, S(i) - 1) + 0.491/2*new_importance_map(i, S(i));
            new_importance_map(i, S(i) + 1) = new_importance_map(i, S(i) + 1) + 0.491/2*new_importance_map(i, S(i));
        end
        if (S(i) - 2 >= 1 && S(i) + 2 <= size(importance_map, 2))
            new_importance_map(i, S(i) - 2) = new_importance_map(i, S(i) - 2) + 0.009/2*new_importance_map(i, S(i));
            new_importance_map(i, S(i) + 2) = new_importance_map(i, S(i) + 2) + 0.009/2*new_importance_map(i, S(i));
        end
        
    end
else
    for j = 1: size(importance_map, 2)
        if (S(j - 1) >= 1 && S(j) + 1 <= size(importance_map, 1))
            new_importance_map(S(j) - 1, j) = new_importance_map(S(j) - 1, j) + 0.5*new_importance_map(S(j), j);
            new_importance_map(S(j) + 1, j) = new_importance_map(S(j) + 1, j) + 0.5*new_importance_map(S(j), j);
        end
    end
end
end


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function J = showSeam(I, S)
%SHOWSEAM Summary of this function goes here
%   Detailed explanation goes here
J = I;
if (size(S, 2) == size(I, 1))
    for i = 1: size(S, 2)
        J(i, S(i), 1) = 255;
        J(i, S(i), 2) = 0;
        J(i, S(i), 3) = 0;
    end
else
end
end


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function y = normalize(x)
%NORMALIZE Summary of this function goes here
%   Detailed explanation goes here
y = x / (max(x(:)));
end


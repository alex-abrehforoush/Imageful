function [J, last_importance_map] = seamCarve(I, dimension, percentage, importance_map, k)
%SEAMCARVE Summary of this function goes here
%   Detailed explanation goes here
J = I;
for i = 1: round(percentage * size(I, 2 - dimension))
    S = getOptimalSeam(J, dimension, importance_map, k);
    %imshow(uint8(showSeam(J, S)), []);
    [J, seam_val] = removeSeam(J, dimension, S);
    importance_map = updateImportance(importance_map, 0, S);
    [importance_map, seam_val] = removeSeam(importance_map, dimension, S);
end
end


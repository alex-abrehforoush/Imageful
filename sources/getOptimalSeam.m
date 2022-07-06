function S = getOptimalSeam(I, dimension, energy_map, k)
%GETOPTIMALSEAM Summary of this function goes here
%   Detailed explanation goes here
if (dimension == 0)%modifying width size
    S = squeeze(zeros(1, size(I, 1)));
    seams_table = double(zeros(size(energy_map)));
    navigator = zeros(size(energy_map));
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
            seams_table(i, j) = energy_map(i, j) + val;
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
end
end


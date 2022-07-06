function J = removeSeam(I, dimension, S)
%REMOVESEAM Summary of this function goes here
%   Detailed explanation goes here
if (dimension == 0)%modifying width size
    J = zeros(size(I, 1), size(I, 2) - 1, 3);
    for i = 1: size(J, 1)
        J(i, :, :) = squeeze(I(i, 1: end ~= S(i), :));
    end
else%modifying height size
    J = zeros(size(I, 1) - 1, size(I, 2), 3);
    for i = 1: size(J, 2)
        J(:, i, :) = squeeze(I(1: end ~= S(i), i, :));
    end
end

end


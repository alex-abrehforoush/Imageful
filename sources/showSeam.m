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


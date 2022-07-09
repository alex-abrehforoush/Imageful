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


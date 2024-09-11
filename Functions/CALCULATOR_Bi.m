% Computes Bi used in certain condition functions from the b and s cells

% Matrix Bi is a 2-D matrix where each column corresponds to a 3x1 vector
% of coordinates associated with points b_i or s_i for a redondant leg.
function Bi = CALCULATOR_Bi(b,s)

    Bi = zeros(3,8);
    Bi(:,5:8) = [b{3},b{4},b{5},b{6}];
    Bi(:,1:4) = [s{1},s{1},s{2},s{2}]; % Why the first 4 coordinates are s_i? - Jonathan
    
end


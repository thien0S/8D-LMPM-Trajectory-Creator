% Computes Ai used in certain condition functions from the a cell

% Matrix Ai is a 2-D matrix where each column corresponds to a 3x1 vector
% of coordinates associated with points a_i.
function Ai = CALCULATOR_Ai(a)
    
    Ai = [];
    for i = 1:6
        for j = 1:2
            if ~isempty(a{i,j})
                Ai(1:3,end+1) = a{i,j};
            end
        end
    end
    
end


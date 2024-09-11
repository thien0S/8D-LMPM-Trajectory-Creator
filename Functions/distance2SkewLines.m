% This function computes the minimum distance between two skew lines. See 
% https://en.wikipedia.org/wiki/Skew_lines for more information.
function distance = distance2SkewLines(a1,b1,a2,b2)

    if norm(cross((b1-a1),(b2-a2))) == 0 % The lines are parallel
        directionVector = (b1-a1)/norm(b1-a1);
        distance=norm(cross(directionVector,a2-a1));
    else % The lines are NOT parallel
        n = cross(b1-a1,b2-a2)/norm(cross(b1-a1,b2-a2));
        distance = norm(dot(n,a2-a1));
    end

end


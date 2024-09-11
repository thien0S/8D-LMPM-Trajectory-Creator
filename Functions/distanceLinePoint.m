% This function computes the minimum distance between a line and a point. 
% See https://mathworld.wolfram.com/Point-LineDistance3-Dimensional.html 
% for more information.

% x0 : point coordinates
% x1 : first point of the line
% x2 : second point of the line
function distance = distanceLinePoint(x0,x1,x2)

    crossNum = cross(x0-x1,x0-x2);
    distance = norm(crossNum)/norm(x2-x1);

end
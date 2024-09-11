% This function finds the coordinates along the line closest to a given
% point. It then checks if the coordinates is between the end points of the
% line and verifies interference.

% x0 : point coordinates
% x1 : first point of the line
% x2 : second point of the line
function linkJointCrossing = linkJointInterference(x0,x1,x2)

    dotNum = dot((x1-x0),(x2-x1));
    t = -dotNum/(norm(x2-x1))^2;
    
    if t <= 1 && t >= 0
        linkJointCrossing = 1;
    else
        linkJointCrossing = 0;
    end
    
end
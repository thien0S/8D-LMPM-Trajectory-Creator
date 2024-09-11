% This function gives the position of the two points on the two lines
% defined by a1,b1 and a2,b2 which constitute the closest pair of points in
% those two lines. See https://en.wikipedia.org/wiki/Skew_lines for more
% information. The function returns 1 if a link interference occurs between
% points a1,b1 and between a2,b2. If not, the interference takes place in
% the extension of lines a1,b1 and a2,b2, which isn't a real interference
% between two links.
function linksCrossing = linkInterference(a1,b1,a2,b2)

linksCrossing = NaN;

if norm(cross((b1-a1),(b2-a2))) == 0 % The lines are parallel
    linksCrossing=1; % No need to verify the intersection since this function was entered because the distance between two lines was shorter than Dmin.
else
    d1=b1-a1;
    d2=b2-a2;

    n=cross(d1,d2);

    t1=(dot(a2-a1,cross(d2,n)))/(dot(d1,cross(d2,n)));
    t2=(dot(a1-a2,cross(d1,n)))/(dot(d2,cross(d1,n)));

    if t1 >= 0 && t1 <= 1 && t2 >= 0 && t2 <= 1 % The interference takes place simultaneously between points a1,b1 and points a2,b2.
        linksCrossing=1;
    else
        linksCrossing=0;
    end

end


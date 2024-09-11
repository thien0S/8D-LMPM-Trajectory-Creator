function bresenhamList = bresenham(matrice, x1, y1, x2, y2)
    % Algorithme de Bresenham pour tracer une ligne entre deux points
    dx = abs(x2 - x1);
    dy = abs(y2 - y1);
    sx = sign(x2 - x1);
    sy = sign(y2 - y1);
    err = dx - dy;

    x = x1;
    y = y1;

	x_vals = [];
	y_vals = [];

    while true
        x_vals(end+1) = x;
        y_vals(end+1) = y;

        if x == x2 && y == y2
            break;
        end

        e2 = 2 * err;
        if e2 > -dy
            err = err - dy;
            x = x + sx;
        end
        if e2 < dx
            err = err + dx;
            y = y + sy;
        end
    end

    x = x_vals;
    y = y_vals;

	bresenhamList = matrice(sub2ind(size(matrice), x, y));
end
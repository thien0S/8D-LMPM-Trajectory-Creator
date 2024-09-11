%Computes the rotation matrix for the given modified Euler angles
function Q = CALCULATOR_Q(phi,theta,sigma)

    psi = phi-sigma;

    Q = [cosd(phi)*cosd(theta)*cosd(psi) + sind(phi)*sind(psi), cosd(phi)*cosd(theta)*sind(psi) - sind(phi)*cosd(psi), cosd(phi)*sind(theta);
         sind(phi)*cosd(theta)*cosd(psi) - cosd(phi)*sind(psi), sind(phi)*cosd(theta)*sind(psi) + cosd(phi)*cosd(psi), sind(phi)*sind(theta);
         -sind(theta)*cosd(psi),                                -sind(theta)*sind(psi),                                cosd(theta)];

end


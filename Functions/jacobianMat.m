% This function receives the configuration parameters of the robot and
% computes the Jacobian Matrixes J & K.
function [J,K] = jacobianMat(a,b,s,bprimeRot)

    k = 2; %Nbr de jambes redondantes

    % Vecteur e - Vecteur de distance entre les bases de pattes redondantes
    e = cell(2,1);
    e{1} = (a{1,2}-a{1,1})/norm(a{1,2}-a{1,1});
    e{2} = (a{2,2}-a{2,1})/norm(a{2,2}-a{2,1});
    
    % Vecteur rho - Vecteur représentant les actuateurs (de A à B)
    rho = cell(6,2);

    rho{1,1} = s{1} - a{1,1};
    rho{1,2} = s{1} - a{1,2};
    rho{2,1} = s{2} - a{2,1};
    rho{2,2} = s{2} - a{2,2};
    for i=3:6
        rho{i,1} = b{i} - a{i};
    end

    % Matrice rhoNorm - Matrice des normes de vecteur des actuateur (représente
    % la longueur des actuateurs)
    rhoNorm = zeros(6,2);

    for i=1:6
        rhoNorm(i,1) = norm(rho{i,1});
        if i <= 2
            rhoNorm(i,2) = norm(rho{i,2});
        end
    end
    
    %Matrice J - Matrice reliée au torseur (t) de la plate-forme
    J = zeros(6,6);

    for i=1:6
        if i <= k
            J(i,1:3) = (s{i}-b{i})';
        else
            J(i,1:3) = (b{i}-a{i})';
        end
        if i <= k
            J(i,4:6) = (cross(bprimeRot{i},s{i}-b{i}))';
        else
            J(i,4:6) = (cross(bprimeRot{i},b{i}-a{i}))';
        end
    end

    %Matrice K - Matrice reliée aux vitesses des actuateurs
    K = zeros(6,6+k);

    K2 = zeros(6-k,6-k);
    for i = k+1:6
        K2(i-k,i-k) = rhoNorm(i,1);
    end

    mu = zeros(k,1);
    m = cell(k,1);
    n = cell(k,1);
    r = cell(k,1);
    for i=1:k
        mu(i) = (cross(s{i}-a{i,1},s{i}-a{i,2}))'*(cross(b{i}-a{i,1},e{i}));
        m{i} = (rhoNorm(i,1)/mu(i)) * cross(s{i}-a{i,2},cross(b{i}-a{i,1},e{i}));
        n{i} = (rhoNorm(i,2)/mu(i)) * cross(cross(b{i}-a{i,1},e{i}),s{i}-a{i,1});
        r{i} = s{i} - b{i};
    end

    K1 = zeros(k,2*k);
    for i=1:k
        K1(i,i*2-1) = r{i}'*m{i};
        K1(i,i*2) = r{i}'*n{i};
    end

    K(1:k,1:2*k) = K1;
    K(k+1:end,k*2+1:end) = K2;

end
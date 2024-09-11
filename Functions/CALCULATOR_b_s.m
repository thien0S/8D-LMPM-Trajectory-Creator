%Computes the b_i and s_i vectors for the given position and orientation
%of the platform
function [b,s] = CALCULATOR_b_s(p,Q,bprime,a,rendondantLength,anglesMembresRedondants)

    % anglesMembresRedondants : Les angles d'orientation pour les membrures
    % redondantes. 90 deg représente une membrure verticale.
    
    %Calcul de e
    e = cell(2);
    e{1} = (a{1,2}-a{1,1})/norm(a{1,2}-a{1,1});
    e{2} = (a{2,2}-a{2,1})/norm(a{2,2}-a{2,1});
    
    %Space allocation for b and s vectors
    b = cell(6,1);
    s = cell(2,1);
    
    %Calcul de b
    for t=1:6
        b{t} = p + Q*bprime{t};
    end

    
    %Calcul du vecteur normal au plan des actuateurs
    interVect(:,1) = -cross(e{1,1},b{1}-a{1,1});
    interVect(:,2) = -cross(e{2,1},b{2}-a{2,1});

    kUnit(:,1) = cross(e{1,1},interVect(:,1));
    kUnit(:,1) = kUnit(:,1)/norm(kUnit(:,1));
    kUnit(:,2) = cross(e{2,1},interVect(:,2));
    kUnit(:,2) = kUnit(:,2)/norm(kUnit(:,2));
    
    %Calcul de s
    for y=1:2
        s{y} = b{y} + rendondantLength*cosd(anglesMembresRedondants(1,y))*e{y,1}/norm(e{y,1}) - rendondantLength*sind(anglesMembresRedondants(1,y))*kUnit(:,y);
    end
end
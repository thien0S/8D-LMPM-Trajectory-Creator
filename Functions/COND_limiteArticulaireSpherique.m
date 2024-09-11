function Cond = COND_limiteArticulaireSpherique(Ai,b,s,Q)

interference = 0;

% limiteArticulaire = 150*pi/180; % Radians, limite minimale de l'angle entre le premier et dernier axe de rotation du joint sphérique redondant

limiteArticulaire = 145*pi/180; % Facteur de sécurité - Jonathan


% Vecteurs selon le premier axe de rotation des joints sphériques
v1 = Ry(-45)*[-1;0;0];
v2 = Ry(45)*[1;0;0];
v3 = Rx(-45)*Rz(22)*[0;1;0];
v4 = Rx(-45)*Rz(-22)*[0;1;0];
v5 = Rx(45)*Rz(22)*[0;-1;0];
v6 = Rx(45)*Rz(-22)*[0;-1;0];

V = [v1,v2,v3,v4,v5,v6];

for i = 1:length(b)
    
    % Membrures redondantes
    if i <= 2
        
        angle = acos(dot(Q*V(:,i),b{i}-s{i})/(norm(Q*V(:,i))*norm(b{i}-s{i})));
        if angle > limiteArticulaire
            interference = 1;
            break;
        end
    % Pattes non-redondantes
    else
        angle = acos(dot(Q*V(:,i),b{i}-Ai(:,i+2))/(norm(Q*V(:,i))*norm(b{i}-Ai(:,i+2))));
        if angle > limiteArticulaire
            interference = 1;
            break;
        end
    end
    
end

if interference
    Cond = 0;
    %fprintf('Spherical joint mechanical limit detected\n');
else
    Cond = 1;
end


end


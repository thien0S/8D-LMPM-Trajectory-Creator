% This function verifies if a mechanical interference occurs between a
% spherical joint and a slider or stator (the diameter of the slider is set
% equal to the diameter of the stator for security. Because the slider is
% considered as going from Ai to b or s, it thus also includes the stator)
function Cond = COND_sphericalJointInterference(Ai,b,s)

% DsliderMag : Diamètre de sécurité minimal autour des tiges. Prend en
% compte une marge de sécurité ajoutée pour le magnétisme des tiges
% DsliderMag = 0.024; %m
DsliderMag = 0.030; %m valeur de sécurité Datasheet - Jonathan



% Dstator : Diamètre des stators
% Dstator = 0.0315; %m
Dstator = 0.035; %m 0.028 mesuré + distance de sécurité - Jonathan

% Djoint : Diamètre d'une sphère englobant une partie de l'articulation sphérique
% Djoint = 0.020; %m %0.04746
% Djoint = 0.04746; %m 0.043 mesurée + distance de sécurité - Jonathan
% Djoint = 0.03; %m 0.043 mesurée - Jonathan
% Djoint = 0.025; %m 0.043 mesurée  - Jonathan
Djoint = 0.022; %m 0.043 mesurée  - Jonathan



interference = 0;

for i = 1:length(Ai)
    
    if interference == 1   
        break;
    else
        
        for j = 1:length(b)

            % Sous-pattes redondantes
            if i == 1 || i == 2 
                distance = distanceLinePoint(b{j}(:),Ai(:,i),s{1});
                if distance <= (DsliderMag+Djoint)/2 % Distance plus grande que nécessaire comme facteur de sécurité
                    if linkJointInterference(b{j}(:),Ai(:,i),s{1})
                        interference = 1; % Vérification de contacts entres sliders et joints sphériques
                        %fprintf('Slider-joint interference detected\n');
                        break
                    end
                end
                
            elseif i == 3 || i == 4 
                distance = distanceLinePoint(b{j}(:),Ai(:,i),s{2});
                if distance <= (DsliderMag+Djoint)/2 % Distance plus grande que nécessaire comme facteur de sécurité
                    if linkJointInterference(b{j}(:),Ai(:,i),s{2})
                        interference = 1; % Vérification de contacts entres sliders et joints sphériques
                        %fprintf('Slider-joint interference detected\n');
                        break
                    end
                end
                
            % Pattes non-redondantes, i > 4
            elseif i - 2 ~= j % Éviter de vérifier une fausse interférence entre une patte et son propre joint sphérique
                
                distance = distanceLinePoint(b{j}(:),Ai(:,i),b{i-2}(:));
                if distance <= (DsliderMag+Djoint)/2 % Distance plus grande que nécessaire comme facteur de sécurité
                    if linkJointInterference(b{j}(:),Ai(:,i),b{i-2}(:))
                        interference = 1; % Vérification de contacts entres sliders et joints sphériques
                        %fprintf('Slider-joint interference detected\n');
                        break
                    end
                end
            else 
                continue
            end                               
        end    
    end
end


if interference
    Cond = 0;
else
    Cond = 1;
end

end


% This function verifies if a mechanical interference occurs between a
% spherical joint and a slider or stator (the diameter of the slider is set
% equal to the diameter of the stator for security. Because the slider is
% considered as going from Ai to b or s, it thus also includes the stator)
function Cond = COND_sphericalJointInterference(Ai,b,s)

% DsliderMag : Diam�tre de s�curit� minimal autour des tiges. Prend en
% compte une marge de s�curit� ajout�e pour le magn�tisme des tiges
% DsliderMag = 0.024; %m
DsliderMag = 0.030; %m valeur de s�curit� Datasheet - Jonathan



% Dstator : Diam�tre des stators
% Dstator = 0.0315; %m
Dstator = 0.035; %m 0.028 mesur� + distance de s�curit� - Jonathan

% Djoint : Diam�tre d'une sph�re englobant une partie de l'articulation sph�rique
% Djoint = 0.020; %m %0.04746
% Djoint = 0.04746; %m 0.043 mesur�e + distance de s�curit� - Jonathan
% Djoint = 0.03; %m 0.043 mesur�e - Jonathan
% Djoint = 0.025; %m 0.043 mesur�e  - Jonathan
Djoint = 0.022; %m 0.043 mesur�e  - Jonathan



interference = 0;

for i = 1:length(Ai)
    
    if interference == 1   
        break;
    else
        
        for j = 1:length(b)

            % Sous-pattes redondantes
            if i == 1 || i == 2 
                distance = distanceLinePoint(b{j}(:),Ai(:,i),s{1});
                if distance <= (DsliderMag+Djoint)/2 % Distance plus grande que n�cessaire comme facteur de s�curit�
                    if linkJointInterference(b{j}(:),Ai(:,i),s{1})
                        interference = 1; % V�rification de contacts entres sliders et joints sph�riques
                        %fprintf('Slider-joint interference detected\n');
                        break
                    end
                end
                
            elseif i == 3 || i == 4 
                distance = distanceLinePoint(b{j}(:),Ai(:,i),s{2});
                if distance <= (DsliderMag+Djoint)/2 % Distance plus grande que n�cessaire comme facteur de s�curit�
                    if linkJointInterference(b{j}(:),Ai(:,i),s{2})
                        interference = 1; % V�rification de contacts entres sliders et joints sph�riques
                        %fprintf('Slider-joint interference detected\n');
                        break
                    end
                end
                
            % Pattes non-redondantes, i > 4
            elseif i - 2 ~= j % �viter de v�rifier une fausse interf�rence entre une patte et son propre joint sph�rique
                
                distance = distanceLinePoint(b{j}(:),Ai(:,i),b{i-2}(:));
                if distance <= (DsliderMag+Djoint)/2 % Distance plus grande que n�cessaire comme facteur de s�curit�
                    if linkJointInterference(b{j}(:),Ai(:,i),b{i-2}(:))
                        interference = 1; % V�rification de contacts entres sliders et joints sph�riques
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


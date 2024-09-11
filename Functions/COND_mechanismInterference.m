% This function verifies if a mechanical limit due to links crossing exists
% in the whole mechanism, that is to say, between all pairs of links. It
% may be due to many type of components such as stators, sliders or joints.
% Safety distances for every component are listed below.
function Cond = COND_mechanismInterference(Ai,Bi,b,s,sliderShifting,statorLength,sliderLength,decalage)

% DsliderMag : Diam�tre de s�curit� minimal autour des tiges. Prend en
% compte une marge de s�curit� ajout�e pour le magn�tisme des tiges
% DsliderMag = 0.024; %m valeur Nicolas
DsliderMag = 0.030; %m valeur de s�curit� Datasheet - Jonathan

% Dstator : Diam�tre des stators
% Dstator = 0.0315; %m valeur Nicolas
Dstator = 0.035; %m 0.028 mesur� + distance de s�curit� - Jonathan



% Djoint : Diam�tre d'une sph�re englobant une partie de l'articulation sph�rique
% Djoint = 0.020; %m Valeur Nicolas %0.04746
% Djoint = 0.04746; %m 0.043 mesur�e + distance de s�curit� - Jonathan
% Djoint = 0.03; %m 0.043 mesur�e  - Jonathan
% Djoint = 0.025; %m 0.043 mesur�e  - Jonathan
Djoint = 0.022; %m 0.043 mesur�e  - Jonathan



interference = 0;

for i=1:length(Ai)
    
    if interference == 1   
        break;
    else
        for j=1:length(Ai)
            
            distance = distance2SkewLines(Ai(:,i),Bi(:,i),Ai(:,j),Bi(:,j));
            
            unitABi = (Bi(:,i)-Ai(:,i)) / norm(Bi(:,i)-Ai(:,i));
            unitABj = (Bi(:,j)-Ai(:,j)) / norm(Bi(:,j)-Ai(:,j));
            
            if j ~= i && distance <= (DsliderMag+Dstator)/2 
                if linkInterference(Ai(:,i) + unitABi*decalage,Ai(:,i) + unitABi*(statorLength+decalage),Ai(:,j),Bi(:,j)) % Le troisi�me argument aurait pu �tre Ai(:,j) + unitABj*(statorLength+decalage) au lieu de simplement Ai(:,j) - Jonathan
                    interference = 1; % V�rification de contacts entre stator i et slider j
                    %fprintf('Stator-slider interference detected\n');
                    break
                end
                
            end
            
           % Pas prudent selon moi - Jonathan
%             if j <= i   
%                 continue;
            if (i==1 && j==2) || (i==2 && j==1) || (i==3 && j==4) || (i==4 && j==3) % Interf�rence entre les deux sous-pattes d'une jambe redondante que l'on exclut - Jonathan
                continue;
            elseif j ~= i 
                if distance <= DsliderMag
                    TopSliderI = Ai(:,i) - unitABi*(sliderLength-norm(Bi(:,i)-Ai(:,i))+sliderShifting(i)); % Pour �tre rigoureux, on pourrait ajouter +distAttachRing dans la partie de la tige qui d�passe en-haut - Jonathan
                    TopSliderJ = Ai(:,j) - unitABj*(sliderLength-norm(Bi(:,j)-Ai(:,j))+sliderShifting(j));
                    if linkInterference(Ai(:,i),Bi(:,i),Ai(:,j),Bi(:,j))
                        interference = 1; % V�rification de contacts entres tiges basses
                        %fprintf('Low slider interference detected\n');
                        break;
                    elseif linkInterference(Ai(:,i),Ai(:,i) - unitABi*(sliderLength-norm(Bi(:,i)-Ai(:,i))+sliderShifting(i)),Ai(:,j),Ai(:,j) - unitABj*(sliderLength-norm(Bi(:,j)-Ai(:,j))+sliderShifting(j))) 
                        interference = 1; % V�rification de contacts tiges hautes
                        %fprintf('High slider interference detected (Opt 1)\n');
                        break
                    elseif distance2Points(TopSliderI, TopSliderJ) <= DsliderMag
                        interference = 1; % V�rification de contacts d'embout � embout des tiges hautes
                        %fprintf('High slider interference detected (Opt 2)\n');
                        break
                    elseif distanceLinePoint(TopSliderI,Ai(:,j),TopSliderJ) <= DsliderMag || distanceLinePoint(TopSliderJ,Ai(:,i),TopSliderI) <= DsliderMag
                        interference = 1; % V�rification de contacts de tige � embout des tiges hautes
                        %fprintf('High slider interference detected (Opt 3)\n');
                        break;
                    end
                elseif distance <= Dstator 
                    if linkInterference(Ai(:,i) + unitABi*decalage,Ai(:,i) + unitABi*(statorLength+decalage),Ai(:,j) + unitABj*decalage,Ai(:,j) + unitABj*(statorLength+decalage))
                        interference = 1; % V�rification de contacts entre stators
                        %fprintf('Stator interference detected\n');
                        break;
                    end
                end

            end
            
            
            % Distance entre une tige i et l'articulation sph�rique j d'une
            % patte non-redondante, ou de l'articulation roto�de j de la
            % membrure redondante
            distance = distanceLinePoint(Bi(:,j),Ai(:,i),Bi(:,i));
            
            if j ~= i && distance <= (0.02+Djoint)/2 %Diam�tre standard de la tige (0.012m + 0.008m de facteur de s�curit�), car pas de magn�tisme
            
                if linkJointInterference(Bi(:,j),Ai(:,i),Bi(:,i))
                    interference = 1; % V�rification de contacts entres sliders et joints sph�riques
                    %fprintf('Slider-joint interference detected\n');
                    break
                end
                
            end

            
            % Distance entre une tige i et l'articulation sph�rique de la
            % patte redondante 1
            
            distance = distanceLinePoint(b{1}(:),Ai(:,i),Bi(:,i));
            
            if j ~= i && distance <= (0.02+Djoint)/2 %Diam�tre standard de la tige (0.012m + 0.008m de facteur de s�curit�), car pas de magn�tisme
                
                if j == 1 && i ~= 2 % V�rification de contacts entres sliders et joints sph�riques de la patte redondante 1
                    if linkJointInterference(b{1}(:),Ai(:,i),Bi(:,i))
                        interference = 1; 
                        %fprintf('Slider-joint interference detected\n');
                        break
                    end
                elseif j == 2 && i ~= 1 % V�rification de contacts entres sliders et joints sph�riques de la patte redondante 1
                    if linkJointInterference(b{1}(:),Ai(:,i),Bi(:,i))
                        interference = 1; 
                        %fprintf('Slider-joint interference detected\n');
                        break
                    end
                end
            end
            
            
            % Distance entre une tige i et l'articulation sph�rique de la
            % patte redondante 2
            
            distance = distanceLinePoint(b{2}(:),Ai(:,i),Bi(:,i));
            if j ~= i && distance <= (0.02+Djoint)/2 %Diam�tre standard de la tige (0.012m + 0.008m de facteur de s�curit�), car pas de magn�tisme
                if j == 3 && i ~= 4 % V�rification de contacts entres sliders et joints sph�riques de la patte redondante 2
                    if linkJointInterference(b{2}(:),Ai(:,i),Bi(:,i))
                        interference = 1; 
                        %fprintf('Slider-joint interference detected\n');
                        break
                    end
                elseif j == 4 && i ~= 3 % V�rification de contacts entres sliders et joints sph�riques de la patte redondante 2
                    if linkJointInterference(b{2}(:),Ai(:,i),Bi(:,i))
                        interference = 1; 
                        %fprintf('Slider-joint interference detected\n');
                        break
                    end
                 
                end
            
            end
                
        end
            
    end
        
        
        
        
    if interference == 1   
        break;
    end

    % V�rification d'interf�rence entre les membrures redondantes et les pattes
    % non-redondantes 
    if i > 4
        distance_1 = distance2SkewLines(Ai(:,i),Bi(:,i),s{1}(:),b{1}(:));
        distance_2 = distance2SkewLines(Ai(:,i),Bi(:,i),s{2}(:),b{2}(:));
        if distance_1 <= (DsliderMag + Dstator)/2 % On consid�re une distance plus grande pour la s�curit�
            if linkInterference(Ai(:,i),Bi(:,i),s{1}(:),b{1}(:))
                interference = 1; % V�rification de contacts entres tiges basses et membrure redondante
                %fprintf('Slider-Redundant link interference detected\n');
                break;
            end
        elseif distance_2 <= (DsliderMag + Dstator)/2 % On consid�re une distance plus grande pour la s�curit�
            if linkInterference(Ai(:,i),Bi(:,i),s{2}(:),b{2}(:))
                    interference = 1; % V�rification de contacts entres tiges basses et membrure redondante
                    %fprintf('Slider-Redundant link detected\n');
                    break;
            end     
        end

    % V�rification d'interf�rence entre les membrures redondantes et 
    % les autres sous-pattes redondantes    
    else 
        if i == 1 || i == 2
            distance = distance2SkewLines(Ai(:,i),s{1}(:),s{2}(:),b{2}(:));
            if distance <= (DsliderMag + Dstator)/2 % On consid�re une distance plus grande pour la s�curit�
                if linkInterference(Ai(:,i),s{1}(:),s{2}(:),b{2}(:))
                    interference = 1; % V�rification de contacts entres tiges basses et membrure redondante
                    %fprintf('Slider-Redundant link interference detected\n');
                    break;
                end
            end
        else
            distance = distance2SkewLines(Ai(:,i),s{2}(:),s{1}(:),b{1}(:));
            if distance <= (DsliderMag + Dstator)/2 % On consid�re une distance plus grande pour la s�curit�
                if linkInterference(Ai(:,i),s{2}(:),s{1}(:),b{1}(:))
                    interference = 1; % V�rification de contacts entres tiges basses et membrure redondante
                    %fprintf('Slider-Redundant link interference detected\n');
                    break;
                end
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


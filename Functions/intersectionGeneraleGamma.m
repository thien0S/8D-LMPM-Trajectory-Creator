function [intervalleGeneral] = intersectionGeneraleGamma(intervalles,gammaLimiteInferieure,gammaLimiteSuperieure)

% Cette fonction détermine des nouvelles plages de valeurs acceptables pour
% l'angle gamma en tenant compte à la fois des limites dues aux élongations
% minimales/maximales des 2 sous-pattes et les limites mécaniques dues aux
% interférences avec le joint sphérique et la plateforme. La variable 'intervalles'
% contient différentes plages de valeurs minimales et maximales pour
% l'angle gamma (1re colonne : val. min, et 2e colonne : val. max) en lien 
% avec les élongations min/max. Les  variables 'gammaLimiteInferieure' et
% 'gammaLimiteSuperieure' sont les limites minimales et maximales 
% restricitives sur les interférences mécaniques.


intervalleGeneral=NaN(size(intervalles,1),size(intervalles,2));

for i = 1:size(intervalles,1)

    if gammaLimiteInferieure < intervalles(i,2)      
        intervalleGeneral(i,1)=max(gammaLimiteInferieure,intervalles(i,1));
        
        if gammaLimiteSuperieure > intervalles(i,1)        
           intervalleGeneral(i,2) = min(gammaLimiteSuperieure,intervalles(i,2));
        end
                    
    end
end

% Pour retirer les intervalles pouvant contenir des NaN
intervalleGeneral = intervalleGeneral(all(~isnan(intervalleGeneral),2),:); 

end
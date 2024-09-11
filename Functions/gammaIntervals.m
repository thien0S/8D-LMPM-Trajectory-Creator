function [intervalleGeneral] = gammaIntervals(b_i,a_i1,a_i2,e_i,lMembrure,rhoMax,rhoMin,betaMax,Q,psiMax,limiteTiltJointSph)


[gammaMin,gammaMax] = limitesGammaInterferenceMecanique(a_i1,a_i2,b_i,-e_i,betaMax,lMembrure,Q,psiMax,limiteTiltJointSph);


% Détermination de la présence de limites potentielles sur l'angle gamma dû
% à des élongations minimale/maximale des sous-pattes.
[limitRhoMax1,limitRhoMin1] = ExistingLimitRhoMaxRhoMin(b_i,a_i1,lMembrure,rhoMax,rhoMin);
[limitRhoMax2,limitRhoMin2] = ExistingLimitRhoMaxRhoMin(b_i,a_i2,lMembrure,rhoMax,rhoMin);


% Avec l'hypothèse que rhoMax-rhoMin > 2*lMembrure (course efficace >
% 2*lMembrure), on s'assure de ne jamais avoir simultanément des limites à
% la fois sur rhoMax et rhoMin en élongation, autrement dit, limitRhoMax et
% limitRhoMin ne peuvent pas valoir 1 simultanément. Cela simplifie la
% gestion des intervalles valables pour l'angle gamma.

% On vérifie que la pose de la plateforme est possible pour les limites
% mécaniques en élongation des sous-pattes
if (~isnan(limitRhoMax1)&& ~isnan(limitRhoMin1) && ~isnan(limitRhoMax2) && ~isnan(limitRhoMin2))
    
    % Détermination du cas de limite en élongation pour les 2 sous-pattes
    % dans lequel on se trouve
    if limitRhoMax1 == 1 % 1,0 // ...,...
        if limitRhoMax2 == 1 % 1,0 // 1,0
            [gammaLimitInf1,gammaLimitSupp1] = gammaLimitOnRhoMax(b_i,e_i,a_i1,lMembrure,rhoMax);
            [gammaLimitInf2,gammaLimitSupp2] = gammaLimitOnRhoMax(b_i,e_i,a_i2,lMembrure,rhoMax);
            
            [gammaInf,gammaSupp] = intervals_RhoMax1RhoMax2(gammaLimitInf1,gammaLimitSupp1,gammaLimitInf2,gammaLimitSupp2);
            intervallesPrelim = [gammaInf',gammaSupp'];
            intervalleGeneral = intersectionGeneraleGamma(intervallesPrelim,gammaMin,gammaMax);
            
        else
            if limitRhoMin2 == 1 % 1,0 // 0,1
                [gammaLimitInf1,gammaLimitSupp1] = gammaLimitOnRhoMax(b_i,e_i,a_i1,lMembrure,rhoMax);
                [gammaLimitInf2,gammaLimitSupp2] = gammaLimitOnRhoMin(b_i,e_i,a_i2,lMembrure,rhoMin);
                
                [gammaInf,gammaSupp] = intervals_RhoMax1RhoMin2(gammaLimitInf1,gammaLimitSupp1,gammaLimitInf2,gammaLimitSupp2);
                intervallesPrelim = [gammaInf',gammaSupp'];
                intervalleGeneral = intersectionGeneraleGamma(intervallesPrelim,gammaMin,gammaMax);
                
            else % 1,0 // 0,0
                [gammaLimitInf1,gammaLimitSupp1] = gammaLimitOnRhoMax(b_i,e_i,a_i1,lMembrure,rhoMax);
                intervallesPrelim = [gammaLimitInf1,gammaLimitSupp1];
                intervalleGeneral = intersectionGeneraleGamma(intervallesPrelim,gammaMin,gammaMax);
            end
        end
    else % 0,... // ...,...
        if limitRhoMin1 == 1 % 0,1 // ...,...
            if limitRhoMax2 == 1 % 0,1 // 1,0
                [gammaLimitInf1,gammaLimitSupp1] = gammaLimitOnRhoMin(b_i,e_i,a_i1,lMembrure,rhoMin);
                [gammaLimitInf2,gammaLimitSupp2] = gammaLimitOnRhoMax(b_i,e_i,a_i2,lMembrure,rhoMax);
                
                [gammaInf,gammaSupp] = intervals_RhoMin1RhoMax2(gammaLimitInf1,gammaLimitSupp1,gammaLimitInf2,gammaLimitSupp2);
                intervallesPrelim = [gammaInf',gammaSupp'];
                intervalleGeneral = intersectionGeneraleGamma(intervallesPrelim,gammaMin,gammaMax);
            else
                if limitRhoMin2 == 1 % 0,1 // 0,1
                    [gammaLimitInf1,gammaLimitSupp1] = gammaLimitOnRhoMin(b_i,e_i,a_i1,lMembrure,rhoMin);
                    [gammaLimitInf2,gammaLimitSupp2] = gammaLimitOnRhoMin(b_i,e_i,a_i2,lMembrure,rhoMin);
                    
                    [gammaInf,gammaSupp] = intervals_RhoMin1RhoMin2(gammaLimitInf1,gammaLimitSupp1,gammaLimitInf2,gammaLimitSupp2);
                    intervallesPrelim = [gammaInf',gammaSupp'];
                    intervalleGeneral = intersectionGeneraleGamma(intervallesPrelim,gammaMin,gammaMax);
                    
                    
                else % 0,1 // 0,0
                    [gammaLimitInf1,gammaLimitSupp1] = gammaLimitOnRhoMin(b_i,e_i,a_i1,lMembrure,rhoMin);
%                     intervallesPrelim = [gammaLimitInf1,gammaLimitSupp1];
                    intervallesPrelim=[gammaLimitInf1-2*pi,gammaLimitSupp1;gammaLimitInf1,gammaLimitSupp1+2*pi];
                    intervalleGeneral = intersectionGeneraleGamma(intervallesPrelim,gammaMin,gammaMax);
                end
            end
        else % 0,0 // ...,...
            if limitRhoMax2 == 1 % 0,0 // 1,0
                [gammaLimitInf2,gammaLimitSupp2] = gammaLimitOnRhoMax(b_i,e_i,a_i2,lMembrure,rhoMax);
                intervallesPrelim = [gammaLimitInf2,gammaLimitSupp2];
                intervalleGeneral = intersectionGeneraleGamma(intervallesPrelim,gammaMin,gammaMax);
            else
                if limitRhoMin2 == 1 % 0,0 // 0,1
                    [gammaLimitInf2,gammaLimitSupp2] = gammaLimitOnRhoMin(b_i,e_i,a_i2,lMembrure,rhoMin);
%                     intervallesPrelim=[gammaLimitInf2,gammaLimitSupp2];
                    intervallesPrelim=[gammaLimitInf2-2*pi,gammaLimitSupp2;gammaLimitInf2,gammaLimitSupp2+2*pi];
                    intervalleGeneral = intersectionGeneraleGamma(intervallesPrelim,gammaMin,gammaMax);
                else % 0,0 // 0,0
                    intervalleGeneral = [gammaMin,gammaMax];
                end
            end
        end
    end
        
    
    
    
else
    
    % Pose inatteignable, car l'une des sous-pattes ne peut pas offrir
    % assez de débattement en élongation (minimale ou maximale). Ce cas
    % devra se traduire par un arrêt de la trajectoire.
    intervalleGeneral=NaN;
    
    
end


end


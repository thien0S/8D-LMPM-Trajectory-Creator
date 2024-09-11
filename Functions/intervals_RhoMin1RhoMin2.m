function [gammaInf,gammaSupp] = intervals_RhoMin1RhoMin2(gammaInf1,gammaSupp1,gammaInf2,gammaSupp2)

% Cette fonction détermine les possibles zones d'intersection lorsque la
% membrure supplémentaire est contrainte en orientation (angle gamma) dû au
% limites en extension minimale des sous-pattes 1 et 2 à la fois. Elle
% prend en paramètres les angles gammas min et max pour chacune des 2
% sous-pattes, et en fonction de leurs valeurs, elle produit les zones
% d'intersection dans lesquelles la membrure supplémentaire peut se situer
% (angle gamma).

if gammaSupp2+2*pi > gammaInf1
    if gammaSupp1 > gammaInf2
        % 2 zones
        gammaInf(1)=gammaInf2;
        gammaSupp(1)=gammaSupp1;
        
        gammaInf(2)=gammaInf1;
        gammaSupp(2)=gammaSupp2+2*pi;
        gammaInf(3)=gammaInf1-2*pi;
        gammaSupp(3)=gammaSupp2;
    else
        % 1 zone
        gammaInf(1)=max(gammaInf1,gammaInf2);
        gammaSupp(1)=min(gammaSupp1,gammaSupp2)+2*pi;
        gammaInf(2)=max(gammaInf1,gammaInf2)-2*pi;
        gammaSupp(2)=min(gammaSupp1,gammaSupp2);
    end
else
    if gammaSupp1 > gammaInf2
        % 1 zone
        gammaInf(1)=gammaInf2;
        gammaSupp(1)=gammaSupp1;
    else
        % 0 zone
        gammaInf=NaN;
        gammaSupp=NaN;
        
    end
end


end


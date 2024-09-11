function [limitRhoMax,limitRhoMin] = ExistingLimitRhoMaxRhoMin(b_i,a_i,lMembrure,rhoMax,rhoMin)

% Cette fonction détermine, pour l'une des sous-pattes d'une patte double,
% si celle-ci est contrainte de par ses longueurs minimales et maximales
% permises. Une valeur NaN implique une pose inatteignable, 1, une limite
% existante et 0, une absence de limite mécanique due aux longueurs
% minimales/maximales.



% Limite due à la longueur maximale d'une patte
if (rhoMax <= norm(b_i-a_i)-lMembrure) % Pose inatteignable
    limitRhoMax=NaN;   
elseif (rhoMax <= norm(b_i-a_i)+lMembrure)
    limitRhoMax=1;
elseif (rhoMax > norm(b_i-a_i)+lMembrure)
    limitRhoMax=0;
end


% Limite due à la longueur minimale d'une patte
if(rhoMin >= norm(b_i-a_i)+lMembrure) % Pose inatteignable
    limitRhoMin=NaN;
elseif (rhoMin >= norm(b_i-a_i)-lMembrure)
    limitRhoMin=1;
elseif (rhoMin < norm(b_i-a_i)-lMembrure)
    limitRhoMin=0;
end



end


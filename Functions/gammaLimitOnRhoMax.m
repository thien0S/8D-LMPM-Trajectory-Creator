function [gammaLimitInf,gammaLimitSupp] = gammaLimitOnRhoMax(b_i,e_i,a_i,lMembrure,rhoMax)

% Cette fonction détermine les bornes sur l'angle gamma d'une patte double
% pour respecter les limites mécaniques dues à une élongation maximale
% d'une sous-patte.

    gammaLimitInf=NaN;
    gammaLimitSupp=NaN;

    r_i1=a_i-b_i;
    
    alpha2_rhoMax=acos((norm(r_i1)^2+lMembrure^2-rhoMax^2)/(2*lMembrure*norm(r_i1)));
    alpha3_rhoMax=acos(dot(e_i,r_i1)/(norm(e_i)*norm(r_i1)));
    
    gammaLimInfRhoMax=alpha3_rhoMax - alpha2_rhoMax;
    gammaLimSuppRhoMax=alpha3_rhoMax + alpha2_rhoMax;
    
    gammaLimitInf=gammaLimInfRhoMax;
    gammaLimitSupp=gammaLimSuppRhoMax;
   
end


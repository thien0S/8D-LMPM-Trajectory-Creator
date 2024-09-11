function [gammaLimitInf,gammaLimitSupp] = gammaLimitOnRhoMin(b_i,e_i,a_i,lMembrure,rhoMin)

% Cette fonction détermine les bornes sur l'angle gamma d'une patte double
% pour respecter les limites mécaniques dues à une élongation minimale
% d'une sous-patte.


%     gammaLimitInf=NaN(2,1);
%     gammaLimitSupp=NaN(2,1);

    r_i1=a_i-b_i;
    
    alpha2_rhoMin=acos((norm(r_i1)^2+lMembrure^2-rhoMin^2)/(2*lMembrure*norm(r_i1)));
    alpha3_rhoMin=acos(dot(e_i,r_i1)/(norm(e_i)*norm(r_i1)));
    
    gammaLimInfRhoMin=alpha3_rhoMin - alpha2_rhoMin;
    gammaLimSuppRhoMin=alpha3_rhoMin + alpha2_rhoMin;
    
%     gammaLimitInf(1)=gammaLimSuppRhoMin-2*pi;
%     gammaLimitSupp(1)=gammaLimInfRhoMin;
%     
%     gammaLimitInf(2)=gammaLimSuppRhoMin;
%     
%     if gammaLimInfRhoMin > 0     
%         gammaLimitSupp(2)=2*pi;      
%     else
%         gammaLimitSupp(2)=gammaLimInfRhoMin+2*pi;
%     end
    
gammaLimitInf=gammaLimSuppRhoMin;
gammaLimitSupp=gammaLimInfRhoMin;

    
    
end


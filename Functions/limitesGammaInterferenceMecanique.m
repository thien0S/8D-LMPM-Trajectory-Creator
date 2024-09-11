function [gammaMin,gammaMax] = limitesGammaInterferenceMecanique(a_i1,a_i2,b_i,e_i,betaMax,l_membrure,Q,psiMax,limiteTiltJointSph)

% Cette fonction d�termine les bornes maximales et minimales sur l'angle
% gamma tel qu'il respecte les limites les plus restrictives entre les
% interf�rences avec la plateforme et le joint sph�rique.


% Attention : lors de l'appel de cette fonction, inverser le sens du
% vecteur e_i, car dans les sch�mas il dans le sens oppos�.


[limitInf1_Gamma,limitSupp1_Gamma] = limitePatteRedJointSpherique(a_i1,a_i2,b_i,e_i,betaMax,l_membrure);
[limitInf2_Gamma,limitSupp2_Gamma,~] = limitePatteRedPlateforme(a_i1,a_i2,b_i,e_i,Q,psiMax,limiteTiltJointSph);

% D�termination des limites sup�rieures et inf�rieures sur les angles
% de redondance
if isnan(limitInf2_Gamma)
    gammaMin=limitInf1_Gamma;
elseif limitInf1_Gamma<=limitInf2_Gamma
    gammaMin=limitInf2_Gamma;
else
    gammaMin=limitInf1_Gamma;
end
if isnan(limitSupp2_Gamma)
    gammaMax=limitSupp1_Gamma;
elseif limitSupp1_Gamma<limitSupp2_Gamma 
    gammaMax=limitSupp1_Gamma;      
else
    gammaMax=limitSupp2_Gamma;
end
    



end


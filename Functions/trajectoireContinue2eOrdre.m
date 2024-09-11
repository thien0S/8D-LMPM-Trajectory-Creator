function [positionVect,vitesseVect,accelerationVect] = trajectoireContinue2eOrdre(positionIni,positionFinale,t,T)

    tau=t/T;
    sTau=6*tau^5-15*tau^4+10*tau^3;
    sPrimeTau=30*tau^4-60*tau^3+30*tau^2;
    sPrimePrimeTau=120*tau^3-180*tau^2+60*tau;
    
    positionVect=positionIni+(positionFinale-positionIni)*sTau;
    vitesseVect=(1/T)*(positionFinale-positionIni)*sPrimeTau;
    accelerationVect=(1/T^2)*(positionFinale-positionIni)*sPrimePrimeTau;

end


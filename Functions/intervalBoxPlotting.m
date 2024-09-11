function  intervalBoxPlotting(intervalle_1,intervalle_2)

for i = 1:size(intervalle_1,1)
    
    borneInfGamma2=intervalle_1(i,1);
    borneSuppGamma2=intervalle_1(i,2);
    
    
    for j = 1:size(intervalle_2,1)
        
        
        borneInfGamma5=intervalle_2(j,1);
        borneSuppGamma5=intervalle_2(j,2);
        
        plot([borneInfGamma2,borneSuppGamma2],[borneInfGamma5,borneInfGamma5],'--c','LineWidth',2);
        hold on
        plot([borneSuppGamma2,borneSuppGamma2],[borneInfGamma5,borneSuppGamma5],'--c','LineWidth',2);
        plot([borneSuppGamma2,borneInfGamma2],[borneSuppGamma5,borneSuppGamma5],'--c','LineWidth',2);
        plot([borneInfGamma2,borneInfGamma2],[borneSuppGamma5,borneInfGamma5],'--c','LineWidth',2);
     
    end
end


end


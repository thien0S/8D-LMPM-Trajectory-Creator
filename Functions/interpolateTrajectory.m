% Cette fonction interpole les points d'une trajectoire discrétisée
% grossièrement pour obtenir une trajectoire discrétisée plus finement.
function [trajectoireReelle,rho_Command,tq] = interpolateTrajectory(cartesianTrajectory,linMot_length,frequenceEchantillonnage,tempsTraj)


tau = 1:length(cartesianTrajectory);

frequenceSolver = frequenceEchantillonnage; % Hz
tempsTrajectoire = tempsTraj; % sec
nPointsTrajectoire = frequenceSolver*tempsTrajectoire;
tq = linspace(1,length(tau),nPointsTrajectoire);

% Interpolation de la trajectoire articulaire

rho_Command=zeros(8,nPointsTrajectoire);

for i = 1:8

    rho_Command(i,:) = interp1(linspace(1,length(tau),length(tau)),linMot_length(i,:),tq,'spline');

end


trajectoireReelle=NaN(8,nPointsTrajectoire);

for i = 1:8

    trajectoireReelle(i,:) = interp1(linspace(1,length(tau),length(tau)),cartesianTrajectory(i,:),tq,'spline');

end

end


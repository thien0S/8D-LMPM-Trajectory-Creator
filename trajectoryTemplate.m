% Ce script est un template permettant la création d'une trajectoire pour un robot
% parallèle à 8 degrés de liberté. Pour que ce script fonctionne, il faut la trajectoire
% respecte les noms de variable de sortie suivants:
% - pTraj => position de l'effecteur avec les coordonnées cartésiennes
%		Les dimensions de pTraj sont [3 x N] où N est le nombre de points de la trajectoire
%		avec pTraj(1,:) = x, pTraj(2,:) = y, pTraj(3,:) = z
% - Rot => orientation de l'effecteur avec les coordonnées angulaires
% 		Les dimensions de Rot sont [3 x N] où N est le nombre de points de la trajectoire
%		avec Rot(1,:) = phi, Rot(2,:) = theta, Rot(3,:) = sigma
% - nPointsTotal => nombre total de points de la trajectoire
% 
% La trajectoire doit ABSOLUMENT commencer au point de référence du robot et finir à ce même point.
% Les valeurs de référence sont données dans le template
% Les dimensions des matrices pTraj et Rot doivent être identiques.
%
% Bon code en tabarnak:) 


x_config_ref = 0;
y_config_ref = 0;
z_config_ref = -0.51;

phi_config_ref = 0;
theta_config_ref = 0;
sigma_config_ref = 0;




%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% Script Ici %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%





nPointsTotal = length(pTraj);

% Visualisation de la trajectoire pour vérification
f=figure('Name','Affichage de la trajectoire');
f.Position = [1200 200 700 700];
subplot(2,3,1)
plot(1:nPointsTotal,pTraj(1,:))
ylabel('x')
subplot(2,3,2)
plot(1:nPointsTotal,pTraj(2,:))
ylabel('y')
subplot(2,3,3)
plot(1:nPointsTotal,pTraj(3,:))
ylabel('z')
subplot(2,3,4)
plot(1:nPointsTotal,Rot(1,:))
ylabel('phi')
subplot(2,3,5)
plot(1:nPointsTotal,Rot(2,:))
ylabel('theta')
subplot(2,3,6)
plot(1:nPointsTotal,Rot(3,:))
ylabel('sigma')
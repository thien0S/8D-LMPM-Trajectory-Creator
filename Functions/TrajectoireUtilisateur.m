% Ce script permet de créer une trajctoire en fonction des waypoints
% rentrés par l'utilisateur. La trajectoire démarre forcément à la position
% de référence du robot. Puis entame la trajectoire voulu pour finir sa course à 
% la positition de référence.
%close all;
addpath("Functions\")   % Fonctions nécessaires

x_config_ref = 0;
y_config_ref = 0;
z_config_ref = -0.51;

phi_config_ref = 0;
theta_config_ref = 0;
sigma_config_ref = 0;

nPoints_phase1 = 40;
nPointsEntre2Waypoints = 50;

w = wayTraj(:,1);	%1er Waypoint
Qmat = QmatTraj(:,1);

TrajPhase1 = [TrajectoireEntre2Points(x_config_ref,w(1),nPoints_phase1);TrajectoireEntre2Points(y_config_ref,w(2),nPoints_phase1);TrajectoireEntre2Points(z_config_ref,w(3),nPoints_phase1)];
RotPhase1 = [TrajectoireEntre2Points(phi_config_ref,Qmat(1),nPoints_phase1);TrajectoireEntre2Points(theta_config_ref,Qmat(2),nPoints_phase1);TrajectoireEntre2Points(sigma_config_ref,0,nPoints_phase1)];

pTraj=TrajPhase1;
Rot=RotPhase1;


for i = 1:nbCyclesTraj
	for j = 1:waypoints-1
		w = wayTraj(:,j);	%Waypoint actuel
		Qmat = QmatTraj(:,j);
		wNext = wayTraj(:,j+1);	%Waypoint suivant
		QmatNext = QmatTraj(:,j+1);
		
		TrajPhase2 = [TrajectoireEntre2Points(w(1),wNext(1),nPointsEntre2Waypoints);TrajectoireEntre2Points(w(2),wNext(2),nPointsEntre2Waypoints);TrajectoireEntre2Points(w(3),wNext(3),nPointsEntre2Waypoints)];
		RotPhase2 = [TrajectoireEntre2Points(Qmat(1),QmatNext(1),nPointsEntre2Waypoints);TrajectoireEntre2Points(Qmat(2),QmatNext(2),nPointsEntre2Waypoints);TrajectoireEntre2Points(Qmat(3),QmatNext(3),nPointsEntre2Waypoints)];
		
		pTraj = cat(2,pTraj,TrajPhase2);
		Rot = cat(2,Rot,RotPhase2);
	end

	if(i ~= nbCyclesTraj)
		TrajPhase2 = [TrajectoireEntre2Points(wayTraj(1,end),wayTraj(1,1),nPointsEntre2Waypoints);TrajectoireEntre2Points(wayTraj(2,end),wayTraj(2,1),nPointsEntre2Waypoints);TrajectoireEntre2Points(wayTraj(3,end),wayTraj(3,1),nPointsEntre2Waypoints)];
		RotPhase2 = [TrajectoireEntre2Points(QmatTraj(1,end),QmatTraj(1,1),nPointsEntre2Waypoints);TrajectoireEntre2Points(QmatTraj(2,end),QmatTraj(2,1),nPointsEntre2Waypoints);TrajectoireEntre2Points(QmatTraj(3,end),QmatTraj(3,1),nPointsEntre2Waypoints)];
		
		pTraj = cat(2,pTraj,TrajPhase2);
		Rot = cat(2,Rot,RotPhase2);
	end
end

TrajPhase3 = [TrajectoireEntre2Points(wNext(1),x_config_ref,nPoints_phase1);TrajectoireEntre2Points(wNext(2),y_config_ref,nPoints_phase1);TrajectoireEntre2Points(wNext(3),z_config_ref,nPoints_phase1)];
RotPhase3 = [TrajectoireEntre2Points(QmatNext(1),phi_config_ref,nPoints_phase1);TrajectoireEntre2Points(QmatNext(2),theta_config_ref,nPoints_phase1);TrajectoireEntre2Points(QmatNext(3),sigma_config_ref,nPoints_phase1)];

pTraj = cat(2,pTraj,TrajPhase3);
Rot = cat(2,Rot,RotPhase3);

nPointsTotal = length(pTraj);



% Visualisation de la trajectoire
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
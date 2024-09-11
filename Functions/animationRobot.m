% Visualisation du robot aux différentes étapes de la trajectoire indiqué par l'utilisateur
% grâce aux waypoints
close all;

addpath("Functions\")   % Fonctions nécessaires
run("Parameters.m")	% Paramètres du robot

anglesMembresRedondants = [90,90]; % Angles de redondance en degrés
f=figure('Name','Affichage des Waypoints');
f.Position = [1200 200 700 700];
for i = 1:waypoints

	p = pTraj(:,i);
	Qmat = QmatTraj(:,i);
	Q = CALCULATOR_Q(Qmat(1),Qmat(2),Qmat(3));	%Matrice de rotation pour la suite des calculs
	[b,s] = CALCULATOR_b_s(p,Q,bprime,a,redundantLength,anglesMembresRedondants);
	
	drawRobot(a,b,s,p,sliderLength,statorLength,decalage,sliderShifting,distAttacheRing,1000);
	plot3(pTraj(1,:)*1000,pTraj(2,:)*1000,pTraj(3,:)*1000,'-o','Color','b','MarkerSize',10,...
                'MarkerFaceColor','#D9FFFF');
	grid on
	xlim([-350 350]); ylim([-350 350]); zlim([-700 250]);
	pause(.7);
	hold off;
end

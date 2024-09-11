%% Permet d'afficher la position du robot dans l'espace de manière graphique (et non physiquement réel)
close all;

addpath("Functions\")   % Fonctions nécessaires
run("Parameters.m")	% Paramètres du robot

anglesMembresRedondants = [90,90]; % Angles de redondance en degrés


% Pour tester sans l'app
% Qmat = [0;20;0]; % Matrice de rotation


% p = [0;-0.1;-0.32]; % Point formé par X, Y, Z entrée par l'utilisateur




Q = CALCULATOR_Q(Qmat(1),Qmat(2),Qmat(3));	%Matrice de rotation pour la suite des calculs
[b,s] = CALCULATOR_b_s(p,Q,bprime,a,redundantLength,anglesMembresRedondants);


% Création du robot pour visualisation

f = figure('Name','Représentation de la Position du Robot 8D-LMPM');
f.Position = [1200 200 700 700];
drawRobot(a,b,s,p,sliderLength,statorLength,decalage,sliderShifting,distAttacheRing,1000);
grid on
xlim([-350 350]); ylim([-350 350]); zlim([-700 250]);

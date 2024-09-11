% Ce script permet d'exporter la trajectoire vers le modèle simulink
% real Time. Si l'utilsateur à déjà créé des trajectoires alors 
% il peut incorporer la dernière trajectoire créé dans le modèle simulink 
% pour que le robot effectue cette dernière à la suite des autres. 
% Sinon l'utilisateur peut créer le modèle simulink et importer la 
% trajectoire dans le modèle

close all;
clc;
addpath("pos_8mot\");

ye = 'Oui';
no = 'Non';
loaded = false;


model = 'pos_8mot';
rhoCmd = evalin('base', 'rho_Command');	%Récupération de la commande des moteurs disponible dans l'espace de travail 'base'

nomTraj = inputdlg('Nom de la trajectoire :','Trajectoire',1);

answer = questdlg('Sauvegarder la trajectoire ?', ...
	'Exporter la trajectoire', ...
		ye, no, no);

switch answer
    case no
        return;

    case ye
        try     % if error (like trajVar.mat empty) = GOTO catch statement
            if ~isempty(load("trajVar.mat"))
                loaded = true;
                load("trajVar.mat");
            end
        catch 
            loaded = false;
        end
        if loaded == false
            clear tpsTrajTot; clear nomTrajTot; clear cmdRobot;
            tpsTrajTot = [];
            tpsTrajTot (:,end+1) = tempsTraj;
            tpsTrajTot(:,1)=[];
            nomTrajTot = {};
            nomTrajTot{1} = nomTraj;
            cmdRobot = {};
            cmdRobot{1} = rhoCmd; 
        else
            tpsTrajTot (:,end+1) = tempsTraj;
            nomTrajTot(:,end+1) = nomTraj;
            cmdRobot{end+1} = rhoCmd;
        end
		save("pos_8mot\trajVar.mat","tpsTrajTot","nomTrajTot","cmdRobot");		%Sauvegarde des trajs dans le fichier trajVar.mat
		
	otherwise
		return;
end

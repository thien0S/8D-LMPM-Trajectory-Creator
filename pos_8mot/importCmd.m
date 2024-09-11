% Script qui permet d'importer les commandes moteurs et les temps des traj
% Dans le model Simulink RealTime

clc;

import = load('trajVar.mat');

positionCmd = [0 0 0 0 0 0 0 0];
tempsTraj = 0;
for i = 1:length(import.cmdRobot)
	positionCmd = cat(1,positionCmd,import.cmdRobot{i});
end

for i = 1:length(import.tpsTrajTot)
	tempsTraj = cat(2,tempsTraj,import.tpsTrajTot(i));
end

positionCmd(1,:) = [];
tempsTraj(1) = [];

mdlWks = get_param('pos_8mot','ModelWorkspace');
mdlWks.assignin('positionCmd',positionCmd);
mdlWks.assignin('tempsTraj',tempsTraj);
% Ce script permet de lancer le modèle physique du robot sous simulink
% et de valider la trajectoire calculée précédemment. Le script a 
% pour objectif de setup le Mechanics Explorer pour visualiser la trajectoire
% et de lancer la simulation.

% clear;
close all;
clc;
addpath("8DOF_robotModel\")

model = 'x8DOF_Robot';
open_system(model);
sim(model);     % Lancement de la simulation
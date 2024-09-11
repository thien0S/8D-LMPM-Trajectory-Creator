%% Paramètres de l'architecture réelle du robot 8D-LMPM


% Les distances sont toutes données en mètres

% Vecteurs a
% Centre des articulations de la base dans le repère de la base
a = cell(6,2);

a{1,1} = [0.31666, 0.26717, 0]';
a{1,2} = [0.31666, -0.26717, 0]';
a{3} = [0.26717, -0.31666, 0]';
a{4} = [-0.26717, -0.31666, 0]';
a{2,1} = [-0.31666, -0.26717, 0]';
a{2,2} = [-0.31666, 0.26717, 0]';
a{5} = [-0.26717, 0.31666, 0]';
a{6} = [0.26717, 0.31666, 0]';

% Vecteur e - Vecteur de distance entre les bases de pattes redondantes
e = cell(2,1);
e{1} = (a{1,2}-a{1,1})/norm(a{1,2}-a{1,1});
e{2} = (a{2,2}-a{2,1})/norm(a{2,2}-a{2,1});

% Vecteurs bprime
% Centre des articulations de la plateforme dans le repère de la plateforme

bprime = cell(6,1);

bprime{1} = [0.10024,0,0]';
bprime{2} = [-0.10024,0,0]';
bprime{3} = [0.02487,-0.09682,0]';
bprime{4} = [-0.02487,-0.09682,0]';
bprime{5} = [-0.02487,0.09682,0]';
bprime{6} = [0.02487,0.09682,0]';

bprimeRot = cell(6,1);



% sliderShifting
% Décalages des sliders LinMot dus à la taille des articulations
% sphériques et rotoïdes.

% Patte Redondante : Distance entre le centre de l'articulation rotoïde et
% l'embout du slider LinMot.
% (1:4) --> # de patte : [(1,1),(1,2),(2,1),(2,2)]

% Patte Non-Redondante : Distance entre le centre de l'articulation
% sphérique et l'embout du slider LinMot.
% (5:8) --> # de patte : [3,4,5,6]

sliderShifting = [0.0400,0.0400,0.0400,0.0400,0.05509,0.05509,0.05509,0.05509];

load('motorData.mat');
currentData = motorData{2};
% statorLength
% Longeur des stators LinMot
statorLength = currentData(1,1)/1000;
% sliderLength
% Longeur des slider LinMot
sliderLength = currentData(3,2)/1000;

% decalage
% Distance entre le centre de l'articulation de la base et la base du
% stator. Cette dernière correspond à la surface forçant l'arrêt du slider
% par l'anneau de retenue sur l'embout de celui-ci.
decalage = 0.13483;

% disAttacheRing
% Distance entre le surface d'arrêt de l'anneau de retenue et l'embout
% adjacent du slider.
distAttacheRing = 7.2/1000;

% rhoMin
% Longueur minimale possible pour chaque patte
% (1:4) --> # de patte : [(1,1),(1,2),(2,1),(2,2)]
% (5:8) --> # de patte : [3,4,5,6]
rhoMin = decalage + statorLength + sliderShifting;

% rhoMax
% Longueur maximale possible pour chaque patte
% (1:4) --> # de patte : [(1,1),(1,2),(2,1),(2,2)]
% (5:8) --> # de patte : [3,4,5,6]
rhoMax = decalage + (sliderLength - distAttacheRing) + sliderShifting;

% redundantLength
% Longueur des membrures redondantes
redundantLength = 0.04200;

% Force maximale actionneur
maxForce = 21.5; % N


% Masse plateforme
mPlateforme = 0.746; % kg

% Masse stator
mStator = 0.520; % kg

% Masse tige
mTige = 0.480; % kg

% Centre de masse de la plateforme (repère de la plateforme)
cPlateforme = [0;0;-0.037]; % m
cPlateforme = [0;0;-0.1]; % m



% Paramètres de la charge à transporter
payload = mPlateforme; % kg, charge à l'effecteur
gravite=[0;0;-9.81]; % vecteur gravité
distanceCM=cPlateforme(3); % m, distance du centre de masse de la charge par rapport au plan passant par les centres de joints sphériques


% REVOIR CES VALEURS !!!!
betaMax = 73*pi/180; % Limite articulaire joint sphérique redondant
% betaMax = 45*pi/180; % Limite articulaire joint sphérique redondant

psiMax = 135*pi/180; % Limite articulaire joint sphérique redondant
limiteTiltJointSph = 135*pi/180; % Limite articulaire joint sphérique redondant

% Angles de redondance dans la configuration de calibration

gamma1_calib = pi - pi/4; 
gamma2_calib = pi/4; 

nPosAngleRedondant=91; % Discrétisation de l'espace des angles redondants

% Espace des angles de redondance
gamma1Vect=linspace(-pi,2*pi,nPosAngleRedondant);  
gamma2Vect=linspace(-pi,2*pi,nPosAngleRedondant);



% Fréquence de consigne manuelle angles de redondance


fconsigne = 4; % À chaque 10 pas de temps



% Vecteur d'erreur entre la cin�matique et les positions r�elles des
% actionneurs

rho_offset = [0 1.2/1000 0 0 0.85/1000 1.2/1000 2.2/1000 0]; % m


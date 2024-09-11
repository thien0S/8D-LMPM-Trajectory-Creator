%% Gestion de la redondance cinématique et creation de la commande pour les moteurs

%clear 
close all
clc

addpath("Functions\")   % Fonctions nécessaires
addpath("Trajectoire\") % Trajectoires possibles

% Alerte pour le User que le scirpt est en cours d'exécution
allfigs = findall(0,'Type', 'figure');
appController = findall(allfigs, 'Name', 'MATLAB App');
app_object = appController(1).RunningAppInstance;
app_object.Console.Value = 'Warning : Script GestionRedondance.m est en cours d execution. Patientez SVP...';



if ~isempty(fileTraj)   %Si un script de command à été uploadé on le run
    run(append(locTraj,fileTraj))
    fileTraj = [];
else
    run('TrajectoireUtilisateur.m')
end
run('Parameters.m');

% Vecteur de pas de temps
tau = 1:nPointsTotal;

mappeForce=NaN(nPosAngleRedondant,nPosAngleRedondant); % Contient la force requise parmi les 8 actionneurs qui est maximale, pour une paire gamma1 et gamma2

% Matrice enregistrant la force maximale parmi les 8 actionneurs associée à
% une paire d'angles des membrures redondantes, pour toutes les paires
% d'angles de redondance, pour toutes les positions cartésiennes de la
% trajectoire
redundantSpaceForce=NaN(3,nPosAngleRedondant*nPosAngleRedondant*length(tau)); %Nan == Not a Number (peut être inf/inf)

posActuelleAngRed=zeros(2,length(tau)); % Enregistre la paire d'angles redondants actuelle

% Barre de progression
progressBar = waitbar(0,'Démarrage');

%Init des trajectoires
phiTraj = Rot(1,:);
thetaTraj = Rot(2,:);
sigmaTraj = Rot(3,:);


for h=1:length(pTraj)
    
    waitbar(h/length(pTraj), progressBar, sprintf('Progression: %d %%', floor(h/length(pTraj)*100)));
    
    % Position/Orientation de la plateforme dans l'espace Cartésien
    phi=phiTraj(h); % Matrice
    theta=thetaTraj(h);
    sigma = sigmaTraj(h);
    p = pTraj(:,h);
    Q = CALCULATOR_Q(phi,theta,sigma);
    
    b1=p+Q*bprime{1};
    b2=p+Q*bprime{2};
    b3=p+Q*bprime{3};
    b4=p+Q*bprime{4};
    b5=p+Q*bprime{5};
    b6=p+Q*bprime{6};
    
    bprimeRot{1} = b1 - p;
    bprimeRot{2} = b2 - p;
    bprimeRot{3} = b3 - p;
    bprimeRot{4} = b4 - p;
    bprimeRot{5} = b5 - p;
    bprimeRot{6} = b6 - p;
    

    % Matrice enregistrant la force maximale parmi les 8 actionneurs associée à
    % une paire d'angles des membrures redondantes, pour toutes les paires
    % d'angles de redondance, à une configuration donnée de la plateforme
    trajectoryCloud=NaN(3,nPosAngleRedondant*nPosAngleRedondant);
    compteur=1;

    % Balayage de l'espace des angles de redondance pour une pose
    % Cartésienne donnée
    for j=1:length(gamma1Vect)
        for k=1:length(gamma2Vect)


            % Suppression des avertissements - accélére le traitement
            % puisque pas de print() à la console
            [~, MSGID] = lastwarn();
            warning('off', MSGID);
            
            
            gamma1=gamma1Vect(j);
            gamma2=gamma2Vect(k);

            anglesMembresRedondants = [gamma1*180/pi,gamma2*180/pi]; % Angles de redondance en degrés

            [b,s] = CALCULATOR_b_s(p,Q,bprime,a,redundantLength,anglesMembresRedondants);

            [J,K] = jacobianMat(a,b,s,bprimeRot);
            
            F=K'*(J\eye(6))';
            
%             externalLoad = cat(1,payload*gravite + payload*vecteur_accel_centripete(:,h),cross(Q*cPlateforme,payload*gravite + payload*vecteur_accel_centripete(:,h)));
            externalLoad = cat(1,payload*gravite,cross(Q*cPlateforme,payload*gravite));
            
            % Enregistre la valeur maximale des forces présentes dans les
            % actionneurs
            mappeForce(j,k)=max(F*externalLoad);
 
            
            if isnan(mappeForce(j,k)) || mappeForce(j,k)>maxForce % Si F est singulière ou près d'une singularité (pour fin d'affichage)
                mappeForce(j,k)=maxForce;                    
            end
            
            % Répertorie la force maximale à la paire d'angles associée
            trajectoryCloud(:,compteur)=[gamma1Vect(j);gamma2Vect(k);mappeForce(j,k)];
            compteur=compteur+1;
            
        end
    end
    
    
    % Enregistre les données de la précédente mappeForce dans une matrice
    % pour chaque configuration de la plateforme
    redundantSpaceForce(:,(h-1)*nPosAngleRedondant*nPosAngleRedondant+1:h*nPosAngleRedondant*nPosAngleRedondant) = trajectoryCloud;

    % Limites mécaniques     
    intervalleGeneralGamma1 = gammaIntervals(b{1},a{1,1},a{1,2},e{1},redundantLength,rhoMax(1),rhoMin(1),betaMax,Q,psiMax,limiteTiltJointSph);
    intervalleGeneralGamma2 = gammaIntervals(b{2},a{2,1},a{2,2},e{2},redundantLength,rhoMax(1),rhoMin(1),betaMax,Q,psiMax,limiteTiltJointSph);
    
    
    %%%%%%%%%%%%%%%%%%% Optimal Path %%%%%%%%%%%%%%%%%%%%%%
    
    % Permet de trouver les indices des angles de redondance dans le vecteur gamma1Vect pour avoir les limites mécaniques dans mappeforce
    lim1 = [indexReturn(gamma1Vect,intervalleGeneralGamma1(1)),indexReturn(gamma1Vect,intervalleGeneralGamma1(2))];     
    lim2 = [indexReturn(gamma2Vect,intervalleGeneralGamma2(1)),indexReturn(gamma2Vect,intervalleGeneralGamma2(2))];
    
    %mappeForce = mappeForce';
    mappeForceDist = mappeForce > 17;
    [D,IDX] = bwdist(mappeForceDist);
    workspace = mappeForce(lim1(1):lim1(2),lim2(1):lim2(2)); 
    workspaceDist = D(lim1(1):lim1(2),lim2(1):lim2(2));
    
    u = max(workspaceDist,[],'all');
    seuil = u-u/1.5;
        
    [line,col] = find(workspaceDist > seuil);
    point = [line,col];
    

% 
% 
%     % La consigne sur les angles de redondance est fixe les 'fconsigne'
%     % premiers pas de temps, afin de prévenir les discontinuités sur les
%     % angles de redondance au début de la trajectoire. En effet, au début
%     % et à la fin de chaque trajectoire, il est important que les angles
%     % de redondance soient identiques.
%     if h < fconsigne
%         gamma1actual = gamma1_calib;
%         gamma2actual = gamma2_calib; 
%         
%         gamma1Initial = gamma1_calib;
%         gamma2Initial = gamma2_calib;
%         
%         gamma1desired = gamma1_calib;
%         gamma2desired = gamma2_calib;
%     end

    % Initialisation du point suivant
    if h < 10
        pointInit = [indexReturn(gamma1Vect,gamma1_calib)-lim1(1),indexReturn(gamma2Vect,gamma2_calib)-lim2(1)];

        pointSuivant = computePoint(pointInit,point,workspaceDist,workspace);
        temp = gamma1Vect(pointInit(1)+lim1(1));
        temp1 = gamma2Vect(pointInit(2)+lim2(1));
        gamma1actual = gamma1_calib;%gamma1Vect(pointInit(1)+lim1(1)-1);    %Conversion entre point de 0 à 91 et angle de -pi à 2pi
        gamma2actual = gamma2_calib;%gamma2Vect(pointInit(2)+lim1(1)-1);
    %end
    else
        pointSuivant = computePoint(pointSuivant,point,workspaceDist,workspace);

        gamma1actual = gamma1Vect(pointSuivant(1)+lim1(1));    %Conversion entre point de 0 à 91 et angle de -pi à 2pi
        gamma2actual = gamma2Vect(pointSuivant(2)+lim2(1));
    end

    posActuelleAngRed(:,h) = [gamma1actual;gamma2actual];



end


close(progressBar);
% Lissage de la position des angles de redondances
posActuelleAngRed(1,1:end) = smoothdata(posActuelleAngRed(1,1:end),"gaussian",20);
posActuelleAngRed(2,1:end) = smoothdata(posActuelleAngRed(2,1:end),"gaussian",20);



% Retour des angles de redondance à leur valeur en début de trajectoire

% Nombre de pas de temps pour retourner à la configuration de référence
nPoints_retour_config_ref = 50;

% Initialisation du vecteur de trajectoire des angles redondants
% supplémentaire pour le retour è la configuration de référence. On
% initialise avec les dernières valeurs calculées des angles de redondance
% pour la sécurité.
angleRed_retour_config_ref = posActuelleAngRed(:,length(pTraj))*ones(1,nPoints_retour_config_ref);

gamma1desired = gamma1_calib;
gamma2desired = gamma2_calib;

gamma1Initial = posActuelleAngRed(1,length(pTraj));
gamma2Initial = posActuelleAngRed(2,length(pTraj));

for i = 1:nPoints_retour_config_ref
    tempsNormalise = mod(i-1,nPoints_retour_config_ref)/nPoints_retour_config_ref;
    polynomeNormalise = 6*tempsNormalise^5-15*tempsNormalise^4+10*tempsNormalise^3;
    gamma1actual = gamma1Initial + (gamma1desired - gamma1Initial)*polynomeNormalise;
    gamma2actual = gamma2Initial + (gamma2desired - gamma2Initial)*polynomeNormalise;
    angleRed_retour_config_ref(:,i) = [gamma1actual;gamma2actual];
end


figure();
plot(1:nPoints_retour_config_ref,angleRed_retour_config_ref(1,:));
hold on
plot(1:nPoints_retour_config_ref,angleRed_retour_config_ref(2,:));
hold off

% Augmentation des vecteurs de trajectoire cartésienne pour le retour à la
% configuration de référence des angles de redondance

pTraj = cat(2,pTraj,pTraj(:,end)*ones(1,nPoints_retour_config_ref));
phiTraj = cat(2,phiTraj,phiTraj(:,end)*ones(1,nPoints_retour_config_ref));
thetaTraj = cat(2,thetaTraj,thetaTraj(:,end)*ones(1,nPoints_retour_config_ref));
sigmaTraj = cat(2,sigmaTraj,sigmaTraj(:,end)*ones(1,nPoints_retour_config_ref));
posActuelleAngRed = cat(2,posActuelleAngRed,angleRed_retour_config_ref);

%% Animation dans l'espace des angles de redondance

close all
clc


tau = cat(2,1:nPointsTotal,nPointsTotal+1:nPointsTotal+nPoints_retour_config_ref);


% Initialisation de vecteurs pour l'animation sur les figures
detJ = NaN(1,length(tau));
legLength = NaN(8,length(tau));
forceActionneurs = NaN(8,length(tau));
anglesMembrureSousPatte = NaN(4,length(tau));
anglesEntreSousPatte = NaN(2,length(tau));

% Boite de dialogue pour skip l'animation
animation = true; % Par défaut, on affiche l'animation si l'utilisateur ferme la boite de dialogue
answer = questdlg('Skip animation de la trajectoires ?', ...
	'', ...
	'Oui','Non','Non');

switch answer
    case 'Oui'
        animation = false;
    case 'Non'
        animation = true;
end

if animation
    fig=figure();
end

for i=1:length(tau)
    
    phi=phiTraj(i);
    theta=thetaTraj(i);
    sigma = sigmaTraj(i);
    p = pTraj(:,i);
    
    Q = CALCULATOR_Q(phi,theta,sigma);
    
    b1=p+Q*bprime{1};
    b2=p+Q*bprime{2};
    b3=p+Q*bprime{3};
    b4=p+Q*bprime{4};
    b5=p+Q*bprime{5};
    b6=p+Q*bprime{6};
    
    bprimeRot{1} = b1 - p;
    bprimeRot{2} = b2 - p;
    bprimeRot{3} = b3 - p;
    bprimeRot{4} = b4 - p;
    bprimeRot{5} = b5 - p;
    bprimeRot{6} = b6 - p;


    anglesMembresRedondants = [posActuelleAngRed(1,i)*180/pi,posActuelleAngRed(2,i)*180/pi]; % Angles de redondance en degrés

    [b,s] = CALCULATOR_b_s(p,Q,bprime,a,redundantLength,anglesMembresRedondants);    
    [J,K] = jacobianMat(a,b,s,bprimeRot);   
    

    detJ(i) = det(J);    
    if animation
        clf
        subplot(2,3,2)
        plot(tau,detJ,'-r');
        grid minor
        xlim([0 length(tau)]),ylim([-5e-07 5e-07]);
        xlabel('Temps (step)'); ylabel('Déterminant matrice Jacobienne J');
    

        % Graphe de l'espace des angles de redondance
        
        subplot(2,3,1)  %Dans redundantSpaceForce = X,Y pour donnée et Z pour la couleur des points
        if i > length(tau) - nPoints_retour_config_ref 
            im=scatter(redundantSpaceForce(1,(length(tau) - nPoints_retour_config_ref-1)*nPosAngleRedondant*nPosAngleRedondant+1:(length(tau) - nPoints_retour_config_ref)*nPosAngleRedondant*nPosAngleRedondant), ...
                redundantSpaceForce(2,(length(tau) - nPoints_retour_config_ref-1)*nPosAngleRedondant*nPosAngleRedondant+1:(length(tau) - nPoints_retour_config_ref)*nPosAngleRedondant*nPosAngleRedondant), ...
                10,redundantSpaceForce(3,(length(tau) - nPoints_retour_config_ref-1)*nPosAngleRedondant*nPosAngleRedondant+1:(length(tau) - nPoints_retour_config_ref)*nPosAngleRedondant*nPosAngleRedondant),'filled','o');
        else
            im=scatter(redundantSpaceForce(1,(i-1)*nPosAngleRedondant*nPosAngleRedondant+1:i*nPosAngleRedondant*nPosAngleRedondant), ...
                redundantSpaceForce(2,(i-1)*nPosAngleRedondant*nPosAngleRedondant+1:i*nPosAngleRedondant*nPosAngleRedondant), ...
                10,redundantSpaceForce(3,(i-1)*nPosAngleRedondant*nPosAngleRedondant+1:i*nPosAngleRedondant*nPosAngleRedondant),'filled','o');
        end
        hold on    
        colorB = colorbar;
        colorB.Label.String = 'Force max dans un actionneur';   
        caxis([0,maxForce]);    

        plot(posActuelleAngRed(1,i),posActuelleAngRed(2,i),'* r');  %POSITION DU POINT ROUGE
    end
   
    % Détermination des limites mécaniques restrictives

    
    intervalleGeneralGamma1 = gammaIntervals(b{1},a{1,1},a{1,2},e{1},redundantLength,rhoMax(1),rhoMin(1),betaMax,Q,psiMax,limiteTiltJointSph);
    intervalleGeneralGamma2 = gammaIntervals(b{2},a{2,1},a{2,2},e{2},redundantLength,rhoMax(1),rhoMin(1),betaMax,Q,psiMax,limiteTiltJointSph);
    
    if  isempty(intervalleGeneralGamma1) || isempty(intervalleGeneralGamma2)
        sprintf('%d',i);
        error('Pose inatteignable. Step =');  
    end
    
    if animation
        % Affichage des limites mécaniques restrictives (carré bleu)    
        intervalBoxPlotting(intervalleGeneralGamma1,intervalleGeneralGamma2);   %PLOT LA BOITE DE LIMITE MECA
        xlabel('\gamma_1(rad)'), ylabel('\gamma_2(rad)');
        xlim([-pi 2*pi]),ylim([-pi 2*pi]);
        hold off  

        % Animation de la plateforme
        subplot(2,3,3)
        drawRobot(a,b,s,p,sliderLength,statorLength,decalage,sliderShifting,distAttacheRing,1000);
        grid on
        xlim([-350 350]); ylim([-350 350]); zlim([-700 250]);
    end

    % Calcul des efforts dans les actionneurs
    F=K'*(J\eye(6))';
    externalLoad = cat(1,payload*gravite,cross(Q*cPlateforme,payload*gravite));

    forceActionneurs(:,i) = F*externalLoad; 
    
    
    if animation
        subplot(2,3,4)
        plot(tau,forceActionneurs(1,:));
        hold on
        plot(tau,forceActionneurs(2,:));
        plot(tau,forceActionneurs(3,:));
        plot(tau,forceActionneurs(4,:));
        plot(tau,forceActionneurs(5,:));
        plot(tau,forceActionneurs(6,:));
        plot(tau,forceActionneurs(7,:));
        plot(tau,forceActionneurs(8,:));
        xlim([0,max(tau)]); ylim([-maxForce,maxForce]);
        grid minor
        xlabel('Temps (step)'); ylabel('Force dans les actionneurs (N)');
    end
    
    % Calcul des longueurs de pattes
    legLength(1:2,i) = [norm(s{1}-a{1,1});norm(s{1}-a{1,2})];
    legLength(3:4,i) = [norm(s{2}-a{2,1});norm(s{2}-a{2,2})];
    legLength(5:end,i) = [norm(b{3}-a{3,1});norm(b{4}-a{4,1});norm(b{5}-a{5,1});norm(b{6}-a{6,1})];
    
    if animation
        subplot(2,3,5)
        plot(tau,legLength(1,:));
        hold on
        plot(tau,legLength(2,:));
        plot(tau,legLength(3,:));
        plot(tau,legLength(4,:));
        plot(tau,legLength(5,:));
        plot(tau,legLength(6,:));
        plot(tau,legLength(7,:));
        plot(tau,legLength(8,:));
        xlim([0,max(tau)]); ylim([max(rhoMin),min(rhoMax)]);
        grid minor
        xlabel('Temps (step)'); ylabel('Longueur joint sphérique à joint cardan (m)');
    end
    anglesMembrureSousPatte(1,i) = acosd(dot(b{1}-s{1},a{1,1}-s{1})/(norm(b{1}-s{1})*norm(a{1,1}-s{1})));
    anglesMembrureSousPatte(2,i) = acosd(dot(b{1}-s{1},a{1,2}-s{1})/(norm(b{1}-s{1})*norm(a{1,2}-s{1})));
    anglesMembrureSousPatte(3,i) = acosd(dot(b{2}-s{2},a{2,1}-s{2})/(norm(b{2}-s{2})*norm(a{2,1}-s{2})));
    anglesMembrureSousPatte(4,i) = acosd(dot(b{2}-s{2},a{2,2}-s{2})/(norm(b{2}-s{2})*norm(a{2,2}-s{2})));
    
    anglesEntreSousPatte(1,i) = acosd(dot(s{1}-a{1,1},s{1}-a{1,2})/(norm(s{1}-a{1,1})*norm(s{1}-a{1,2})));
    anglesEntreSousPatte(2,i) = acosd(dot(s{2}-a{2,1},s{2}-a{2,2})/(norm(s{2}-a{2,1})*norm(s{2}-a{2,2})));
    
    if animation
        subplot(2,3,6)
        plot(tau,anglesMembrureSousPatte(1,:));
        hold on
        plot(tau,anglesMembrureSousPatte(2,:));
        plot(tau,anglesMembrureSousPatte(3,:));
        plot(tau,anglesMembrureSousPatte(4,:));
        plot(tau,73*ones(1,length(tau)),'--r'); % Limite mécanique
        plot(tau,anglesEntreSousPatte(1,:));
        plot(tau,anglesEntreSousPatte(2,:));
        plot(tau,18*ones(1,length(tau)),'--b'); % Limite mécanique
        xlabel('Temps (step)'); ylabel('Angle membrure redondante/sous-patte (degrés)');
        xlim([0, max(tau)]); ylim([0 180]);
        grid minor
        
        
        fig.Position = [100 100 1720 840];
        Fig(i) = getframe(fig) ;
        drawnow()
    end
    
    % Vérification d'interférences ou limites mécaniques
    Ai = CALCULATOR_Ai(a);
    Bi = CALCULATOR_Bi(b,s); % Attention ici, les 4 premières composantes de Bi sont les composantes des s_i. Je crois que c'est pour faciliter les fonctions d'interférences mécaniques.

    % Vérification des conditions de fonctionnement. Les conditions doivent
    % être vraies pour être respectées.
    if COND_mechanismInterference(Ai,Bi,b,s,sliderShifting,statorLength,sliderLength,decalage)
%         fprintf('[Pass] Condition d''interférence respectée\n');
    else
        %fprintf('[Fail] Condition d''interférence NON respectée!\n');
        error('[Fail] Condition d''interférence NON respectée!\n');
    end

    if COND_actuatorStroke(a,b,s,rhoMin,rhoMax,sliderShifting)
%         fprintf('[Pass] Condition de longueur de patte respectée\n');
    elseif COND_actuatorStroke(a,b,s,rhoMin,rhoMax,sliderShifting) == 0
        %fprintf('[Fail] Condition de longueur de patte NON respectée!\n');
        error('[Fail] Condition de longueur de patte NON respectée!\n');
        
    end

    if COND_jointAngle(Ai,Bi)
%         fprintf('[Pass] Condition d''angles articulaires à la base respectée\n');
    else
        %fprintf('[Fail] Condition d''angles articulaires à la base NON respectée!\n');
        error('[Fail] Condition d''angles articulaires à la base NON respectée!\n');
        
    end
    if COND_sphericalJointInterference(Ai,b,s)
%         fprintf('[Pass] Condition d''intereférence joints sphériques respectée\n');
    else
        %fprintf('[Fail] Condition d''intereférence joints sphériques NON respectée!\n');
        error('[Fail] Condition d''intereférence joints sphériques NON respectée!\n');
        
    end
    if COND_limiteArticulaireSpherique(Ai,b,s,Q)
%         fprintf('[Pass] Condition de limite articulaire joints sphériques respectée\n');
    else
        %fprintf('[Fail] Condition de limite articulaire joints sphériques NON respectée!\n');
        error('[Fail] Condition de limite articulaire joints sphériques NON respectée!\n');
        
    end
    
end

% Boite de dialogue pour save le fichier de commande
sauvegarde = true; % Par défaut, on affiche l'animation si l'utilisateur ferme la boite de dialogue
answer1 = questdlg('Sauvegarder le fichier de commande au format .mat ?', ...
	'Fichier de commande', ...
	'Oui','Non','Non');

switch answer1
    case 'Oui'
        sauvegarde = true;
    case 'Non'
        sauvegarde = false;
end


%Création de la commande pour les linMot
close all
run('trajectoireToCmd.m');
if sauvegarde
    nom = inputdlg({'Nom du fichier de commande'},'Création fichier de commande',1);
    save(strcat(nom{1},'.mat'),'rho_Command');
end

%Sauvegarde de la commande dans le workspace pour être accessible par les autres scripts
assignin("base","rho_Command",rho_Command);
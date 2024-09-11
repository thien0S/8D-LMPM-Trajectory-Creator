% Script qui permet de passer de la trajectoire Matlab à la commande linMot
% Le script applique une interpolation linéaire  afin d'effectuer les 
% trajectoires en un temps donné. Il vérifie que chaque trajectoire ne 
% comporte pas d'interférence mécanique.


% close;
% clc;

trajectoireUser = cat(1,pTraj,cat(1,phiTraj,cat(1,thetaTraj,cat(1,sigmaTraj,posActuelleAngRed))));


% Commande en position des moteurs
linMot_length = legLength - rhoMin' - rho_offset';





% Vérification interférences mécaniques
progressBar = waitbar(0,'Démarrage');
for i = 1:length(trajectoireUser)
    
    waitbar(i/length(trajectoireUser), progressBar, sprintf('Progression: %d %%', floor(i/length(trajectoireUser)*100)));
    
    p = trajectoireUser(1:3,i); %Platform's center position (x,y,z)
    phi   = trajectoireUser(4,i); %Tilt axis angle
    theta = trajectoireUser(5,i); %Tilt
    sigma = trajectoireUser(6,i); %Torsion

    Q = CALCULATOR_Q(phi,theta,sigma);

    % Angles des membres redondants � 90 deg est une membrure verticale
    anglesMembresRedondants = 180/pi*trajectoireUser(7:8,i)';

    [b,s] = CALCULATOR_b_s(p,Q,bprime,a,redundantLength,anglesMembresRedondants);

%     drawRobot(a,b,s,p,sliderLength,statorLength,decalage,sliderShifting,distAttacheRing,1000);

    Ai = CALCULATOR_Ai(a);
    Bi = CALCULATOR_Bi(b,s); % Attention ici, les 4 premières composantes de Bi sont les composantes des s_i. Je crois que c'est pour faciliter les fonctions d'interférences mécaniques.

    
%     drawRobot(a,b,s,p,sliderLength,statorLength,decalage,sliderShifting,distAttacheRing,1000);

    
    
    % V�rification des conditions de fonctionnement. Les conditions doivent
    % �tre vraies pour �tre respect�es.
    if COND_mechanismInterference(Ai,Bi,b,s,sliderShifting,statorLength,sliderLength,decalage)
%         fprintf('[Pass] Condition d''inter�rence respect�e\n');
    else
        error('[Fail] Condition d''inter�rence NON respect�e!\n');
    end

    if COND_actuatorStroke(a,b,s,rhoMin,rhoMax,sliderShifting)
%         fprintf('[Pass] Condition de longueur de patte respectée\n');
    else
        error('[Fail] Condition de longueur de patte NON respectée!\n');
        
    end

    if COND_jointAngle(Ai,Bi)
%         fprintf('[Pass] Condition d''angles articulaires à la base respect�e\n');
    else
        fprintf('[Fail] Condition d''angles articulaires à la base NON respect�e!\n');
        
    end
    if COND_sphericalJointInterference(Ai,b,s)
%         fprintf('[Pass] Condition d''inter�rence joints sph�riques respect�e\n');
    else
        error('[Fail] Condition d''inter�rence joints sph�riques NON respect�e!\n');
        
    end
    if COND_limiteArticulaireSpherique(Ai,b,s,Q)
%         fprintf('[Pass] Condition de limite articulaire joints sph�riques respect�e\n');
    else
        error('[Fail] Condition de limite articulaire joints sph�riques NON respect�e!\n');
        
    end
    
end

close(progressBar);

% Interpolation
[trajectoireReelle,rho_Command,tqUser] = interpolateTrajectory(trajectoireUser,linMot_length,1000,tempsTraj);



tau = 1:length(linMot_length);

% Trajectoire complète - Commande en longueur des pattes
figure();

plot(tau,linMot_length(1,:),'o r');
hold on
plot(tau,linMot_length(2,:),'* r');
plot(tau,linMot_length(3,:),'o g');
plot(tau,linMot_length(4,:),'o b');
plot(tau,linMot_length(5,:),'o c');
plot(tau,linMot_length(6,:),'o m');
plot(tau,linMot_length(7,:),'o y');
plot(tau,linMot_length(8,:),'o k');
legend('1','2','3','4','5','6','7','8');

plot(tqUser,rho_Command(1,:),'. b');

rho_Command = (1000*fix(rho_Command*1000000)/1000000)';

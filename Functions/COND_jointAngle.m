% Verifies the condition on the base joint angles so the sliders or stators
% don't interfere with the base itself.
function cond = COND_jointAngle(Ai,Bi)

    % minAngle : L'angle minimal entre le vecteur de direction de la tige
    % du joint de cardan de la base et celle de la patte.
%     minJointAngle = 30; %deg
    minJointAngle = 35; %deg, facteur de sécurité - Jonathan
    
    
    % CrÃ©ation des vecteurs d'orientation des articulations de la base
    jointDirect = zeros(3,4);
    jointDirect(:,1) = [-1;-1;0];
    
    
    % Attention ici, je crois qu'il y a une erreur dans l'assignation des
    % vecteurs d'orientation, à cause d'une mauvaise matrice de rotation.
    % Je prends le bloc corrigé d'après - Jonathan
    
%     sigma = 90; psi = -sigma; %Rotation autour de l'axe z
%     Q = [cosd(psi), sind(psi), 0;
%          -sind(psi), cosd(psi), 0;
%          0, 0, 1];
%      
%     for i = 2:4
%         jointDirect(:,i) = Q*jointDirect(:,i-1);
%     end
%     
%     %La fonction a été modifiée de manière à  directement prendre un vecteur
%     %d'orientation de joint plutôt qu'un point d'intersection.
%   
%     
%     orientationVect = zeros(3,8);
%     orientationVect(:,1) = jointDirect(:,1); orientationVect(:,8) = jointDirect(:,1);
%     orientationVect(:,2) = jointDirect(:,2); orientationVect(:,5) = jointDirect(:,2);
%     orientationVect(:,3) = jointDirect(:,3); orientationVect(:,6) = jointDirect(:,3);
%     orientationVect(:,4) = jointDirect(:,4); orientationVect(:,7) = jointDirect(:,4);


    sigma = -90; %Rotation autour de l'axe z
    Q = [cosd(sigma), -sind(sigma), 0;
         sind(sigma), cosd(sigma), 0;
         0, 0, 1];
     
    for i = 2:4
        jointDirect(:,i) = Q*jointDirect(:,i-1);
    end
    
    %La fonction a été modifiée de manière à  directement prendre un vecteur
    %d'orientation de joint plutôt qu'un point d'intersection.
  
    orientationVect = zeros(3,8);
    orientationVect(:,1) = jointDirect(:,1); orientationVect(:,8) = jointDirect(:,1);
    orientationVect(:,2) = jointDirect(:,2); orientationVect(:,5) = jointDirect(:,2);
    orientationVect(:,3) = jointDirect(:,3); orientationVect(:,6) = jointDirect(:,3);
    orientationVect(:,4) = jointDirect(:,4); orientationVect(:,7) = jointDirect(:,4);


    
    for i = 1:8
        
        v = orientationVect(:,i);
        u = Bi(:,i) - Ai(:,i);
        
        CosTheta = max(min(dot(u,v)/(norm(u)*norm(v)),1),-1);
        ThetaInDegrees = real(acosd(CosTheta));
        
        cond = ThetaInDegrees > minJointAngle;
        
        if ~cond
            break
        end
        
    end
end
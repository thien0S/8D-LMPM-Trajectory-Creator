function [gammaLimitInf,gammaLimitSupp,theta3] = limitePatteRedPlateforme(a_i1,a_i2,b_i,e_i,Q,psiMax,limiteTiltJointSph)

n=cross(b_i-a_i2,b_i-a_i1)/norm(cross(b_i-a_i2,b_i-a_i1));

% Le vecteur z est assum� dans le premier axe de rotation du joint
% sph�rique � la plateforme. On d�termine d'abord de quelle patte
% redondante il s'agit, puis on trouve z.

if isequal(a_i1,[0.31666;0.26717;0]) % Patte redondante 1
    
    z = Q*Ry(-45)*[-1;0;0];
    
elseif isequal(a_i1,[-0.31666;-0.26717;0]) % Patte redondante 2
    
    z = Q*Ry(45)*[1;0;0];
    
else
    fprintf('Problem in limitePatteRedPlateforme() function\n');
end


y=cross(z,n)/norm(cross(z,n));
x=cross(y,z)/norm(cross(y,z));

% % Calcul de la projection du vecteur n dans le plan xz
% x_prime = n - (dot(n,y)/(norm(y)^2))*y;
% theta4=real(acos(dot(x_prime,x)/(norm(x_prime)*norm(x))));

theta1=real(acos(dot(z,n)/(norm(z)*norm(n))));
theta4=theta1-pi/2;


    if abs(theta4)>(pi-psiMax) && abs(theta4)<psiMax
        gammaLimitInf=NaN;
        gammaLimitSupp=NaN;
        theta3=0;
    elseif ~any(y)
        gammaLimitInf=NaN;
        gammaLimitSupp=NaN;
        theta3=0;
        
    elseif theta4==0 
        gammaLimitInf=pi/2-limiteTiltJointSph;
        gammaLimitSupp=pi/2+limiteTiltJointSph;
        theta3=pi-psiMax;
        
    else
        % Vecteurs exprim�s dans le r�f�rentiel du joint sph�rique - voir
        % article de L-T Schreiber
        q1=[1;sqrt((tan(pi-psiMax)/tan(theta4))^2-1);1/tan(theta4)];
        q2=[1;-sqrt((tan(pi-psiMax)/tan(theta4))^2-1);1/tan(theta4)];
        
        % Moiti� de l'angle entre les vecteurs q1 et q2. M�me si ces vecteurs ne 
        % sont pas exprim�s dans le rep�re inertiel, l'angle entre ceux-ci
        % est identique peut importe dans quel r�f�rentiel il est mesur�.
        theta3=acos(dot(q1,q2)/(norm(q1)*norm(q2)))/2;

        % Convention axe-angle, puisqu'on fait une rotation autour de l'axe
        % y qui est exprim� dans le r�f�rentiel inertiel
        RotationMatrix=y*y'+cos(theta4)*(eye(3)-y*y')+sin(theta4)*[0,-y(3),y(2);y(3),0,-y(1);-y(2),y(1),0];
        
        % Projection du vecteur normal � la plateforme et dans le premier
        % axe de rotation du joint sph�rique. DOIT �TRE CHANG� POUR NOTRE
        % ARCHITECTURE CAR LE PREMIER AXE DE ROTATION DU JOINT SPH�RIQUE
        % N'EST PAS PERPENDICULAIRE � LA PLATEFORME.
        
        zPrime=RotationMatrix*z; % Exprim� dans le rep�re inertiel. 
        
        zeta=real(acos(dot(zPrime,e_i)/(norm(zPrime)*norm(e_i))));


       if zeta>theta3
           gammaLimitInf=-(zeta-theta3);
           gammaLimitSupp=2*pi-(zeta+theta3);
       else 
           gammaLimitInf=theta3-zeta;
           gammaLimitSupp=2*pi-(zeta+theta3);
       end

        
    end

    

end


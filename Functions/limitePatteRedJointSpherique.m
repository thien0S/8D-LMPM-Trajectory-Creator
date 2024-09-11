function [gammaLimitInf,gammaLimitSupp] = limitePatteRedJointSpherique(a_i1,a_i2,b_i,e_i,betaMax,l_membrure)

theta6_limSupp=acos(dot(e_i,a_i1-b_i)/(norm(e_i)*norm(a_i1-b_i)));
theta6_limInf=acos(dot(e_i,a_i2-b_i)/(norm(e_i)*norm(a_i2-b_i)));

phi_limSupp=asin(l_membrure*sin(betaMax)/norm(a_i1-b_i));
phi_limInf=asin(l_membrure*sin(betaMax)/norm(a_i2-b_i));

gammaLimitSupp=theta6_limSupp+(pi-betaMax-phi_limSupp);
gammaLimitInf=theta6_limInf-(pi-betaMax-phi_limInf);

end


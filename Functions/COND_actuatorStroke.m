% Verifies the condition on the actuator stroke length
function cond = COND_actuatorStroke(a,b,s,rhoMin,rhoMax,sliderShifting)
    
    rhoNorm = zeros(1,8);
    
    % Modification - Jonathan
    
    rhoNorm(1) = norm(s{1} - a{1,1});
    rhoNorm(2) = norm(s{1} - a{1,2});
    rhoNorm(3) = norm(s{2} - a{2,1});
    rhoNorm(4) = norm(s{2} - a{2,2});
    rhoNorm(5) = norm(b{3} - a{3,1});
    rhoNorm(6) = norm(b{4} - a{4,1});
    rhoNorm(7) = norm(b{5} - a{5,1});
    rhoNorm(8) = norm(b{6} - a{6,1});
    
%     for i = 1:4
%         
%         if i == 1
%             rhoNorm(i) = norm(s{1} - a{1,1});
%         elseif i == 2
%             rhoNorm(i) = norm(s{1} - a{1,2});
%         elseif i == 3
%             rhoNorm(i) = norm(s{2} - a{2,1}) - sliderShifting(i);
%         elseif i == 4
%             rhoNorm(i) = norm(s{2} - a{2,2}) - sliderShifting(i);
%         end
%     end
%     
%     for i = 5:8
%         rhoNorm(i) = norm(b{i-2} - a{i-2,1}) - sliderShifting(i);
%     end
    
    condMin = prod(rhoNorm>=rhoMin);
    condMax = prod(rhoNorm<=rhoMax);
    
    cond = condMin*condMax;
    
end
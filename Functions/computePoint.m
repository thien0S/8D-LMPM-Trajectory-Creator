% function pointSuivant = computePoint(point, L, minLocal)

%     tailleL = size(L);

% 	if tailleL(1)<point(1) || tailleL(2)<point(2)
% 		valueCurrentBlock = 1;
% 	else
% 		valueCurrentBlock = L(point(1),point(2));
% 	end

% 	if valueCurrentBlock == 0
		
% 		[D,IDX] = bwdist(minLocal);
% 		idNearBlock = IDX(point(1),point(2));
% 		valueCurrentBlock = L(ind2sub(L,idNearBlock));

% 	end
% 	centerPointBlock = regionprops(L,'Centroid');		% Structure contenant les coordonnées des centres des blocs
% 	centerPointCurrentBlock = round(centerPointBlock(valueCurrentBlock).Centroid);	% Coordonnées du centre du bloc actuel
% 	pointSuivant = [centerPointCurrentBlock(2),centerPointCurrentBlock(1)];
	
% end



function pointSuivant = computePoint(prevPoint, pointList,workspaceDist,workspace)
	if (prevPoint(1)>size(workspaceDist,1))
		prevPoint(1) = size(workspaceDist,1);
	end
	if (prevPoint(2)>size(workspaceDist,2))
		prevPoint(2) = size(workspaceDist,2);
	end

	% Trouver l'index le plus proche
	passageSingu = true;
	while passageSingu      % Tant que le chemin entre previous point et current point passe par une singu
		distances = sqrt(sum((pointList - prevPoint).^2, 2));
		[~, closestIndex] = min(distances);
		passageSingu = verifPassageSingu(workspace, prevPoint, pointList(closestIndex,:));  %Utilisation de l'algo de Bresenham

		if passageSingu
			pointList(closestIndex,:) = [];     %Si on passe par une singu on enleve le point et on recommence
		else
			pointSuivant = pointList(closestIndex,:);
		end
		
		if isempty(pointList)
			pointSuivant = prevPoint;
			break;
		end
	end







	





    % passageSingu = true;
	% while passageSingu
	% 	[line,col] = find(workspaceDist >= max(workspaceDist,[],'all')-1);
	% 	% On prend le point le plus eloigné de la zone de travail
	% 	pointMax = [line,col];
	% 	distances = sqrt(sum((pointMax - prevPoint).^2, 2));
	% 	[~, closestIndex] = min(distances);
	% 	passageSingu = verifPassageSingu(workspace, prevPoint, pointMax(closestIndex,:));
	% 	if passageSingu
	% 		workspaceDist(pointMax(closestIndex,1),pointMax(closestIndex,2)) = 0;
	% 	else
	% 		pointSuivant = pointMax(closestIndex,:);
	% 		break;
	% 	end
	% 	if max(workspaceDist,[],'all') == 0
	% 		pointSuivant = prevPoint;
	% 		break;
	% 	end
	% end
end

function pointSuivant = verifPoint(pointSuivant, G)
	taille = size(G);
	
	if pointSuivant(1) <= 5
		pointSuivant(1) = 5;
	elseif pointSuivant(1) > taille(2)-5
		pointSuivant(1) = taille(2)-5;
	end

	if pointSuivant(2) <= 5
		pointSuivant(2) = 5;
	elseif pointSuivant(2) > taille(1)-5
		pointSuivant(2) = taille(1)-5;
	end
end
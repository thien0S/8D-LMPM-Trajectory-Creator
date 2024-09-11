function resultPassageSingu = verfiPassageSingu( matrice, prevPoint, newPoint)
	% Verifie si le chemin entre prevPoint et newPoint passe par une singu
	% Utilisation de l'algo de Bresenham
	% matrice : matrice de la mappe de force
	% prevPoint : point de depart
	% newPoint : point d'arrivee
	% resultPassageSingu : true si le chemin passe par une singu, false sinon
	% resultPassageSingu = false;


	bresenhamList = bresenham(matrice, prevPoint(1), prevPoint(2), newPoint(1), newPoint(2));

	if (isempty(find(bresenhamList > 20)))
		resultPassageSingu = false;
	else
		resultPassageSingu = true;
	end


end
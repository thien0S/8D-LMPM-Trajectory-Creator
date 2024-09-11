function outputTraj = TrajectoireEntre2Points(point1, point2, nbPoint)
	

	outputTraj = zeros(1, nbPoint);

	for k = 1:nbPoint
		[pos,~,~]=trajectoireContinue2eOrdre(point1,point2,k,nbPoint);
		outputTraj(:,k)=pos;
	end
end
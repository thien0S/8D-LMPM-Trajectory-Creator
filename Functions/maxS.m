function value = maxS(S)

	temp = zeros(length(S),1);
    for i = 1:length(S)
		temp(i) = S(i).Area;
	end
	value = max(temp);
end
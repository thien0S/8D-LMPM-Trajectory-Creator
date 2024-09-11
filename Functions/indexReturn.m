function index = indexReturn(array, value)

    differences = abs(array - value);
	[~,index] = min(differences);
	
end
function nonSquareMat = nonSquareDiag(array)

	% Define the size of the non-square matrix
	numRows = size(array, 1);
	numCols = size(array, 2);

	% Initialize the non-square matrix with zeros
	nonSquareMat = zeros(numCols,numRows);

	% Determine the length of the diagonal
	diagLength = min(numCols,numRows);

	% Place 1s along the diagonal
	for i = 1:diagLength
		nonSquareMat(i, i) = 1;
	end

		
end




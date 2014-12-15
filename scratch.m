
% Merge redundant columns...
numSamples = size(trainData, 1);
numClasses = 7;
mergedData = zeros(numSamples, 17);

for i = 1:numSamples
	% Copy over the initial features...
	for j = 1:14
		mergedData(i, j) = trainData(i, j+1);
    end
	
	% Wilderness area merge
	%for j = 11:14
%		if (data(i, j) == 1)
%			mergedData(i, 11) = j - 11;
%			break
%		end
 %   end

	% Soil type merge
    % The values correspond to "climactic zone" and "geologic zone"
    % described in covtype.info
	for j = 15:54
		if (trainData(i, j+1) == 1)
			if (j <= 20)
                mergedData(i,15) = 2; 
                mergedData(i,16) = 7;
            elseif (j <= 22)
                mergedData(i,15) = 3; 
                mergedData(i,16) = 5;
            elseif (j <= 23)
                mergedData(i,15) = 4; 
                mergedData(i,16) = 2;
            elseif (j <= 27)
                mergedData(i,15) = 4; 
                mergedData(i,16) = 7;
            elseif (j <= 29)
                mergedData(i,15) = 5; 
                mergedData(i,16) = 1;
            elseif (j <= 31)
                mergedData(i,15) = 6; 
                mergedData(i,16) = 1;
            elseif (j <= 32)
                mergedData(i,15) = 6; 
                mergedData(i,16) = 7;
            elseif (j <= 35)
                mergedData(i,15) = 7; 
                mergedData(i,16) = 1;
            elseif (j <= 37)
                mergedData(i,15) = 7; 
                mergedData(i,16) = 2;
            elseif (j <= 48)
                mergedData(i,15) = 7; 
                mergedData(i,16) = 7;
            elseif (j <= 54)
                mergedData(i,15) = 8; 
                mergedData(i,16) = 7;
            else
                assert(false);
            end
           break;
		end
    end

	% Cover type
	mergedData(i, 17) = trainData(i, 56);
end

features = mergedData;
features(:,17) = [];
classification = mergedData(:, 17);

numTestSamples = size(testData, 1);
mergedTestData = zeros(numTestSamples, 16);

for i = 1:numTestSamples
	% Copy over the initial features...
	for j = 1:14
		mergedTestData(i, j) = testData(i, j+1);
    end
	

	% Soil type merge
    % The values correspond to "climactic zone" and "geologic zone"
    % described in covtype.info
	for j = 15:54
		if (testData(i, j+1) == 1)
			if (j <= 20)
                mergedTestData(i,15) = 2; 
                mergedTestData(i,16) = 7;
            elseif (j <= 22)
                mergedTestData(i,15) = 3; 
                mergedTestData(i,16) = 5;
            elseif (j <= 23)
                mergedTestData(i,15) = 4; 
                mergedTestData(i,16) = 2;
            elseif (j <= 27)
                mergedTestData(i,15) = 4; 
                mergedTestData(i,16) = 7;
            elseif (j <= 29)
                mergedTestData(i,15) = 5; 
                mergedTestData(i,16) = 1;
            elseif (j <= 31)
                mergedTestData(i,15) = 6; 
                mergedTestData(i,16) = 1;
            elseif (j <= 32)
                mergedTestData(i,15) = 6; 
                mergedTestData(i,16) = 7;
            elseif (j <= 35)
                mergedTestData(i,15) = 7; 
                mergedTestData(i,16) = 1;
            elseif (j <= 37)
                mergedTestData(i,15) = 7; 
                mergedTestData(i,16) = 2;
            elseif (j <= 48)
                mergedTestData(i,15) = 7; 
                mergedTestData(i,16) = 7;
            elseif (j <= 54)
                mergedTestData(i,15) = 8; 
                mergedTestData(i,16) = 7;
            else
                assert(false);
            end
           break;
		end
    end

end

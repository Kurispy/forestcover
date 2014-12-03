% Load the data in
testData = load('test.csv');

% Merge redundant columns...
numTestSamples = size(testData, 1);
numClasses = 7;
mergedTestData = zeros(numTestSamples, 12);
for i = 1:numTestSamples
	% Copy over the initial features...
	for j = 1:10
		mergedTestData(i, j) = testData(i, j + 1);
	endfor
	
	% Wilderness area merge
	for j = 12:15
		if (testData(i, j) == 1)
			mergedTestData(i, 11) = j - 12;
			break
		end
	endfor

	% Soil type merge
	for j = 16:55
		if (testData(i, j) == 1)
			mergedTestData(i, 12) = j - 16;
			break
		end
	endfor
endfor

testFeatures = mergedTestData;

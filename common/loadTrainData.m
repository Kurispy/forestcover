% Load the data in
trainData = load('train.csv');

% Merge redundant columns...
numTrainSamples = size(trainData, 1);
numClasses = 7;
mergedData = zeros(numTrainSamples, 13);
for i = 1:numTrainSamples
	% Copy over the initial features...
	for j = 1:10
		mergedData(i, j) = trainData(i, j + 1);
	endfor
	
	% Wilderness area merge
	for j = 12:15
		if (trainData(i, j) == 1)
			mergedData(i, 11) = j - 12;
			break
		end
	endfor

	% Soil type merge
	for j = 16:55
		if (trainData(i, j) == 1)
			mergedData(i, 12) = j - 16;
			break
		end
	endfor

	% Cover type
	mergedData(i, 13) = trainData(i, 56);
endfor

trainData = mergedData;
features = trainData;
features(:,13) = []; % Get rid of cover type
classification = trainData(:, 13);

% Get the types into separate matrices
spruceIdx = (trainData(:,13) == 1);
spruce = trainData(spruceIdx,:);

lodgepolePineIdx = (trainData(:,13) == 2);
lodgepolePine = trainData(lodgepolePineIdx,:);

ponderosaPineIdx = (trainData(:,13) == 3);
ponderosaPine = trainData(ponderosaPineIdx,:);

willowIdx = (trainData(:,13) == 4);
willow = trainData(willowIdx,:);

aspenIdx = (trainData(:,13) == 5);
aspen = trainData(aspenIdx,:);

douglasIdx = (trainData(:,13) == 6);
douglas = trainData(douglasIdx,:);

krummholzIdx = (trainData(:,13) == 7);
krummholz = trainData(krummholzIdx,:);
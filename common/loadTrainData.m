% Load the data in
trainData = load('train.csv');
testData = load('test.csv');

% Merge redundant columns...
numTrainSamples = size(trainData, 1);
numClasses = 7;
mergedData = zeros(numTrainSamples, 13);
for i = 1:numTrainSamples
	% Copy over the initial features...
	for j = 1:10
		mergedData(i, j) = trainData(i, j + 1);
    end
	
	% Wilderness area merge
	for j = 12:15
		if (trainData(i, j) == 1)
			mergedData(i, 11) = j - 12;
			break
		end
    end

	% Soil type merge
	for j = 16:55
		if (trainData(i, j) == 1)
			mergedData(i, 12) = j - 16;
			break
		end
    end

	% Cover type
	mergedData(i, 13) = trainData(i, 56);
end

numTestSamples = size(testData, 1);
mergedTestData = zeros(numTestSamples, 12);

for i = 1:numTestSamples
	% Copy over the initial features...
	for j = 1:10
		mergedTestData(i, j) = testData(i, j + 1);
    end
	
	% Wilderness area merge
	for j = 12:15
		if (testData(i, j) == 1)
			mergedTestData(i, 11) = j - 12;
			break
		end
    end

	% Soil type merge
	for j = 16:55
		if (testData(i, j) == 1)
			mergedTestData(i, 12) = j - 16;
			break
		end
    end

end

%testIdx=15121:1:581012;
%testIdx=testIdx';

testIdx = testData(:,1);
testData = mergedTestData;

features = trainData;
features(:,13) = [];
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

labels = doKNNClassification(features, classification, testData);
%
%mdl = fitcknn(features,classification);
%mdl.NumNeighbors = 4;

%[label,score,cost] = predict(mdl,testData);
predictedCover = zeros(numTestSamples, 2);
predictedCover(:,1) = testIdx;
predictedCover(:,2) = label;

WritePredictionsToFile(predictedCover,'C:\Users\Jesse\Documents\Machine Learning\Project\forestcover\predictions.csv');

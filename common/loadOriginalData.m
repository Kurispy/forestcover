% Load the data in
addpath('C:\Users\Jesse\Documents\Machine Learning\Project\forestcover');
data = load('covtype.data');

% Merge redundant columns...
numSamples = size(data, 1);
numClasses = 7;
mergedData = zeros(numSamples, 13);
for i = 1:numSamples
	% Copy over the initial features...
	for j = 1:10
		mergedData(i, j) = data(i, j);
    end
	
	% Wilderness area merge
	for j = 11:14
		if (data(i, j) == 1)
			mergedData(i, 11) = j - 12;
			break
		end
    end

	% Soil type merge
	for j = 15:54
		if (data(i, j) == 1)
			mergedData(i, 12) = j - 16;
			break
		end
    end

	% Cover type
	mergedData(i, 13) = data(i, 55);
end


%testIdx=15121:1:581012;
%testIdx=testIdx';

%testIdx = testData(:,1);
%testData = mergedTestData;

features = data;
features(:,13) = [];
classification = data(:, 13);

%for getting up to speed, I'm going to trim the dataset to 10% of its
%original size.
idx = crossvalind('holdout',classification,0.9);

features=features(idx,:);
classification=classification(idx,:);

%% end of trimming

[train,test] = crossvalind('holdout',classification,0.5);

% Pull out the training set
trainSetInputs = features(train,:);   
trainSetTargets = classification(train,:);   

% Pull out the test set.  
testSetInputs=features(test,:);
testSetTargets=classification(test,:);


labels = doKNNClassification(trainSetInputs, tr
ainSetTargets, testSetInputs);
success = labels == testSetTargets;

pctCorrect = sum(success) / size(testSetInputs,1);
fprintf('Percentage correct: %f\n', pctCorrect);
%
%mdl = fitcknn(features,classification);
%mdl.NumNeighbors = 4;

%[label,score,cost] = predict(mdl,testData);
predictedCover = zeros(numTestSamples, 2);
predictedCover(:,1) = testIdx;
predictedCover(:,2) = label;

WritePredictionsToFile(predictedCover,'C:\Users\Jesse\Documents\Machine Learning\Project\forestcover\predictions.csv');

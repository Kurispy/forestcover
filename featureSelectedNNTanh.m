% Add Deep learning toolbox code
addpath(genpath('DeepLearnToolbox'));

% Add common code
addpath(genpath('common'));

% Load the data
if (exist('mergedData', 'var') == 0)
	loadData;
end

printf('Loaded data successfully\n');
printf('Creating Neural Network...\n');
fflush(stdout);

% Create neural net targeted output
printf('Creating targeted output...');
fflush(stdout);

targetedOutput = zeros(size(mergedData, 1), numClasses);
for i = 1:size(mergedData, 1)
	targetedOutput(i, mergedData(i, 13)) = 1;
endfor

printf(' Done\n');
fflush(stdout);

% K fold cross validation
printf('10 fold cross validation...');
fflush(stdout);

index = 1:size(mergedData, 1);
index = index(randperm(length(index)));
part = int32(size(mergedData, 1) / 10);

for i = 1:10
	startP = part * (i - 1) + 1;
	endP = startP + part - 1;
	testData = [mergedData(index(startP:endP), 1) mergedData(index(startP:endP), 12)];
	yTest = targetedOutput(index(startP:endP), :);

	trainData = [mergedData(:, 1) mergedData(:, 12)];
	trainData(index(startP:endP), :) = [];
	yTrain = targetedOutput;
	yTrain(index(startP:endP), :) = [];

	% Construct 3 layer ANN with 5 hidden nodes and 7 output nodes for all 12 features
	% Using L2 regularization
	clear neuralNet
	neuralNet = nnsetup([size(trainData, 2) 5 numClasses]);
	neuralNet.activation_function = 'tanh_opt';
	neuralNet.learningRate = 1.5;
	neuralNet.weightPenaltyL2 = 1e-4;
	opts.numepochs = 50;
	opts.batchsize = 569;
	opts.plot = 1;

	[neuralNet, L] = nntrain(neuralNet, trainData, yTrain, opts);
	[err, bad] = nntest(neuralNet, testData, yTest);

	err
	fflush(stdout);
endfor

printf(' Done\n');
fflush(stdout);

% Test
% printf('Predicting...');
% fflush(stdout);
% predictions = [];
% for i = 1:numTestSamples
% 	predictions = [predictions ; nnpredict(neuralNet, normTestFeatures(i,:))];
% endfor
% printf(' Done\n');
% fflush(stdout);

% printf('Saving predictions to file...');
% fflush(stdout);
% save vanillaNNTanhPredictions.txt predictions;
% printf(' Done\n');
% fflush(stdout);
%warning ("off", "Octave:broadcast");

% Add Deep learning toolbox code
addpath(genpath('DeepLearnToolbox'));

% Add common code
addpath(genpath('common'));

% Load the data
if (exist('mergedData', 'var') == 0)
	loadData;
end

printf('Loaded data successfully\n');
fflush(stdout);

% Create neural net targeted output
printf('Creating targeted output...');
fflush(stdout);

targetedTrainOutput = zeros(size(trainData, 1), numClasses);
targetedTestOutput = zeros(size(testData, 1), numClasses);
for i = 1:size(trainData, 1)
	targetedTrainOutput(i, trainData(i, 13)) = 1;
endfor

for i = 1:size(testData, 1)
	targetedTestOutput(i, testData(i, 13)) = 1;
endfor

printf(' Done\n');
fflush(stdout);


% Construct ANN matrix
printf('Creating structure matrix...');
fflush(stdout);

configMatrix = [];
features = [trainData(:, 1) trainData(:, 12)];
testFeatures = [testData(:, 1) testData(:, 12)];
for layer = 1:3
	for nodes = [3 5 8 10]
		[2 repmat(nodes, 1, layer) numClasses]
		fflush(stdout);

		clear neuralNet;
		neuralNet = nnsetup([2 repmat(nodes, 1, layer) numClasses]);
		neuralNet.activation_function = 'sigm';
		neuralNet.learningRate = 1.5;
		neuralNet.weightPenaltyL2 = 1e-4;
		opts.numepochs = 100;
		opts.plot = 0;
		opts.batchsize = 104;

		[neuralNet, L] = nntrain(neuralNet, features, targetedTrainOutput, opts);
		[err, bad] = nntest(neuralNet, testFeatures, targetedTestOutput);

		configMatrix(layer, nodes) = err;
	endfor
endfor

% Output configMatrix
configMatrix

printf(' Done\n');
fflush(stdout);
% Add Deep learning toolbox code
addpath(genpath('DeepLearnToolbox'));

% Add common code
addpath(genpath('common'));

% Load the train data
loadTrainData;

% Create neural net targeted output
numClasses = 7;
yTrain = zeros(size(trainData, 1), numClasses);
for i = 1:numClasses
	for j = 1:size(trainData, 1)
		if (trainData(j, 56) == i)
			yTrain(j, i) = 1;
		end
	endfor
endfor

% Construct 3 layer ANN with 10 hidden nodes and 7 output nodes for all features
neuralNet = nnsetup([56 10 numClasses]);
neuralNet.activation_function = 'sigm';
neuralNet.learningRate = 2;
opts.numepochs = 50;
opts.batchsize = 5;
opts.plot = 1;

% Train on each sample...
trainWeights = [];
trainError = [];
trainHiddenError = [];
trainOutput = [];

% Train
[neuralNet, L] = nntrain(neuralNet, trainData, yTrain, opts);

L
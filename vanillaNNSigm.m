% Add Deep learning toolbox code
addpath(genpath('DeepLearnToolbox'));

% Add common code
addpath(genpath('common'));

% Load the train data if needed
if (exist("mergedData", "var") == 0)
	loadTrainData;
end

% Create neural net targeted output
yTrain = zeros(size(trainData, 1), numClasses);
for i = 1:numTrainSamples
	yTrain(i, classification(i)) = 1;
endfor

% Normalize
[normFeatures, mu, sigma] = zscore(features);

% Construct 3 layer ANN with 5 hidden nodes and 7 output nodes for all features
neuralNet = nnsetup([size(features, 2) 5 numClasses]);
neuralNet.activation_function = 'sigm';
neuralNet.learningRate = 0.5;
opts.numepochs = 50;
opts.batchsize = 105;
opts.plot = 1;

% Train
[neuralNet, L] = nntrain(neuralNet, normFeatures, yTrain, opts);

L
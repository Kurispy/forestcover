% Add Deep learning toolbox code
addpath(genpath('DeepLearnToolbox'));

% Add common code
addpath(genpath('common'));

% Load the train data if needed
if (exist('mergedData', 'var') == 0)
	loadTrainData;
end

% Load the test data if needed (warning: takes a LONG time)
if (exist('mergedTestData', 'var') == 0) 
	loadTestData;
end

% Create neural net targeted output
yTrain = zeros(size(trainData, 1), numClasses);
for i = 1:numTrainSamples
	yTrain(i, classification(i)) = 0.9;
endfor

% Normalize
[normFeatures, mu, sigma] = zscore(features);

% Select features soil type and elevation
selectFeatures = normFeatures(:,12);
selectFeatures = [normFeatures(:,1) selectFeatures];

% Construct 3 layer ANN with 5 hidden nodes and 7 output nodes for all features
neuralNet = nnsetup([size(selectFeatures, 2) 3 4 numClasses]);
neuralNet.activation_function = 'sigm';
neuralNet.learningRate = 1;
opts.numepochs = 100;
opts.batchsize = 105;
opts.plot = 1;

% Train
[neuralNet, L] = nntrain(neuralNet, selectFeatures, yTrain, opts);

L
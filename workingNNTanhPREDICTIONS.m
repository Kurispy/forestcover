% Add Deep learning toolbox code
addpath(genpath('DeepLearnToolBox'));

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
predictions = zeros(size(mergedData, 1),8);

for i = 1:10
	startP = part * (i - 1) + 1;
	endP = startP + part - 1;
	testData = mergedData(index(startP:endP), 1:12);
	testAnswers = mergedData(index(startP:endP), 13);
	yTest = targetedOutput(index(startP:endP), :);

	trainData = mergedData(:, 1:12);
	trainData(index(startP:endP), :) = [];
	yTrain = targetedOutput;
	yTrain(index(startP:endP), :) = [];

	% Construct 3 layer ANN with 5 hidden nodes and 7 output nodes for all 12 features
	% Using L2 regularization
  
  clear neuralNet
	neuralNet = nnsetup([size(trainData, 2) 25 19 numClasses]);
	neuralNet.activation_function = 'tanh_opt';
	neuralNet.learningRate = 1.5;
	neuralNet.weightPenaltyL2 = 1e-4;
	opts.numepochs = 50;
	opts.batchsize = 919;
	opts.plot = 0;

	[neuralNet, L] = nntrain(neuralNet, trainData, yTrain, opts);
	[err, bad] = nntest(neuralNet, testData, yTest);

  report = [i err]
	Ans(i) = err;
	fflush(stdout);
	
	for j = startP:endP
	  output = predictNEW(neuralNet, mergedData(index(j),1:12));
	  predictions(index(j),:) = [ output mergedData(index(j),13) ];
	endfor

  endfor

printf(' Done\n');
fflush(stdout);


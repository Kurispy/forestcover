% Load the data in
printf('Loading data...');
fflush(stdout);
if (exist('UCICoverTypeData', 'var') == 0)
	UCICoverTypeData = load('data.csv');
	numClasses = 7;
end
printf(' Done\n');
fflush(stdout);

% Merge redundant columns...
printf('Merging data...');
fflush(stdout);
numSamples = size(UCICoverTypeData, 1);
numClasses = 7;
mergedData = zeros(numSamples, 13);

[wilderness, ~] = find(UCICoverTypeData(:,11:14)');
[soil, ~] = find(UCICoverTypeData(:,15:54)');
mergedData = [UCICoverTypeData(:, 1:10) wilderness soil];

% Normalize features
[mergedData, ~, ~] = zscore(mergedData);
mergedData = [mergedData UCICoverTypeData(:, 55)];

printf(' Done\n');
fflush(stdout);

% Split our data into 75% 25%
printf('Random 75% 25% split...');
fflush(stdout);

numTestSamples = int32(size(mergedData, 1) * 0.25);

index = 1:size(mergedData, 1);
index = index(randperm(length(index)));

testData = mergedData(index(1:numTestSamples), :);
trainData = mergedData(index(numTestSamples:end), :);

numTrainSamples = size(trainData, 1);

printf(' Done\n');
fflush(stdout);

% Get the types into separate matrices
spruceIdx = (mergedData(:,13) == 1);
spruce = mergedData(spruceIdx,:);

lodgepolePineIdx = (mergedData(:,13) == 2);
lodgepolePine = mergedData(lodgepolePineIdx,:);

ponderosaPineIdx = (mergedData(:,13) == 3);
ponderosaPine = mergedData(ponderosaPineIdx,:);

willowIdx = (mergedData(:,13) == 4);
willow = mergedData(willowIdx,:);

aspenIdx = (mergedData(:,13) == 5);
aspen = mergedData(aspenIdx,:);

douglasIdx = (mergedData(:,13) == 6);
douglas = mergedData(douglasIdx,:);

krummholzIdx = (mergedData(:,13) == 7);
krummholz = mergedData(krummholzIdx,:);
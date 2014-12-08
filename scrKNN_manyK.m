% Load the data in
projectPath = 'C:\Users\Jesse\Documents\Machine Learning\Project\forestcover';
LMNNPath = strcat(projectPath,'\mLMNN2.5');
addpath(projectPath);
addpath(LMNNPath);
cd(LMNNPath);
run('setpaths.m');
data = load('covtype.data');
rand('seed',55);


% Merge redundant columns...
numSamples = size(data, 1);
numClasses = 7;
mergedData = zeros(numSamples, 17);

for i = 1:numSamples
	% Copy over the initial features...
	for j = 1:14
		mergedData(i, j) = data(i, j);
    end
	
	% Wilderness area merge
	%for j = 11:14
%		if (data(i, j) == 1)
%			mergedData(i, 11) = j - 11;
%			break
%		end
 %   end

	% Soil type merge
    % The values correspond to "climactic zone" and "geologic zone"
    % described in covtype.info
	for j = 15:54
		if (data(i, j) == 1)
			if (j <= 20)
                mergedData(i,15) = 2; 
                mergedData(i,16) = 7;
            elseif (j <= 22)
                mergedData(i,15) = 3; 
                mergedData(i,16) = 5;
            elseif (j <= 23)
                mergedData(i,15) = 4; 
                mergedData(i,16) = 2;
            elseif (j <= 27)
                mergedData(i,15) = 4; 
                mergedData(i,16) = 7;
            elseif (j <= 29)
                mergedData(i,15) = 5; 
                mergedData(i,16) = 1;
            elseif (j <= 31)
                mergedData(i,15) = 6; 
                mergedData(i,16) = 1;
            elseif (j <= 32)
                mergedData(i,15) = 6; 
                mergedData(i,16) = 7;
            elseif (j <= 35)
                mergedData(i,15) = 7; 
                mergedData(i,16) = 1;
            elseif (j <= 37)
                mergedData(i,15) = 7; 
                mergedData(i,16) = 2;
            elseif (j <= 48)
                mergedData(i,15) = 7; 
                mergedData(i,16) = 7;
            elseif (j <= 54)
                mergedData(i,15) = 8; 
                mergedData(i,16) = 7;
            else
                assert(false);
            end
           break;
		end
    end

	% Cover type
	mergedData(i, 17) = data(i, 55);
end

features = mergedData;
features(:,17) = [];
classification = mergedData(:, 17);

%testIdx=15121:1:581012;
%testIdx=testIdx';

%testIdx = testData(:,1);
%testData = mergedTestData;

%features = data;
%features(:,55) = [];
%classification = data(:, 55);

%for getting up to speed, I'm going to trim the dataset to 10% of its
%original size.
%idx = crossvalind('holdout',classification,0.95);

%features=features(idx,:);
%classification=classification(idx,:);

%% end of trimming

[train,test] = crossvalind('holdout',classification,0.25);

% Pull out the training set
xTr = features(train,:)';   
yTr = classification(train,:)';   

% Pull out the test set.  
xTe=features(test,:)';
yTe=classification(test,:)';

data = [];
features = [];
classification = [];

kVal = [1 2 4 6 8 10 12 14 16]';
numKs = size(kVal,1);

for ii=1:numKs
	teErrAllK(ii,1) = kVal(ii,1);       % Let's remember what K is for our result set.
    errRAW=knncl([],xTr, yTr,xTe,yTe,kVal(ii,1));fprintf('\n');
	fprintf('Percentage of test set correctly categorized (basic KNN, k = %d): %f\n', kVal(ii,1), 1-errRAW(2));
	teErrAllK(ii,2) = 1-errRAW(2);
	
	fprintf('Learning initial metric with LMNN ...')
	[L,~] = lmnn2(xTr, yTr, kVal(ii,1), 'maxiter',500, 'validation', 0.05, 'subsample', 0.1);
	errL=knncl(L,xTr, yTr,xTe,yTe,4);fprintf('\n');

	fprintf('Percentage of test set correctly categorized (LMNN, k = %d): %f\n', kVal(ii,1), 1-errL(2));
	teErrAllK(ii,3) = 1-errL(2);
	
end 

%, 'outdim', 7);
%,3,L0,'maxiter',1000,'quiet',1,'outdim',3,'mu',0.5,'validation',0.2,'earlystopping',25,'subsample',0.3);
% KNN classification error after metric learning using LMNN


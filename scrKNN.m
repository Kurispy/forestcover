% Load the data in
projectPath = 'C:\Users\Jesse\Documents\Machine Learning\Project\forestcover';
LMNNPath = strcat(projectPath,'\mLMNN2.5');
addpath(projectPath);
addpath(LMNNPath);
cd(LMNNPath);
run('setpaths.m');
data = load('covtype.data');

% Merge redundant columns...
numSamples = size(data, 1);
numClasses = 7;
mergedData = zeros(numSamples, 14);
%13);
for i = 1:numSamples
	% Copy over the initial features...
	for j = 1:10
		mergedData(i, j) = data(i, j);
    end
	
	% Wilderness area merge
	for j = 11:14
		if (data(i, j) == 1)
			mergedData(i, 11) = j - 11;
			break
		end
    end

	% Soil type merge
    % The values correspond to "climactic zone" and "geologic zone"
    % described in covtype.info
	for j = 15:54
		if (data(i, j) == 1)
			if (j <= 20)
                mergedData(i,12) = 2; 
                mergedData(i,13) = 7;
            elseif (j <= 22)
                mergedData(i,12) = 3; 
                mergedData(i,13) = 5;
            elseif (j <= 23)
                mergedData(i,12) = 4; 
                mergedData(i,13) = 2;
            elseif (j <= 27)
                mergedData(i,12) = 4; 
                mergedData(i,13) = 7;
            elseif (j <= 29)
                mergedData(i,12) = 5; 
                mergedData(i,13) = 1;
            elseif (j <= 31)
                mergedData(i,12) = 6; 
                mergedData(i,13) = 1;
            elseif (j <= 32)
                mergedData(i,12) = 6; 
                mergedData(i,13) = 7;
            elseif (j <= 35)
                mergedData(i,12) = 7; 
                mergedData(i,13) = 1;
            elseif (j <= 37)
                mergedData(i,12) = 7; 
                mergedData(i,13) = 2;
            elseif (j <= 48)
                mergedData(i,12) = 7; 
                mergedData(i,13) = 7;
            elseif (j <= 54)
                mergedData(i,12) = 8; 
                mergedData(i,13) = 7;
            else
                assert(false);
            end
           break;
		end
    end

	% Cover type
	mergedData(i, 14) = data(i, 55);
end


%testIdx=15121:1:581012;
%testIdx=testIdx';

%testIdx = testData(:,1);
%testData = mergedTestData;

features = data;
features(:,55) = [];
classification = data(:, 55);

%for getting up to speed, I'm going to trim the dataset to 10% of its
%original size.
idx = crossvalind('holdout',classification,0.95);

features=features(idx,:);
classification=classification(idx,:);

%% end of trimming

[train,test] = crossvalind('holdout',classification,0.5);

% Pull out the training set
xTr = features(train,:)';   
yTr = classification(train,:)';   

% Pull out the test set.  
xTe=features(test,:)';
yTe=classification(test,:)';

%errRAW=knncl([],xTr, yTr,xTe,yTe,1);fprintf('\n');
%fprintf('\n')
%L0=pca(xTr)';
%errPCA=knncl(L0(1:3,:),xTr, yTr,xTe,yTe,1);fprintf('\n');
%subplot(3,2,1);
%scat(L0*xTr,3,yTr);
%title(['PCA Training (Error: ' num2str(100*errPCA(1),3) '%)'])
%noticks;box on;
%subplot(3,2,2);
%scat(L0*xTe,3,yTe);
%title(['PCA Test (Error: ' num2str(100*errPCA(2),3) '%)'])
%noticks;box on;
%drawnow



labels = doKNNClassification(xTr', yTr', xTe');
success = labels == yTe';

pctCorrect = sum(success) / size(xTe',1);
fprintf('Percentage of test set correctly categorized (basic KNN): %f\n', pctCorrect);

% Call LMNN to get the initiate linear transformation
fprintf('\n')
disp('Learning initial metric with LMNN ...')
[L,~] = lmnn2(xTr, yTr, 'maxiter',500);
%,3,L0,'maxiter',1000,'quiet',1,'outdim',3,'mu',0.5,'validation',0.2,'earlystopping',25,'subsample',0.3);
% KNN classification error after metric learning using LMNN
errL=knncl(L,xTr, yTr,xTe,yTe,1);fprintf('\n');

fprintf('Percentage of test set correctly categorized (LMNN): %f\n', 1-errL(2));

% Plotting LMNN embedding
%subplot(3,2,3);
%scat(L*xTr,3,yTr);
%title(['LMNN Training (Error: ' num2str(100*errL(1),3) '%)'])
%noticks;box on;
%drawnow
%subplot(3,2,4);
%scat(L*xTe,3,yTe);
%title(['LMNN Test (Error: ' num2str(100*errL(2),3) '%)'])
%noticks;box on;
%drawnow

fprintf('\n')
fprintf('Learning nonlinear metric with GB-LMNN ... \n')
embed=gb_lmnn(xTr,yTr,3,L,'ntrees',200,'verbose',true);
%,'XVAL',xVa,'YVAL',yVa);

% KNN classification error after metric learning using gbLMNN
errGL=knncl([],embed(xTr), yTr,embed(xTe),yTe,1);fprintf('\n');
fprintf('Percentage of test set correctly categorized (GB-LMNN): %f\n', 1-errGL(2));
%subplot(3,2,5);
%scat(embed(xTr),3,yTr);
%title(['GB-LMNN Training (Error: ' num2str(100*errGL(1),3) '%)'])
%noticks;box on;
%drawnow
%subplot(3,2,6);
%scat(embed(xTe),3,yTe);
%title(['GB-LMNN Test (Error: ' num2str(100*errGL(2),3) '%)'])
%noticks;box on;
%drawnow
%disp('Dimensionality Reduction Demo:')
%disp(['1-NN Error for raw (high dimensional) input is : ',num2str(100*errRAW(2),3),'%']);
%disp(['1-NN Error after PCA in 3d is : ',num2str(100*errPCA(2),3),'%']);
%disp(['1-NN Error after LMNN in 3d is : ',num2str(100*errL(2),3),'%']);
%disp(['1-NN Error after gbLMNN in 3d is : ',num2str(100*errGL(2),3),'%']);


%
%mdl = fitcknn(features,classification);
%mdl.NumNeighbors = 4;

%[label,score,cost] = predict(mdl,testData);
%predictedCover = zeros(numTestSamples, 2);
%predictedCover(:,1) = testIdx;
%predictedCover(:,2) = label;

%WritePredictionsToFile(predictedCover,'C:\Users\Jesse\Documents\Machine Learning\Project\forestcover\predictions.csv');

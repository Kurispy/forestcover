% Add Deep learning toolbox code
addpath(genpath('DeepLearnToolbox'));

% Add common code
addpath(genpath('common'));

% Load the train data if needed
if (exist('mergedData', 'var') == 0)
	loadTrainData;
end

featureNames = ['Elevation'; 'Aspect'; 'Slope'; 'H Hydrology'; 'V Hydrology'; 'H Roads'; 'Hillshade 9AM'; 'Hillshade 12PM'; 'Hillshade 3PM';
				'H Fire Pts'; 'Wilderness Area'; 'Soil Type'];
featureNames = cellstr(featureNames);

close all;

% Make the histogram / scatter plot matrix
fig = figure('Visible', 'on');
set(gcf,'PaperPositionMode','auto');
set(gcf, 'units', 'pixels', 'position', [0 0 1920 1080]);

count = 1;
numFeatures = size(features, 2);

% Generate colors for our features
colorOrder = jet(numClasses);

for i = 1:numFeatures
	for j = 1:numFeatures
		subplot(numFeatures, numFeatures, count);
		if (i == j) 
			hist(features(:, i));
		else
			hold on
			p = plot(spruce(:, i + 1), spruce(:, j + 1), '.', 'MarkerSize', 5);
			set(p, 'color', colorOrder(1,:));
			p = plot(lodgepolePine(:, i + 1), lodgepolePine(:, j + 1), '.', 'MarkerSize', 5);
			set(p, 'color', colorOrder(2,:));
			p = plot(ponderosaPine(:, i + 1), ponderosaPine(:, j + 1), '.', 'MarkerSize', 5);
			set(p, 'color', colorOrder(3,:));
			p = plot(willow(:, i + 1), willow(:, j + 1), '.', 'MarkerSize', 5);
			set(p, 'color', colorOrder(4,:));
			p = plot(aspen(:, i + 1), aspen(:, j + 1), '.', 'MarkerSize', 5);
			set(p, 'color', colorOrder(5,:));
			p = plot(douglas(:, i + 1), douglas(:, j + 1), '.', 'MarkerSize', 5);
			set(p, 'color', colorOrder(6,:));
			p = plot(krummholz(:, i + 1), krummholz(:, j + 1), '.', 'MarkerSize', 5);
			set(p, 'color', colorOrder(7,:));
			hold off
		endif

		set(gca,'XTickLabel',[],'XTick',[]);
    	set(gca,'YTickLabel',[],'YTick',[]);

		if (j == 1)
			ylabel(featureNames(i), 'FontSize', 7);
		endif

		if (i == numFeatures) 
			xlabel(featureNames(j), 'FontSize', 7);
		endif
		if (i == 1) 
			title(featureNames(j), 'FontSize', 7);
		endif

		count = count + 1;
	endfor
endfor

print('featureScatterPlotMatrix', '-dpng');
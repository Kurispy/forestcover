% Add Deep learning toolbox code
addpath(genpath('DeepLearnToolbox'));

% Add common code
addpath(genpath('common'));

% Load the train data if needed
if (exist('mergedData', 'var') == 0)
	loadData;
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
features = mergedData(:, 1:12);
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
			p = plot(spruce(:, i), spruce(:, j), '.', 'MarkerSize', 5);
			set(p, 'color', colorOrder(1,:));
			p = plot(lodgepolePine(:, i), lodgepolePine(:, j), '.', 'MarkerSize', 5);
			set(p, 'color', colorOrder(2,:));
			p = plot(ponderosaPine(:, i), ponderosaPine(:, j), '.', 'MarkerSize', 5);
			set(p, 'color', colorOrder(3,:));
			p = plot(willow(:, i), willow(:, j), '.', 'MarkerSize', 5);
			set(p, 'color', colorOrder(4,:));
			p = plot(aspen(:, i), aspen(:, j), '.', 'MarkerSize', 5);
			set(p, 'color', colorOrder(5,:));
			p = plot(douglas(:, i), douglas(:, j), '.', 'MarkerSize', 5);
			set(p, 'color', colorOrder(6,:));
			p = plot(krummholz(:, i), krummholz(:, j), '.', 'MarkerSize', 5);
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
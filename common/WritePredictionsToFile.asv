function [ Err ] = WritePredictionsToFile( mPredictions, sFileName )
% Write the results to a CSV formatted for submission to Kaggle.
% Each row of mPredictions should contain Id, Cover_Type

[fileID,Err] = fopen(sFileName, 'wt');

if (fileID ~= -1)
    fprintf(fileID, 'Id,Cover_Type\n');
    formatSpec = '%d,%d\n';
    nrows = size(mPredictions,1);
    for row = 1:nrows
        fprintf(fileID,formatSpec,mPredictions(row,:));
    end
end
fclose(fileID);
end


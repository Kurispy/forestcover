function [predictions] = doKNNClassification(features, classification, testData)

    mdl = fitcknn(features,classification);
    mdl.NumNeighbors = 4;

    [predictions,score,cost] = predict(mdl,testData);

end
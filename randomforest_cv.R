library(randomForest)

# K-Fold Cross Validation
randomforestcv <- function(k) {
  rawdata <- read.csv("./covtype.data", header = F)
  
  cols = names(rawdata)[2:54]
  response <- names(rawdata)[55]
  
  foldSize = floor(nrow(rawdata)/k)
  
  for(i in 1:k) {
    startIndex = (i - 1) * (foldSize+1)
    endIndex = i * foldSize
    range = startIndex:endIndex
    
    train <- rawdata[-range,]
    test <- rawdata[range,]
    
    clf <- randomForest(train[,cols], y = factor(train[,response]))
    
    prediction = predict(clf, newdata = test[,response], type="prob")[,2]
    
    # auc = roc.area(test[,1], prediction)$A
    # print("AUC = ", auc)
  }
}
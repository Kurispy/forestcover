library(randomForest)

# K-Fold Cross Validation
randomforestcv <- function(k) {
  #k = 10
  rawdata <- read.csv("./covtype.data", header = F)
  
  s = nrow(rawdata)
  wilderness_area = rep(0,s)
  soil_type = rep(0,s)
  
  #Merge Columns
  for (i in 11:14){
    wilderness_area = ifelse(rawdata[,i] == 1, i-10, wilderness_area)
  }
  
  for (i in 15:54){
    soil_type = ifelse(rawdata[,i] == 1, i-14, soil_type)
  }
  
  data = cbind(rawdata[,1:10],wilderness_area,soil_type,rawdata[,55])
  
  cols = names(data)[1:12]
  response <- names(data)[13]
  
  foldSize = floor(s/k)
  
  for(i in 1:1) {
    startIndex = (i - 1) * (foldSize+1)
    endIndex = i * foldSize
    range = startIndex:endIndex
    
    train <- data[-range,]
    test <- data[range,]
    
    clf <- randomForest(x = train[,cols], y = factor(train[,response]), xtest = test[,cols], ytest = factor(test[,response]), mtry = 4, ntree = 40)
    
    testans <- clf$test
    
    predictions <- testans$predicted
    
    #Calculate Classification Accuracy
    classifications <- ifelse(predictions == factor(test[,response]), 1, 0)
    accuracy <- mean(classifications)
    
    cat("Classification Accuracy: ")
    cat(accuracy)
    
    plot(clf)
    #return(clf)
    # auc = roc.area(test[,1], prediction)$A
    # print("AUC = ", auc)
  }
}
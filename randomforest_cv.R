library(randomForest)

# K-Fold Cross Validation
randomforestcv <- function(k) {
  OOB <- rep(0,12)
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
  
  for(i in 1:12) {
    
    range = sample(1:s, 2*foldSize, replace = FALSE) #pick random samples from data
    
    train <- data[range,]
    test <- data[-range,]
    
    clf <- randomForest(x = train[,cols], y = factor(train[,response]), xtest = test[,cols], ytest = factor(test[,response]), mtry = i, ntree = 40)
    
    testans <- clf$test
    
    err <- clf$err.rate
    
    predictions <- testans$predicted
    
    OOB[i] <- err[clf$ntree,"OOB"]
    
    #Calculate Classification Accuracy
    classifications <- ifelse(predictions == factor(test[,response]), 1, 0)
    accuracy <- mean(classifications)
    
    #cat("mtry: ", i, "\n")
    #cat("Classification Accuracy: ", accuracy, clf$test$err.rate[clf$ntree, "Test"], "\n")
    #cat(colnames(err), "\n")
    #cat("OOB err rate: ", err[40,1], "\n")
    
    #print(clf)
    
    #plot(clf)
    rm(list = c("clf","train","test","testans","classifications","accuracy", "err"))   
    #return(clf)
    # auc = roc.area(test[,1], prediction)$A
    # print("AUC = ", auc)
  }
  plot(1:12, OOB, type = 'b', xlab = "mtry")
}
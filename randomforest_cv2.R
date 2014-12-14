library(randomForest)

# mtry vs. OOB
randomforestcv <- function(k) {
  OOB <- rep(0,12)
  Test <- rep(0,12)
  imp_OOB <- rep(0,12)
  imp_Test <- rep(0,12)
  
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
    
    clf <- randomForest(x = train[,cols], y = factor(train[,response]), xtest = test[,cols], ytest = factor(test[,response]), mtry = i, ntree = 50, importance = TRUE)
    
    testans <- clf$test
    
    err <- clf$err.rate
    test_err <- clf$test$err.rate
    
    predictions <- testans$predicted
    
    importance <- round(importance(clf, type = 1), 2)
    
    OOB[i] <- err[clf$ntree,"OOB"]
    Test[i] <- test_err[clf$ntree,"Test"]
    
    ord <- order(importance[,1], decreasing = FALSE)
    a = 3
    impcols <- ord[-(1:a)] #changing this will affect how many variables to excluse from the second run
    cat("Run 2 excluded ", a, " variable(s)")
    impclf <- randomForest(x = train[,impcols], 
                           y = factor(train[,response]),
                           xtest = test[,impcols],
                           ytest = factor(test[,response]),
                           mtry = 7,
                           ntree = 50,
                           importance = TRUE,
                           keep.forest = TRUE)
    
    imp_err <- impclf$err.rate
    imp_test_err <- impclf$test$err.rate
    
    imp_OOB[i] <- imp_err[impclf$ntree,"OOB"]
    imp_Test[i] <- imp_test_err[impclf$ntree,"Test"]
    
  }
  plot(1:12, OOB, type = 'b', xlab = "mtry", main = "No. of variables sampled at each split vs. OOB error rate")
  
  # No variables excluded
  matplot(1:12, cbind(OOB, Test), type="l", xlab = "mtry", ylab = "Error", main = "No. of variables sampled vs Error - No Variable Exclusion")
  legend("topright", legend = c("OOB", "Test Error"), lty = c(1,1), lwd = c(2.5,2.5), col = 1:2)
  
  # With variables excluded
  matplot(1:12, cbind(imp_OOB, imp_Test), type="l", xlab = "mtry", ylab = "Error", main = "No. of variables sampled vs Error - With 3 Lowest Importance Variable Exclusion")
  legend("topright", legend = c("OOB", "Test Error"), lty = c(1,1), lwd = c(2.5,2.5), col = 1:2)
}
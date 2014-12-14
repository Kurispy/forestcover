#Summary
#arguments:
# k     the number of folds the data has
# end   the number of trees to use in the forest
# auc   Set to TRUE (default FALSE) to calculate multiclass AUC using methods in Hand and Till (2001)
# roc   Set to TRUE (default FALSE) to get ROC curves
# add   Set to FALSE to get seperate curves for all one vs all ROC curves

library(randomForest)
library(pROC)
library(ROCR)

# Trees vs Error
randomforesttt <- function(k = 10,end = 40, auc = FALSE, roc = FALSE, add = TRUE) { 
  #k = 10
  #end = 40
  #roc = TRUE
  #auc = FALSE
  #add = TRUE
  rawdata <- read.csv("./covtype.data", header = F)
  
  s = nrow(rawdata)
  wilderness_area = rep(0,s)
  soil_type = rep(0,s)
  
  #Merge Columns###
  for (i in 11:14){
    wilderness_area = ifelse(rawdata[,i] == 1, i-10, wilderness_area)
  }
  
  for (i in 15:54){
    soil_type = ifelse(rawdata[,i] == 1, i-14, soil_type)
  }
  
  data = cbind(rawdata[,1:10],wilderness_area,soil_type,rawdata[,55])
  
  cols = names(data)[1:12]
  response <- names(data)[13]
  #########################
  
  ##sample data##
  foldSize = floor(s/k)
  
  range = sample(1:s, foldSize, replace = FALSE) #pick random samples from data
  
  train <- data[-range,]
  test <- data[range,]
  
  ##################
  
  clf <- randomForest(x = train[,cols], y = factor(train[,response]), xtest = test[,cols], ytest = factor(test[,response]), mtry = 7, ntree = end)
  
  print(clf$test$confusion)
  
  testans <- clf$test
  
  err <- clf$err.rate
  
  predictions <- testans$predicted
  
  votes <- testans$votes

  testmat <- cbind(clf$err.rate[,"OOB"], clf$test$err.rate[,"Test"])

  matplot(1:clf$ntree, testmat, type = "l", xlab = "Trees", ylab = "Error", col = 1:2, main = "No. of trees vs. Error rates")
  legend("topright", legend = c("OOB", "Test"), lty = c(1,1), lwd = c(2.5,2.5), col = 1:2)
  
  if(auc){
    multiclass.roc(test[,response],as.numeric(levels(predictions)[predictions]))
  }
  
  if(roc){
    
    titles <- c("Spruce", "Lodgepole", "Ponderosa", "Cottonwood", "Aspen", "Douglas", "Krummholz")
    
    if(add){
      resp <- ifelse(test[,response] == 1, 1, 0)
      predobj <- prediction(votes[,1],resp)
      perfobj <- performance(predobj, measure = "tpr", x.measure = "fpr")
      auc <- (performance(predobj, measure = "auc"))@y.values
      plot(perfobj, col = 1, main = "ROC curves" )
      print(sprintf("AUC of %s is: %f", titles[1], auc[1]))
      for(i in 2:7){
        resp <- ifelse(test[,response] == i, 1, 0)
        #pred <- ifelse(predictions == i, 1, 0)
        predobj <- prediction(votes[,i],resp)
        perfobj <- performance(predobj, measure = "tpr", x.measure = "fpr")
        auc <- c(auc,(performance(predobj, measure = "auc"))@y.values)
        plot(perfobj, col = i, add = TRUE)
        print(sprintf("AUC of %s is: %f", titles[i], auc[i]))
      }
      legend("topright", legend = titles, lty = c(1,1), lwd = c(2.5,2.5), col = 1:7)
    }
    else{
      resp <- ifelse(test[,response] == 1, 1, 0)
      predobj <- prediction(votes[,1],resp)
      perfobj <- performance(predobj, measure = "tpr", x.measure = "fpr")
      auc <- (performance(predobj, measure = "auc"))@y.values
      plot(perfobj, main = sprintf("ROC curve for %s", titles[1]))
      print(sprintf("AUC of %s is: %f", titles[1], auc[1]))
      for(i in 2:7){
        resp <- ifelse(test[,response] == i, 1, 0)
        #pred <- ifelse(predictions == i, 1, 0)
        predobj <- prediction(votes[,i],resp)
        perfobj <- performance(predobj, measure = "tpr", x.measure = "fpr")
        auc <- c(auc,(performance(predobj, measure = "auc"))@y.values)
        plot(perfobj, main = sprintf("ROC curve for %s", titles[i]))
        print(sprintf("AUC of %s is: %f", titles[i], auc[i]))
      }
    }
  }
}
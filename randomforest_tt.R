library(randomForest)

# Trees vs Error
randomforesttt <- function(k,end = 40) {
  
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
  
  range = sample(1:s, 2*foldSize, replace = FALSE) #pick random samples from data
  
  train <- data[range,]
  test <- data[-range,]
  
  ##################
  
  clf <- randomForest(x = train[,cols], y = factor(train[,response]), xtest = test[,cols], ytest = factor(test[,response]), mtry = 7, ntree = end)
  
  testans <- clf$test
  
  err <- clf$err.rate
  
  predictions <- testans$predicted

  testmat <- cbind(clf$err.rate[,"OOB"], clf$test$err.rate[,"Test"])

  matplot(1:clf$ntree, testmat, type = "l", xlab = "Trees", ylab = "Error", col = 1:2, main = "No. of trees vs. Error rates")
  legend("topright", legend = c("OOB", "Test"), lty = c(1,1), lwd = c(2.5,2.5), col = 1:2)

}
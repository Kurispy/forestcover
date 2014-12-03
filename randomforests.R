library(randomForest)

randomforestclf <- function(){
  train <- read.csv("./train.csv", header = F)
  test <- read.csv("./test.csv", header = T)
  
  train <- train[,-1]
  test <- test[,-1]
  
  names(train)[1:54] <- names(test)
  names(train)[55] <- "Cover_Type"
  
  cols <- names(train)[1:54]
  response <- names(train)[55]
  
  system.time(clf <- randomForest(train[,cols], y = factor(train[,response])))
  
  plot(clf)
  
  ans <- predict(clf,test)
}

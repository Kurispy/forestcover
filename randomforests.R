library(randomForest)

randomforestclf <- function(){
  train <- read.csv("./train.csv", header = F)
  test <- read.csv("./test.csv", header = T)
  
  names(train)[1:55] <- names(test)
  names(train)[56] <- "Cover_Type"
  
  cols <- names(train)[2:55]
  response <- names(train)[56]
  
  clf <- randomForest(train[,cols], y = factor(train[,response]))
  
  plot(clf)
  
  ans <- predict(clf,test)
  
  #preparing the data for kaggle submission 
  fa <- as.numeric(levels(ans)[ans])
  write.csv(fa, file = "sub.csv", row.names = test[,1]) #Still need to open this file in excel and change column to Id and Cover_Type according to the instructions.
}

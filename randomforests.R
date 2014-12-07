library(randomForest)

# Variable Importance Test
randomforest <- function(k,end = 40) {
  
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
  
  colnames(data)[1:12] <- c("Elevation","Aspect", 'Slope', 'Hori_Dist_Hydro','Vert_Dist_Hydro','Hori_Dist_Road','Hillshade9am','Hillshadenoon','Hillshade3pm','Hori_Dist_Fire', 'Wilderness_Area','Soil_Type')
  
  cols = names(data)[1:12]
  response <- names(data)[13]
  #########################
  
  ##sample data##
  foldSize = floor(s/k)
  
  range = sample(1:s, 2*foldSize, replace = FALSE) #pick random samples from data
  
  train <- data[range,]
  test <- data[-range,]
  
  ##################
  
  clf <- randomForest(x = train[,cols], 
                      y = factor(train[,response]),
                      xtest = test[,cols],
                      ytest = factor(test[,response]),
                      mtry = 7,
                      ntree = end,
                      importance = TRUE,
                      keep.forest = TRUE)
  
  
  
  testans <- clf$test
  
  err <- clf$err.rate
  
  predictions <- testans$predicted
  
  imp <- round(importance(clf, type = 1), 2)
  
  varImpPlot(clf,type = 1, main="Variable importance plot")
  
  ord <- order(imp[,1], decreasing = FALSE)
  
  a = 1
  
  impcols <- ord[-(1:a)] #changing this will affect how many variables to excluse from the second run
  
  cat("Run 2 excluded ", a, " variable(s)")
  
  impclf <- randomForest(x = train[,impcols], 
                         y = factor(train[,response]),
                         xtest = test[,impcols],
                         ytest = factor(test[,response]),
                         mtry = 7,
                         ntree = end,
                         importance = TRUE,
                         keep.forest = TRUE)
  
  testmat <- cbind(clf$test$err.rate[, "Test"], impclf$test$err.rate[, "Test"])
  matplot(1:clf$ntree, testmat, type = "l", xlab = "Trees", ylab = "Error", col = 1:2, main = "Effect of removing variables with the least MeanDecreaseAccuracy")
  legend("topright", legend = c("Run 1", "Run 2"), lty = c(1,1), lwd = c(2.5,2.5), col = 1:2)

}
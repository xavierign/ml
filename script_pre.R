### 1. libraries ----
rm(list = ls()); gc();
library(dummies)
library(xgboost)

### 2. load the data ----
data <- read.csv2('data.csv',sep="," )
quiz <- read.csv2('quiz.csv',sep="," )

data_pre <- read.csv2('data_pre.csv',sep="," )
quiz_pre <- read.csv2('quiz_pre.csv',sep="," )

#### 3. fit xgboost ---- 
data.xg <- data.matrix(data_pre[,c(1:34, 36:ncol(data_pre))])
label.xg <- data.matrix(data_pre[,35])
quiz.xg <- data.matrix(quiz_pre)

#to double
storage.mode(data.xg) <- "double" 
storage.mode(label.xg) <- "double"
storage.mode(quiz.xg) <- "double"

label.xg[label.xg<0] <- 0

rec <- sample(c(1,2,3),ncol(data.xg), prob=c(0.5,0.25,0.25),replace = T)
train.rec <- rec==1
test.rec <- rec==2
val.rec <- rec==3

dtrain <- xgb.DMatrix(data.xg[train.rec,], label= label.xg[train.rec,])
dtest <- xgb.DMatrix(data.xg[test.rec,], label= label.xg[test.rec,])
dval <- xgb.DMatrix(data.xg[val.rec,], label= label.xg[val.rec,])
nr <- 1500
nt <- 5
obj= 'binary:logistic'
fit.xg <- xgb.train(#booster which booster to use, can be gbtree or gblinear
                       params = list(
                               #eval_metric="auc",
                               objective= obj),
                       data = dtrain, 
                       nrounds=nr, 
                       nthread = nt,
                       watchlist = list(eval = dval, train = dtrain), 
                       #obj = NULL,
                         #feval = NULL, 
                         verbose = 2, print.every.n = 1L,
                      early.stop.round = NULL, maximize = NULL)

pred.xg <- predict(fit.xg, dtest)
labels <- label.xg[test.rec]

mean(as.numeric(pred.xg>0.5)==label.xg[test.rec])


cn <- colnames(data)

for( i in cn){
  print(i)
  print(unique(quiz[,i]) %in%  unique(data[,i]) )
}

### 3. pre-treatment
#x0 create dummies
x0.dum <- dummy(data$X0, sep=".")
data <- cbind.data.frame(data,x0.dum)
data$X0 <- NULL

#x5 create dummies
x5.dum <- dummy(data$X5, sep=".")
data <- cbind.data.frame(data,x5.dum)
data$X5 <- NULL

#x8 create dummies
x8.dum <- dummy(data$X8, sep=".")
data <- cbind.data.frame(data,x8.dum)
data$X8 <- NULL

#x9 create dummies
x9.dum <- dummy(data$X9, sep=".")
data <- cbind.data.frame(data,x9.dum)
data$X9 <- NULL

#x14 create dummies
x14.dum <- dummy(data$X14, sep=".")
data <- cbind.data.frame(data,x14.dum)
data$X14 <- NULL

#x17 create dummies
x17.dum <- dummy(data$X17, sep=".")
data <- cbind.data.frame(data,x17.dum)
data$X17 <- NULL

#x18 create dummies
x18.dum <- dummy(data$X18, sep=".")
data <- cbind.data.frame(data,x18.dum)
data$X18 <- NULL

#x20 create dummies
x20.dum <- dummy(data$X20, sep=".")
data <- cbind.data.frame(data,x20.dum)
data$X20 <- NULL

#x23 create dummies
x23.dum <- dummy(data$X23, sep=".")
data <- cbind.data.frame(data,x23.dum)
data$X23 <- NULL

#x25 create dummies
x25.dum <- dummy(data$X25, sep=".")
data <- cbind.data.frame(data,x25.dum)
data$X25 <- NULL

#x26 create dummies
x26.dum <- dummy(data$X26, sep=".")
data <- cbind.data.frame(data,x26.dum)
data$X26 <- NULL
#x2 as numeric
data$X2 <- as.numeric(data$X2)



unique(quiz$X23) %in%  unique(data$X23) 

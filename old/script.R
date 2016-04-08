#### X. Clear data and libraries ----
library(data.table)
library(xgboost)
rm(list=ls())
setwd("~/Documents/Kaggle/ML")

#### X. Load the data ----
data.load <- fread('data.csv')
test.load <- fread('quiz.csv')

#### X. separate in train and test ----
data.xg <- as.matrix(data.load[,1:18,with=F])
label.xg <- as.matrix(data.load[,19,with=F])
quiz.xg <- as.matrix(test.load)

storage.mode(data.xg) <- 'double' 
storage.mode(quiz.xg) <- 'double' 

label.xg[label.xg==-1,1]=0

rate = 0.3
train.rec <- sample(c(T,F),ncol(data.xg), prob=c(rate,1-rate),replace = T)
#train.rec <- 1:4000000

dtrain <- xgb.DMatrix(data.xg[train.rec,], label= label.xg[train.rec,])

dval <- dtrain
  #
dtest <- xgb.DMatrix(data.xg[!train.rec,], label= label.xg[!train.rec,])

#### X. fit the model ----
nr <- 200
nt <- 5
obj= 'binary:logistic'

fit.xg <- xgb.train(
                    #booster which booster to use, can be gbtree or gblinear
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

#### X. cross validation ----
#fit.xg <- xgb.cv(data = data.xg, label = label.xg, missing = NULL,
#                 objective= 'binary:logistic', nthread = 2, 
#                 nrounds=20, nfold=5,  metrics = list("auc"))

#### X. predict ----
pred.xg <- predict(fit.xg, dtest)
# convert to score
pred.xg <- log(pred.xg/(1-pred.xg))

#### X. write the file
res <- data.frame( Id = 1:nrow(test.load), Prediction = pred.xg)

outfile1 <- paste("rate",rate,"_nr",nr,"obj",obj,".csv",sep="",collapse="")
write.csv (res, outfile1,quote = F, row.names=F)

#Opgave 1
#1a
load(file="Andersen.RData")

#1b
set.seed(42)
Andersen$training = rbinom(dim(Andersen)[1],1,0.7)
linreg <- lm(fruits ~ age+factor(sex), data = subset(Andersen,training==1))
summary(linreg)

#1c
new_Andersen <- data.frame(age=50,sex=1)
cbind(new_Andersen,predict(linreg, newdata = new_Andersen, interval = "predict"))

#1d
Andersen2 = cbind(Andersen,predict(linreg, newdata = Andersen, interval = "predict"))
plot(subset(Andersen2,training==0)$fruits,subset(Andersen2,training==0)$fit)
abline(0,1)
cor(subset(Andersen2,training==0)$fruits,subset(Andersen2,training==0)$fit)
#Det ser ret dårligt ud, hvilket skylder at alder betyder næsten ingenting.
#Så basalt set kommer alle mænd i en gruppe omkring 210 og alle kvinde i en gruppe omkring 300

#Opgave 2
#2a
load(file="Andersen.RData")

#2b
set.seed(42)
Andersen$training = rbinom(dim(Andersen)[1],1,0.7)
linreg <- lm(fruits ~ age+factor(sex)+factor(ecological), data = subset(Andersen,training==1))
summary(linreg)

#2c
new_Andersen <- data.frame(age=c(35,35),sex=c(2,2),ecological=c(1,0))
cbind(new_Andersen,predict(linreg, newdata = new_Andersen, interval = "predict"))

#2d
Andersen2 = cbind(Andersen,predict(linreg, newdata = Andersen, interval = "predict"))
plot(subset(Andersen2,training==0)$fruits,subset(Andersen2,training==0)$fit)
abline(0,1)
cor(subset(Andersen2,training==0)$fruits,subset(Andersen2,training==0)$fit)
#Stadig ikke overbevisende (men måske lidt bedre end i opgave 1)


#Opgave 3
#3a
load(file="Nielsen.RData")

#3b
set.seed(42)
Nielsen$training = rbinom(dim(Nielsen)[1],1,0.7)
logreg <- glm(factor(case) ~ age+factor(sex)+factor(tatoo), data = subset(Nielsen,training==1), family = "binomial")
summary(logreg)

#3c
library(pROC)
Nielsen2 = cbind(Nielsen,response=predict(logreg, Nielsen, type="response"))
roc <- roc(subset(Nielsen2$case,Nielsen2$training==0),subset(Nielsen2$response,Nielsen2$training==0))
roc
plot(1-roc$specificities,roc$sensitivities,type="l")
#Kurven er næsten diagonal og AUC=0.5129, så modellen er ikke for alvor bedre end at gætte

#3d
cutoff = 0.25
Nielsen2$highrisk = ifelse(Nielsen2$response>=cutoff,1,0)
table(Nielsen2$case,Nielsen2$highrisk)
library(caret)
sensitivity(factor(Nielsen2$highrisk), factor(Nielsen2$case))
specificity(factor(Nielsen2$highrisk), factor(Nielsen2$case))




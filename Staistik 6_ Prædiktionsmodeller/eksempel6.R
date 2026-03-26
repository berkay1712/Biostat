library(readr)
bmi <- read_csv("bmi.csv")
bmi$BMI = bmi$Weight/(bmi$Height/100)^2

linreg <- lm(BMI ~ Weight+factor(Gender), data=bmi)
summary(linreg)

new_bmi <- data.frame(Weight=c(80,75),Gender=c("Male","Female"))
new_bmi

cbind(new_bmi,predict(linreg, newdata = new_bmi, interval = "confidence"))
cbind(new_bmi,predict(linreg, newdata = new_bmi, interval = "predict"))

set.seed(42)
bmi$training = rbinom(dim(bmi)[1],1,0.7)
head(bmi)
linreg <- lm(BMI ~ Weight+factor(Gender), data=subset(bmi,training==1))
summary(linreg)
bmi2 = cbind(bmi,predict(linreg, newdata = bmi, interval = "predict"))
head(bmi2)

plot(subset(bmi2,training==1)$BMI,subset(bmi2,training==1)$fit)
abline(0,1)
cor(subset(bmi2,training==1)$BMI,subset(bmi2,training==1)$fit)

plot(subset(bmi2,training==0)$BMI,subset(bmi2,training==0)$fit)
abline(0,1)
cor(subset(bmi2,training==0)$BMI,subset(bmi2,training==0)$fit)




library(readr)
diabetes <- read_csv("diabetes.csv")
logreg <- glm(factor(Outcome) ~ Glucose+BMI, data = diabetes, family = "binomial")
summary(logreg)

diabetes_new <- data.frame(BMI=c(20,28),Glucose=c(90, 170))
diabetes_new

cbind(diabetes_new,response=predict(logreg, diabetes_new, type="response"))

diabetes2 = cbind(diabetes,response=predict(logreg, diabetes, type="response"))
cutoff = 0.20
diabetes2$highrisk = ifelse(diabetes2$response>=cutoff,1,0)
head(diabetes2[,c("Glucose","BMI","Outcome","response","highrisk")])
table(diabetes2$Outcome,diabetes2$highrisk)

#install.packages("caret")
library(caret)
sensitivity(factor(diabetes2$highrisk), factor(diabetes2$Outcome))
specificity(factor(diabetes2$highrisk), factor(diabetes2$Outcome))
posPredValue(factor(diabetes2$highrisk), factor(diabetes2$Outcome))
negPredValue(factor(diabetes2$highrisk), factor(diabetes2$Outcome))

library(pROC)
roc <- roc(diabetes2$Outcome,diabetes2$response)
roc
plot(1-roc$specificities,roc$sensitivities,type="l")







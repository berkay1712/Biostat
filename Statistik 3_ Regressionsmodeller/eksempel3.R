library(readr)
bmi <- read_csv("bmi.csv")
bmi$BMI = bmi$Weight/(bmi$Height/100)^2

linreg <- lm(Weight ~ Height, data=bmi)
linreg
coef(linreg)
summary(linreg)
confint(linreg)

pdf("linreg_Weight_Height.pdf")
plot(Weight ~ Height, data=bmi)
abline(linreg)
dev.off()

linreg <- lm(BMI ~ Weight, data=bmi)
linreg
coef(linreg)
summary(linreg)
confint(linreg)

pdf("linreg_BMI_Weight.pdf")
plot(BMI ~ Weight, data=bmi)
abline(linreg)
dev.off()

linreg <- lm(Weight ~ Height+factor(Gender), data=bmi)
linreg
coef(linreg)
summary(linreg)
confint(linreg)



library(readr)
diabetes <- read_csv("diabetes.csv")

logreg <- glm(factor(Outcome) ~ Glucose, data = diabetes, family = "binomial")
summary(logreg)
exp(coef(logreg))
exp(confint(logreg))

#install.packages("logbin")
library(logbin)
logbinreg <- logbin(factor(Outcome) ~ Glucose, data = diabetes, method = "em")
summary(logbinreg)
exp(coef(logbinreg))
exp(confint(logbinreg))


library(readr)
breastcancer <- read_csv("breastcancer.csv")
breastcancer = subset(breastcancer,!is.na(Incidence))
breastcancer$State = relevel(factor(breastcancer$Country),ref="California")
modeltr <- glm(Incidence ~ State, family = poisson, offset = log(Population), data = breastcancer)
exp(coef(modeltr))
summary(modeltr)
exp(confint(modeltr))



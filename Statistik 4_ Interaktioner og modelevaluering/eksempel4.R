library(readr)
bmi <- read_csv("bmi.csv")
bmi$BMI = bmi$Weight/(bmi$Height/100)^2
bmi$BMI2 = bmi$BMI+ifelse(bmi$Gender=="Male",bmi$Weight*0.1,0)


#install.packages("interactions")
library(interactions)
linreg <- lm(BMI ~ Weight*factor(Gender), data=bmi)
summary(linreg)
confint(linreg)
interact_plot(linreg, pred = Weight, modx = Gender, plot.points = TRUE)

linreg <- lm(BMI2 ~ Weight*factor(Gender), data=bmi)
summary(linreg)
confint(linreg)
interact_plot(linreg, pred = Weight, modx = Gender, plot.points = TRUE)

linreg <- lm(BMI2 ~ Weight:factor(Gender)+factor(Gender), data=bmi)
summary(linreg)
confint(linreg)



library(haven)
forkoelelse <- read_dta("forkoelelse.dta")
save(forkoelelse,file="forkoelelse.RData")

load(file="forkoelelse.RData")
logreg <- glm(factor(forkoelet_foraeldre) ~ factor(institution) + factor(samboende) + alder, data = forkoelelse, family = "binomial")
summary(logreg)
exp(coef(logreg))
exp(confint(logreg))

logreg <- glm(factor(forkoelet_foraeldre) ~ factor(institution)*factor(samboende) + alder, data = forkoelelse, family = "binomial")
summary(logreg)
exp(coef(logreg))
exp(confint(logreg))

logreg <- glm(factor(forkoelet_foraeldre) ~ factor(institution):factor(samboende) + factor(samboende) + alder, data = forkoelelse, family = "binomial")
summary(logreg)
exp(coef(logreg))
exp(confint(logreg))



linreg <- lm(BMI ~ Weight*factor(Gender), data=bmi)
par(mfrow = c(2, 2))
plot(linreg)


linreg <- lm(BMI2 ~ Weight*factor(Gender), data=bmi)
par(mfrow = c(2, 2))
plot(linreg)




library("performance")
logreg <- glm(factor(forkoelet_foraeldre) ~ factor(institution) + factor(samboende) + alder, data = forkoelelse, family = "binomial")
performance_hosmer(logreg, n_bins = 10)

logreg <- glm(factor(forkoelet_foraeldre) ~ factor(institution)*factor(samboende) + alder, data = forkoelelse, family = "binomial")
performance_hosmer(logreg, n_bins = 10)

logreg <- glm(factor(forkoelet_foraeldre) ~ factor(institution) + factor(samboende) + alder, data = forkoelelse, family = "binomial")
par(mfrow = c(2, 2))
plot(logreg)


library(readr)
breastcancer <- read_csv("breastcancer.csv")
breastcancer = subset(breastcancer,!is.na(Incidence))
breastcancer$State = relevel(factor(breastcancer$Country),ref="California")
modeltr <- glm(Incidence ~ State, family = poisson, offset = log(Population), data = breastcancer)
summary(modeltr)
library(AER)
dispersiontest(modeltr)

library(MASS)
modeltr2 <- glm.nb(Incidence ~ State+ offset(log(breastcancer$Population)), data = breastcancer,init.theta=1)
summary(modeltr2)


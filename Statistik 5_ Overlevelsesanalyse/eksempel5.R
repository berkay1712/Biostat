#library(haven)
#drugtr <- read_dta("drugtr.dta")
#save(drugtr,file="drugtr.RData")

load(file="drugtr.RData")
head(drugtr)

library(survival)
km <- survfit(Surv(studytime, died) ~ 1, data=drugtr)
km
#install.packages("ggfortify")
library(ggfortify)
autoplot(km)


km <- survfit(Surv(studytime, died) ~ factor(drug), data=drugtr)
km
autoplot(km)

survdiff(Surv(studytime, died) ~ factor(drug), data=drugtr)


cox <- coxph(Surv(studytime, died) ~ factor(drug), data = drugtr)
summary(cox)
exp(coef(cox))
exp(confint(cox))
cox.zph(cox, transform="km")

cox <- coxph(Surv(studytime, died) ~ factor(drug)+age, data = drugtr)
summary(cox)
exp(coef(cox))
exp(confint(cox))
cox.zph(cox, transform="km")





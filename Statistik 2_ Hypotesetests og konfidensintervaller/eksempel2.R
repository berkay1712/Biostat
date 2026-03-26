#library(haven)
#runningtimes <- read_dta("C:/Users/moeller/OneDrive - Syddansk Universitet/Undervisning/Medicin Biostatistik og epidemiologi E2025/1. uge/runningtimes.dta")
#save(runningtimes,file="runningtimes.RData")

#coffee <- read_dta("C:/Users/moeller/OneDrive - Syddansk Universitet/Undervisning/Medicin Biostatistik og epidemiologi E2025/1. uge/coffee_ny.dta")
#save(coffee,file="coffee.RData")

load(file="runningtimes.RData")
t.test(subset(runningtimes,Sex==0)$time2015)

#install.packages("PropCIs")
library(PropCIs)
exactci(length(subset(coffee,coffee==1)$coffee),length(coffee$coffee)
        ,conf.level=0.95)
scoreci(length(subset(coffee,coffee==1)$coffee),length(coffee$coffee)
        ,conf.level=0.95)
#install.packages("fastR2")
library(fastR2)
wald.ci(length(subset(coffee,coffee==1)$coffee),length(coffee$coffee)
        ,conf.level=0.95)
wilson.ci(length(subset(coffee,coffee==1)$coffee),length(coffee$coffee)
          ,conf.level=0.95)


res <- data.frame(estimat=c(), nede=c(),oppe=c())
N <- 100
set.seed(24)
for (i in 1:10000){
  x = rnorm(N,10,1)
  ttest = t.test(x~1)
  res = rbind(res,data.frame(estimat=ttest$estimate,
                             nede=ttest$conf.int[1],oppe=ttest$conf.int[2]))
}
count(10>=res$nede & 10<=res$oppe)
#Dette vil altid være opfyldt:
count(res$estimat>=res$nede & res$estimat<=res$oppe)

set.seed(24)
x = rnorm(100,10,1)
ttest = t.test(x~1)
ttest
ttest$conf.int[2]-ttest$conf.int[1]
x = rnorm(400,10,1)
ttest = t.test(x~1)
ttest
ttest$conf.int[2]-ttest$conf.int[1]
x = rnorm(1600,10,1)
ttest = t.test(x~1)
ttest
ttest$conf.int[2]-ttest$conf.int[1]

#install.packages("boot")
library(boot)
funk <- function(data, indices)
{
  d <- data[indices]
  return(mean(d))
}
load(file="runningtimes.RData")
results <- boot(data=subset(runningtimes,Sex==0)$time2015, 
                statistic=funk, R=1000)
results
plot(results)
boot.ci(results, type="bca")


#install.packages("pwrss")
library(pwrss)
pwrss.t.2means(mu1 = 30, mu2 = 28, sd1 = 12, sd2 = 8, kappa = 1, 
               power=0.90, alpha = 0.05,
               alternative = "not equal")


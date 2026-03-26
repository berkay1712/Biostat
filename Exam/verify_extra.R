setwd("c:/Users/berka/OneDrive/Skrivebord/Biostat/Exam")
load("Hannan.RData")

cat("ADL fordeling:\n")
print(table(Hannan$ADL))
cat("ADL <= 3:", sum(Hannan$ADL <= 3), "ud af", nrow(Hannan),
    "=", round(mean(Hannan$ADL <= 3)*100, 2), "%\n")
cat("ADL >= 5:", sum(Hannan$ADL >= 5), "ud af", nrow(Hannan),
    "=", round(mean(Hannan$ADL >= 5)*100, 2), "%\n")

library(pROC)
m <- glm(Fraktur ~ ADL + Alder + Tidl_fald + Rygning,
         data = Hannan, family = binomial())
Hannan$pred <- predict(m, type = "response")
r <- roc(Hannan$Fraktur, Hannan$pred, quiet = TRUE)
ci <- ci.auc(r)
cat("AUC:", round(auc(r), 4), "\n")
cat("95% CI:", round(ci[1], 4), "-", round(ci[3], 4), "\n")

# binom.test for 5a
cat("\nbinom.test CI:\n")
print(binom.test(69, 1470)$conf.int)

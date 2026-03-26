setwd("c:/Users/berka/OneDrive/Skrivebord/Biostat/Exam")
load("Hannan.RData")

# ---- 5a ----
n   <- nrow(Hannan)
nfx <- sum(Hannan$Fraktur)
p   <- nfx / n
se  <- sqrt(p * (1 - p) / n)
cat("=== 5A ===\n")
cat("n:", n, " Frakturer:", nfx, "\n")
cat("Proportion:", round(p, 4), "\n")
cat("95% CI (normal-appr.):", round(p - 1.96*se, 4), "-", round(p + 1.96*se, 4), "\n")
pt <- prop.test(nfx, n)
cat("prop.test CI:", round(pt$conf.int[1], 4), "-", round(pt$conf.int[2], 4), "\n")

# ---- 5b ----
cat("\n=== 5B: ujusteret ADL -> Fraktur ===\n")
m_u <- glm(Fraktur ~ ADL, data = Hannan, family = binomial())
co  <- coef(summary(m_u))
print(co)
cat("OR ADL:", round(exp(co[2,1]), 4), "\n")
cat("95% CI:", round(exp(co[2,1] - 1.96*co[2,2]), 4), "-",
                round(exp(co[2,1] + 1.96*co[2,2]), 4), "\n")
cat("p:", round(co[2,4], 4), "\n")

# ---- 5c ----
cat("\n=== 5C: justeret model ===\n")
m_adj <- glm(Fraktur ~ ADL + Alder + Tidl_fald + Rygning,
             data = Hannan, family = binomial())
co2 <- coef(summary(m_adj))
print(co2)
cat("OR ADL (adj):", round(exp(co2[2,1]), 4), "\n")
cat("95% CI:", round(exp(co2[2,1] - 1.96*co2[2,2]), 4), "-",
               round(exp(co2[2,1] + 1.96*co2[2,2]), 4), "\n")
cat("p ADL:", round(co2[2,4], 4), "\n")
cat("OR Alder:", round(exp(co2[3,1]), 4), " p:", round(co2[3,4],4), "\n")
cat("OR Tidl_fald:", round(exp(co2[4,1]), 4), " p:", round(co2[4,4],4), "\n")
cat("OR Rygning:", round(exp(co2[5,1]), 4), " p:", round(co2[5,4],4), "\n")

# ---- 5d ----
library(pROC)
Hannan$response <- predict(m_adj, Hannan, type = "response")
r <- roc(Hannan$Fraktur, Hannan$response, quiet = TRUE)
cat("\n=== 5D: AUC ===\n")
cat("AUC:", round(auc(r), 4), "\n")
png("roc_hannan.png", width = 600, height = 600, res = 120)
plot(1 - r$specificities, r$sensitivities, type = "l",
     xlab = "1 - Specificitet", ylab = "Sensitivitet",
     main = "ROC: Fraktur ~ ADL + Alder + Tidl_fald + Rygning")
abline(0, 1, lty = 2, col = "gray")
dev.off()
cat("ROC plot gemt: roc_hannan.png\n")

# ---- 5e ----
cat("\n=== 5E: Prædiktion 80-årig, tidl_fald=1, rygning=0, ADL=3 ===\n")
ny_kvinde <- data.frame(Alder = 80, Tidl_fald = 1, Rygning = 0, ADL = 3)
pred <- predict(m_adj, newdata = ny_kvinde, type = "response")
cat("Estimeret frakturrisiko:", round(pred, 4), "\n")
cat("Dvs.:", round(pred * 100, 1), "%\n")

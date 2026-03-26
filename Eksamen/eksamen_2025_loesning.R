# Eksamensopgave Bio og Epi 7. nov 2025 — biostatistik (opg. 5–6)
setwd("c:/Users/berka/OneDrive/Skrivebord/Biostat/Eksamen")

load("Moeller.RData")

wald_or_ci <- function(fit, idx = 2) {
  co <- coef(summary(fit))
  est <- co[idx, 1]
  se <- co[idx, 2]
  c(OR = exp(est), lower = exp(est - 1.96 * se), upper = exp(est + 1.96 * se))
}

# ----- Opgave 5 -----
logreg <- glm(factor(overweight) ~ factor(sex), data = Moeller, family = binomial())
cat("=== Opgave 5A: ujusteret ===\n")
print(summary(logreg))
cat("OR køn (1 vs 0): "); print(wald_or_ci(logreg, 2))

logreg_adj <- glm(
  factor(overweight) ~ factor(sex) + maternalage,
  data = Moeller,
  family = binomial()
)
cat("\n=== Opgave 5B: justeret for maternalage ===\n")
print(summary(logreg_adj))
cat("OR køn: "); print(wald_or_ci(logreg_adj, 2))
cat("OR maternalage (per år): "); print(wald_or_ci(logreg_adj, 3))

# Opgave 5C: Hosmer-Lemeshow (kræver pakken performance)
if (requireNamespace("performance", quietly = TRUE)) {
  cat("\n=== Opgave 5C: Hosmer-Lemeshow ===\n")
  print(performance::performance_hosmer(logreg_adj, n_bins = 10))
} else {
  cat("\nInstallér performance: install.packages('performance')\n")
}

# ----- Opgave 6 -----
logreg_pre <- glm(
  factor(overweight) ~ factor(sex) + maternalage,
  data = Moeller,
  family = binomial()
)
Moeller2 <- cbind(Moeller, response = predict(logreg_pre, Moeller, type = "response"))

if (requireNamespace("pROC", quietly = TRUE)) {
  cat("\n=== Opgave 6B: ROC / AUC ===\n")
  r <- pROC::roc(Moeller2$overweight, Moeller2$response, quiet = TRUE)
  print(r)
  png("roc_eksamen_2025.png", width = 600, height = 600, res = 120)
  plot(1 - r$specificities, r$sensitivities, type = "l",
       xlab = "1 - Specificitet", ylab = "Sensitivitet",
       main = "ROC: overvægt ~ køn + maternal age")
  abline(0, 1, lty = 2, col = "gray")
  dev.off()
  cat("ROC-plot gemt: roc_eksamen_2025.png\n")
} else {
  cat("\nInstallér pROC: install.packages('pROC')\n")
}

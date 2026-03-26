load("C:/Users/berka/OneDrive/Skrivebord/Biostat/Exam/Hannan.RData")

# Tjek datasættet
cat("=== Datasæt overblik ===\n")
cat("Dimensioner:", dim(Hannan), "\n")
cat("Variabelnavne:", names(Hannan), "\n")
print(head(Hannan))
cat("\n")

# -------------------------------------------------------
# 5a) Proportion af frakturer med 95% KI
# -------------------------------------------------------
cat("=== 5a) Proportion af frakturer ===\n")
n <- nrow(Hannan)
x <- sum(Hannan$Fraktur == 1, na.rm = TRUE)
prop <- x / n
# Wilson konfidensinterval via prop.test
test <- prop.test(x, n, conf.level = 0.95, correct = FALSE)
cat("Antal frakturer:", x, "ud af", n, "\n")
cat("Proportion:", round(prop, 4), "\n")
cat("95% KI: [", round(test$conf.int[1], 4), ";", round(test$conf.int[2], 4), "]\n\n")

# -------------------------------------------------------
# 5b) Ujusteret logistisk regression: ADL -> Fraktur
# -------------------------------------------------------
cat("=== 5b) Ujusteret logistisk regression ===\n")
model_b <- glm(Fraktur ~ ADL, data = Hannan, family = binomial)
summary(model_b)
OR_b <- exp(coef(model_b))
CI_b <- exp(confint(model_b))
cat("OR for ADL (ujusteret):", round(OR_b["ADL"], 3), "\n")
cat("95% KI: [", round(CI_b["ADL", 1], 3), ";", round(CI_b["ADL", 2], 3), "]\n\n")

# -------------------------------------------------------
# 5c) Justeret logistisk regression
# -------------------------------------------------------
cat("=== 5c) Justeret logistisk regression ===\n")
model_c <- glm(Fraktur ~ ADL + Alder + Tidl_fald + Rygning,
               data = Hannan, family = binomial)
summary(model_c)
OR_c <- exp(coef(model_c))
CI_c <- exp(confint(model_c))
cat("\nOR og 95% KI (justeret):\n")
for (var in names(OR_c)) {
  cat(var, ": OR =", round(OR_c[var], 3),
      "95% KI [", round(CI_c[var, 1], 3), ";", round(CI_c[var, 2], 3), "]\n")
}

# -------------------------------------------------------
# 5d) AUC og ROC-kurve
# -------------------------------------------------------
cat("\n=== 5d) AUC og ROC-kurve ===\n")
if (!requireNamespace("pROC", quietly = TRUE)) install.packages("pROC", repos = "https://cloud.r-project.org")
library(pROC)

pred_c <- predict(model_c, type = "response")
roc_obj <- roc(Hannan$Fraktur, pred_c, quiet = TRUE)
auc_val <- auc(roc_obj)
cat("AUC =", round(auc_val, 4), "\n")

png("C:/Users/berka/OneDrive/Skrivebord/Biostat/Exam/roc_kurve.png",
    width = 800, height = 700, res = 120)
plot(roc_obj,
     main  = paste0("ROC-kurve for justeret logistisk model\nAUC = ", round(auc_val, 3)),
     col   = "#1976D2", lwd = 2,
     xlab  = "1 - Specificitet (Falsk positiv rate)",
     ylab  = "Sensitivitet (Sand positiv rate)")
abline(a = 0, b = 1, lty = 2, col = "grey50")
legend("bottomright", legend = paste0("AUC = ", round(auc_val, 3)),
       col = "#1976D2", lwd = 2, bty = "n")
dev.off()
cat("ROC-kurve gemt: Exam/roc_kurve.png\n")

# -------------------------------------------------------
# 5e) Forudsig risiko for specifik patient
# -------------------------------------------------------
cat("\n=== 5e) Risiko for 80-årig kvinde (Tidl_fald=1, Rygning=0, ADL=3) ===\n")
ny_patient <- data.frame(
  Alder     = 80,
  Tidl_fald = 1,
  Rygning   = 0,
  ADL       = 3
)
risiko <- predict(model_c, newdata = ny_patient, type = "response")
cat("Estimeret frakturrisiko:", round(risiko, 4), "\n")
cat("= ", round(risiko * 100, 1), "% sandsynlighed for fraktur\n")

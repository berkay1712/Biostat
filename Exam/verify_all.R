setwd("c:/Users/berka/OneDrive/Skrivebord/Biostat/Exam")
load("Hannan.RData")
library(pROC)

cat("========== GRUNDIG VERIFIKATION AF ALLE RESULTATER ==========\n\n")

# ---- Datasæt-struktur ----
cat("--- DATASÆT ---\n")
cat("n (rækker):", nrow(Hannan), "\n")
cat("Variable:", paste(names(Hannan), collapse=", "), "\n")
cat("Fraktur-værdier:", unique(Hannan$Fraktur), "\n")
cat("Rygning-værdier:", unique(Hannan$Rygning), "\n")
cat("Tidl_fald-værdier:", unique(Hannan$Tidl_fald), "\n")
cat("ADL min/max:", min(Hannan$ADL), "/", max(Hannan$ADL), "\n")
cat("Alder min/max:", round(min(Hannan$Alder),1), "/", round(max(Hannan$Alder),1), "\n\n")

# ---- 5A ----
cat("--- 5A: Proportion frakturer ---\n")
n   <- nrow(Hannan)
nfx <- sum(Hannan$Fraktur == 1)
cat("Antal frakturer:", nfx, "\n")
cat("Proportion:", round(nfx/n, 6), "=", round(nfx/n*100, 2), "%\n")
pt  <- prop.test(nfx, n, conf.level=0.95, correct=FALSE)
cat("prop.test KI:", round(pt$conf.int[1]*100,2), "% -", round(pt$conf.int[2]*100,2), "%\n")
# Eksakt CI
if (requireNamespace("PropCIs", quietly=TRUE)) {
  ec <- PropCIs::exactci(nfx, n, 0.95)
  cat("Eksakt KI (Clopper-Pearson):", round(ec$conf.int[1]*100,2), "% -", round(ec$conf.int[2]*100,2), "%\n")
}

# ---- 5B ----
cat("\n--- 5B: Ujusteret ADL -> Fraktur ---\n")
m_u <- glm(Fraktur ~ ADL, data=Hannan, family=binomial())
co_u <- coef(summary(m_u))
print(co_u)
cat("OR ADL:", round(exp(co_u["ADL",1]), 6), "\n")
# Wald KI
lb_u <- exp(co_u["ADL",1] - 1.96*co_u["ADL",2])
ub_u <- exp(co_u["ADL",1] + 1.96*co_u["ADL",2])
cat("Wald 95% KI:", round(lb_u,4), "-", round(ub_u,4), "\n")
cat("p-værdi:", round(co_u["ADL",4], 6), "\n")
cat("1 - OR = reduceret odds:", round((1-exp(co_u["ADL",1]))*100,1), "%\n")

# ---- 5C ----
cat("\n--- 5C: Justeret model ---\n")
m_adj <- glm(Fraktur ~ ADL + Alder + Tidl_fald + Rygning, data=Hannan, family=binomial())
co_a  <- coef(summary(m_adj))
print(co_a)
for (v in c("ADL","Alder","Tidl_fald","Rygning")) {
  OR  <- exp(co_a[v,1])
  lb  <- exp(co_a[v,1] - 1.96*co_a[v,2])
  ub  <- exp(co_a[v,1] + 1.96*co_a[v,2])
  cat(v, "OR:", round(OR,4), " 95%KI:", round(lb,4), "-", round(ub,4),
      " p:", round(co_a[v,4],6), "\n")
}

# ---- 5D ----
cat("\n--- 5D: AUC ---\n")
Hannan$response <- predict(m_adj, Hannan, type="response")
roc_obj <- roc(Hannan$Fraktur, Hannan$response, quiet=TRUE)
cat("AUC:", round(auc(roc_obj), 6), "\n")
cat("AUC afrundet:", round(auc(roc_obj), 3), "\n")

# ---- 5E ----
cat("\n--- 5E: Prædiktion ny kvinde ---\n")
ny <- data.frame(Alder=80, Tidl_fald=1, Rygning=0, ADL=3)
pred <- predict(m_adj, newdata=ny, type="response")
cat("Estimeret sandsynlighed:", round(pred, 6), "=", round(pred*100,2), "%\n")
cat("Basisrate:", round(nfx/n*100,2), "%\n")
cat("Forhøjet risiko ift. basisrate:", round(pred / (nfx/n), 2), "x\n")

# ---- Ekstra tjek: Hosmer-Lemeshow på justeret model ----
cat("\n--- EKSTRA: Hosmer-Lemeshow på justeret model ---\n")
if (requireNamespace("performance", quietly=TRUE)) {
  print(performance::performance_hosmer(m_adj, n_bins=10))
}

cat("\n========== VERIFIKATION AFSLUTTET ==========\n")

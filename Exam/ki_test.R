load("C:/Users/berka/OneDrive/Skrivebord/Biostat/Exam/Hannan.RData")
m_u <- glm(Fraktur ~ ADL, data = Hannan, family = binomial())

cat("Wald KI:\n")
print(round(exp(confint.default(m_u)), 3))

cat("\nProfil-likelihood KI:\n")
print(round(exp(confint(m_u)), 3))

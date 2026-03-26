################################################################################
# R FORMELSAMLING - MED FORKLARINGER
################################################################################

# VIGTIGE NOTER FØR DU STARTER:
# 1. "data" = dit datasæt navn (fx Berg, Nielsen)
# 2. "variable" = din variabel (fx age, bweight) 
# 3. "gruppe" = din gruppevariabel (fx Group, case)

################################################################################
# LIBRARIES - PAKKER DU SKAL BRUGE
################################################################################

# Først installer pakkerne (kun første gang):
install.packages(c("pastecs", "gmodels", "dplyr", "ggplot2", "boot", "performance"))

# Så load dem (hver gang du åbner R):
library(pastecs)    # til statistik
library(gmodels)    # til krydstabeller
library(dplyr)      # til databehandling
library(ggplot2)    # til plots
library(boot)       # til bootstrap
library(performance) # til model tests
library(haven) # factorisering af variable
library(interactions)
library(survival) # survival analysis
library(ggfortify) # survival analysis
library(caret)
library(pROC) #ROC kurver 
library(PropCIs) # til at bestemme CI i en bestemt gruppe
library(rms) #til test, fx Omnibus

################################################################################
# INDLÆS DATA
################################################################################

# 1. Tjek hvor R leder efter dine filer (i hvilken mappe på computeren)
getwd()

# 2. Fortæl R hvor dine filer ligger (VIGTIGT: brug / ikke \)
setwd("C:/Users/idol/OneDrive - Syddansk Universitet/Documents")

# 3. Indlæs din datafil
load(file="Data.RData") 

################################################################################
# GENNEMSNIT, STANDARDAFVIGELSE OG ANTAL
################################################################################

# SAMMENLIGN TO GRUPPER:
# Dette giver gennemsnit, standardafvigelse og antal for hver gruppe
data %>% 
  group_by(gruppe) %>%           # del data op i grupper
  summarise(
    mean_variable = mean(variable, na.rm = TRUE),    # gennemsnit
    sd_variable = sd(variable, na.rm = TRUE),        # standardafvigelse
    n = n()                                          # antal observationer
  )

# UDEN GRUPPERING (hele datasættet):
# Brug denne hvis du ikke skal sammenligne grupper
data %>% 
  summarise(
    mean_variable = mean(variable, na.rm = TRUE),
    sd_variable = sd(variable, na.rm = TRUE),
    n = n()
  )

# ALTERNATIV METODE (giver mere detaljerede resultater):
# Denne kode giver mange tal - gennemsnit og SD findes blandt dem
by(data$variable, data$gruppe, stat.desc)

# MEDIAN OG KVARTILER:
# Brug denne hvis dine data ikke er normalfordelte
data %>%
  group_by(gruppe) %>%
  summarise(
    median = median(variable, na.rm = TRUE),         # median (50% kvartil)
    q25 = quantile(variable, 0.25, na.rm = TRUE),    # 25% kvartil
    q75 = quantile(variable, 0.75, na.rm = TRUE),    # 75% kvartil
    n = n()
  )

# MEDIAN UDEN GRUPPERING:
data %>%
  summarise(
    median = median(variable, na.rm = TRUE),
    q25 = quantile(variable, 0.25, na.rm = TRUE),
    q75 = quantile(variable, 0.75, na.rm = TRUE),
    n = n()
  )

################################################################################
# KATEGORISKE VARIABLE - ANTAL OG PROCENTER
################################################################################

# BINÆRE VARIABLE (0/1, ja/nej):
# Tæller hvor mange der har værdien "1" i hver gruppe
data %>%
  group_by(gruppe) %>%
  summarise(
    n_total = n(),                                    # total antal i gruppen
    n_positive = sum(variable == 1, na.rm = TRUE),   # antal med værdi "1"
    proportion_positive = mean(variable == 1, na.rm = TRUE) # andel med værdi "1"
  )

# KRYDSTABEL (CrossTable):
# Laver en tabel der viser antal og procenter
CrossTable(
  data$variable,     # din variable (fx smoking)
  data$gruppe,       # din gruppe (fx Group)
  prop.c = TRUE,     # vis procent af kolonnetotal (dette vil du oftest bruge)
  prop.r = FALSE,    # vis procent af rækketotal
  prop.t = FALSE,    # vis procent af hele tabellen
  prop.chisq = FALSE # vis chi-square bidrag (skal være FALSE)
)

################################################################################
# STATISTISKE TESTS - HVORNÅR BRUGER DU HVILKEN?
################################################################################

# FOR KONTINUERTE VARIABLE (alder, vægt, højde osv.):

# 1. T-TEST - brug når:
# - Data er tilnærmelsesvis normalfordelte (tjek med QQ-plot)
# - Grupperne har nogenlunde samme spredning
# Nulhypotese: Ingen forskel mellem grupperne
t.test(variable ~ gruppe, data = data)
# P-værdi < 0.05 = signifikant forskel mellem grupper

# 2. WILCOXON TEST - brug når:
# - Data er IKKE normalfordelte
# - Små stikprøver
# - Mange outliers
wilcox.test(variable ~ gruppe, data = data)

# FOR KATEGORISKE VARIABLE (ja/nej, ryger/ryger ikke osv.):

# 3. CHI-SQUARED TEST - brug når:
# - Alle celler i krydstabellen har mindst 5 observationer
chisq.test(data$variable, data$gruppe)

# 4. FISHER'S EXACT TEST - brug når:
# - Nogle celler har mindre end 5 observationer
fisher.test(data$variable, data$gruppe)

################################################################################
# TJEK OM DATA ER NORMALFORDELTE
################################################################################

# QQ-PLOT - den vigtigste normalitetstest:
# Punkterne skal ligge på den blå linje hvis data er normalfordelte

# QQ-plot for én gruppe:
ggplot(data[data$gruppe == 0, ], aes(sample = variable)) +
  stat_qq() +                                    # lav punkterne
  stat_qq_line(color = "steelblue") +           # lav den blå linje
  ggtitle("QQ-plot af variable (Gruppe 0)")

# QQ-plot for alle data sammen:
ggplot(data, aes(sample = variable)) +
  stat_qq() + 
  stat_qq_line(color = "steelblue") + 
  ggtitle("QQ-plot af variable")

# Sammenlign grupperne side om side:
ggplot(data, aes(sample = variable)) +
  geom_qq(size = 1) + 
  geom_qq_line(color = "blue") +
  facet_wrap(~gruppe) +                         # lav separate plots for hver gruppe
  ggtitle("QQ-plots for hver gruppe")

# HISTOGRAM - viser fordelingen visuelt:
# Skal ligne en klokke hvis normalfordelt

# Histogram for én gruppe:
ggplot(data[data$gruppe == 0, ], aes(x = variable)) +
  geom_histogram(color = "black", fill = "lightblue", bins = 15) +
  ggtitle("Histogram af variable (Gruppe 0)")

# Histogram for alle data:
ggplot(data, aes(x = variable)) +
  geom_histogram(color = "black", fill = "lightblue", bins = 15) +
  ggtitle("Histogram af variable")

################################################################################
# LINEÆR REGRESSION - HVORNÅR OG HVORDAN
################################################################################

# HVORNÅR BRUGES LINEÆR REGRESSION?
# Outcome skal være kontinuert (f.eks. grams frugtindtag)
# + når der er flere covariates, der skal justeres for, kan der ikke bruges 
# t-test eller wilcoxon

# Simpel model: effekt af binær eksponering på outcome
linreg <- lm(outcome ~ factor(exposure),data=data)

# Simpel model: effekt af kontinuet eksponering på outcome
linreg <- lm(outcome ~ exposure,data=data)

# MED SUBSET (f.eks. kun kvinder)
linreg <- lm(outcome ~ exposure, data = subset(data, sex == 1))

# JUSTERET FOR ANDRE VARIABLE
linreg <- lm(outcome ~ factor(exposure) + var1 + var2, data = data)

summary(linreg)
# FORTOLKNING AF KOEFFICIENTER 
# - Intercept: Forventet værdi af outcome når alle prediktorer er 0
# - For binær exposure: gennemsnitsforskel i outcome ml. eksponeret og reference
# - For kontinuertlig kovariat (f.eks. alder): ændring i outcome per enheds-
# ændring 

confint(linreg)
# Giver os 95% konfidensintervaller

# TJEK OM MODELLEN PASSER TIL DATA 
par(mfrow = c(2, 2)) # Denne kommando deler grafvinduet op i 2x2 grid 
plot(linreg_adj) # kommandoen laver fire standarddiagnostiske plots fra den lineære
# model
## VÆR OPMÆRKSOM!! Hvis cook's distance linjen er overskredet med flere 
# observationer, så prøv kør sidste kode linje plot(linreg_adj) og se om den 
# også er i det individuelle plot!!!!

# HVAD ER RESIDUALER?
# Residualer er forskellen mellem det modellen forudsiger, og det vi faktisk 
# observerer 

# Residualer er vigtige fordi de viser, hvor godt modellen passer til data:
# Hvis residualerne ligger tilfældigt spredt omkring nul, er modellen ok.
# Hvis der er systematik i residualerne (f.eks. at de bliver større jo ældre man
# er), tyder det på, at modellen ikke er god nok. 

# Residuals vs. Fitted
# Viser residualer plottet mod fitted values for at tjekke linearitet. 
# Residualerne er spredt nogenlunde tilfældigt omkring nul-linken uden tydelige
# mønstre, hvilket indikerer at linearitetsforudsætningen er opfyldgt

# Q-Q Residuals
# Sammenligner residualernes fordeling med normalfordelingen for at tjekke 
# normalitet. Punkterne følger stortset den teoretiske linje. Normalitets-
# forudsætningen ser rimelig opfyldt ud. 

# Scale-Location
# Tjekker homoskedasticitet ved at plotte kvadratroden af standardiserede 
# residualer mod fitted values. Punkterne er nogenlunde jævnt spredt, og røde 
# linje er relativt flad. Tyder på konstant varians

# Residuals vs. Leverage 
# Identificerer outliers og indflydelsesrige observationer. Få observationer har 
# høj leverage, men ingen krydser Cook's distance-linjen, så ingen obs har 
# kritisk stor indflydelse


# Konklusionen: Modelforudsætningerne er generelt opfyldt. Linearitet, 
# normalitet og homoskedasticitet ser acceptabel ud, og der er ingen
# problematiske outliers.

################################################################################
# KONFIDENSINTERVALLER FOR ANDELE (PROPORTIONER)
################################################################################

# Bruges når:
# - Man har en kategorisk variabel (fx ja/nej, ryger/ryger ikke)
# - Man vil finde 95% konfidensinterval for en andel i en bestemt gruppe
#   (fx andelen af kvinder, der ryger nu)

# EKSEMPEL:

# OBS: Årsagen til, at vi benytter denne til at bestemme CI er, at vi ikke har
# et outcome, normal har vi jo lavet ala 

linreg <- lm(outcome~exposure,data=data)

# men her har vi ingen outcome, vi har kun var1 og var2 // eller med andre ord
# vi vil gerne under en undergruppe af vores data for konfindesinterval.
# i tilfældet med opgaven fra uge 7: kvinder, der ryger nu

exactci(length(subset(data, var1 == INDSÆT TAL & var2 == INDSÆT TAL)$var2),# andel du er interesseret i 
        length(subset(data, var1 == INDSÆT TAL)$var2),                    # samlede andel 
        conf.level = 0.95)                                                # 95% konfidensinterval

# FORKLARING:
# 1. subset(data, var1 == 0 & var2 == INDSÆT TAL)
#    - Udvælger kun f.eks. kvinder, der ryger nu (hvis man indsætter tallet 2)
# 2. length(...$smoke)
#    - Tæller hvor mange observationer (kvinder) der opfylder betingelsen
#    - Dette tal er "x" (antal succeser)
# 3. length(subset(Chudasma, sex == 0)$smoke)
#    - Tæller alle kvinder i datasættet (uanset rygestatus)
#    - Dette tal er "n" (antal personer i gruppen)
# 4. exactci(x, n, conf.level = 0.95)
#    - Beregner et eksakt (Clopper–Pearson) 95% konfidensinterval for andelen x/n

# RESULTAT:
# Funktionen returnerer:
#   - den estimerede andel (x/n)
#   - et nedre og øvre konfidensinterval (95%)
# Eksempel:
#   0.230  (95% CI: 0.180 – 0.290)
# dvs. ca. 23% af kvinderne ryger nu, og vi er 95% sikre på, at den sande
# andel i populationen ligger mellem 18% og 29%.

# HVORNÅR BRUGES EXACTCI?
# - Når data er binære/kategoriske (f.eks. ja/nej, ryger/ryger ikke)
# - Når stikprøven er lille, eller man ønsker et eksakt konfidensinterval
# - Samme formål som binom.test() i base R, men exactci() returnerer
#   kun konfidensintervallet direkte (ingen p-værdi)

# Man kan også beregne dette mere manuelt: 

# Antal kvinder i datasættet
n_kvinder <- sum(data$var == nummer, na.rm = TRUE)

# Antal af disse kvinder, der ryger nu
n_ryger_kvinder <- sum(data$var == nummer & data$var1 == nummer, na.rm = TRUE)

# Andel
p <- n_ryger_kvinder / n_kvinder

# 95% CI med prop.test (giver normal-approksimation)
prop.test(n_ryger_kvinder, n_kvinder)

## Eller endnu mere manuelt

# Antal kvinder i datasættet
n_kvinder <- sum(data$var == nummer, na.rm = TRUE)

# Antal af disse kvinder, der ryger nu
n_ryger_kvinder <- sum(data$var == nummer & data$var1 == nummer, na.rm = TRUE)

# Andel
p <- n_ryger_kvinder / n_kvinder

p <- n_ryger_kvinder / n_kvinder
se <- sqrt(p * (1 - p) / n_kvinder)
lower <- p - 1.96 * se
upper <- p + 1.96 * se
c(lower, upper)


################################################################################
# PRÆDIKTION
################################################################################
#Bruges når vi vil forudsige, hvad vi kan forvente af nye observationer (samme
# population). Prædiktionsinterval vil være mere usikkert fordi der skal tages
# højde for den variation der kan være i de nye observationer. 

#### Når vi prædiktere på numerisk udfald (kontinueligt) bruger vi 
#lineær regression.
# Som evaluering bruger vi at køre modellen på traningsdata (typisk 70%), og herefter
# på testdata (30%) for at se hvor godt vores model klarede sig på
# det "usete" data. ###

####KØR ANALYSEN PÅ X % af DATA ###

# set.seed(tal) - gør vi for at sikre os at vi får det samme resultat når vi 
# gentager analysen 

data$training = rbinom(dim(data)[1],1,0.7)
# dim(data)[1]: Finder antallet af rækker i datasætter (deltagere)
# rbindom(n, 1, 0.7): laver n tilfældige binomialfordelte tal (0 eller 1) 
# med det sidste tal i parantesen (her 0.7) sikrer vi os at 70% af obs har 
# tallet 1 i kolonnen training
# Training: er en ny kolonne til datasættet med 0 og 1. Hvor ca 70% får 
# værdien 1.

# Hvad betyder dette?
# I praksis betyder dette egentlig "bare", at ud af de x obsevationer i data-
# sættet vil der ud fra x % af disse stå 1, og de resterende observationer
# har 0 i training kolonnen

# Når man så gerne vil undersøge sin data bruger man følgende kommando til at 
# specificere, at man gerne vil kigge på de 70% af datasættet (med training==1)
linreg <- lm(outcome ~ exposure+factor(var1), data = subset(data,training==1))
summary(linreg)

# Skal mam lave en prædiktion for en bestemt type person i data, kan man benytte
# følgengende metoder

# Metode 1:

# Step 1. Hvilken type person ? Her er et eksemple med en 35 årig man, der ikke 
# spiser økologisk
person <- data.frame(age=35,sex=2,ecological=0)

# predict bruger modellen defineret tidligere (linreg) se opgave b. 
# Har i kaldt opgaven noget andet end linreg, skal det stå efter predict
predict(linreg, newdata=person,interval="prediction")

# Her får man tallene for manden, der ikke spiser økologisk, hvorefter man kan 
# udskifte så der står ecological = 1.

# Metode 2: Med denne metode får man både manden der spiser øko og ikke-gør i 
# samme output
new_Andersen <- data.frame(age=c(35,35),sex=c(2,2),ecological=c(1,0))
cbind(new_Andersen,predict(linreg, newdata = new_Andersen, interval = "predict"))

####Evaluer prædiktionen grafisk - lineær regression#### 

#Metode: vi bruger de XX% som vi tildelte til testdata. 
#Vi sammenligner det observerede outcome med det prædikterede outcome. I dette 
#eksempel er det frugtindtag fra Andersen data, og testdata er 30%. 
#Vi tegner en ret linje gennem 0 med hældning 1 (pink) - kommandoen abline.
#Hvis de prædikterede værdier passede godt til de observerede så ville punkterne
#følge linjen.
#Tilsidst kan vi kalde cor() for at få en værdi for hvor godt vores model 
#præstere - jo tættere på 1 jo bedre.

subset_30 <- subset(Andersen, training==0)
subset_30$predicted <- predict(linreg1,newdata=subset_30)

plot(subset_30$fruits,subset_30$predicted,
     xlab="Observeret frugtindtag",
     ylab="Forudsagt frugtindtag",
     main="Model-evaluering på testdata")
abline(0,1,col="pink",lwd=2)

cor(subset_30$fruits, subset_30$predicted)

#HUSK Opmærksomhedspunkter, forelæsning 6, slide 9!

### Når vi vil prædiktere på dikotome udfald bruges logistisk regression ###
#Prædiktionen giver os her en ny sandsynlighed for at personen ("uset") for/har
#udfaldet. OBS: Her bruges ikke prædiktionsinterval.

#Eksempel fra stat_7 eksamensopgaven, efterår 25:
#Lav koden for en prædiktionsmodel, der prædikterer risikoen for overvægt 
#baseret på barnets køn og morens alder og forklar hvad i gør.

logreg_præ <- glm(factor(overweight) ~ sex + maternalage, data = Moeller, family = "binomial") 

Moeller = cbind(Moeller,response=predict(logreg_præ, Moeller, type="response"))

#Her bruger vi en LOGISTISK regression fordi udfaldet er overvægt ja/nej 
#prædikere overvægt baseret på køn og morens alder for alle børn i datasættet.
#Vi tilføjer variablen "response" til Moeller data, og denne vil være en 
#sandsynlighed for overvægt (outcome).
#En anden mulighed kunne være at vi vælger et cutoff på baggrund af de sandsynligheder
#der er prædikteret af modellen, og deler i Høj risiko/lav risiko. 
#Se forelæsning 6, slide 13 og 14. 

#En prædiktion med dikotom udfald, logistisk regression, evalueres med ROC-kurver
#grafisk og AUC (jo højere værdi jo bedre, og altid bedre end at gætte som vil
#være 50%)

#Her igen med eksemplet fra eksamensopgave 25, opgave 6.
#Tegn en ROC-kurve og beregn AUC for denne prædiktionsmodel A). Giv en vurdering af, om 
#modellen er en god/velegnet prædiktionsmodel?

roc <- roc(Moeller$overweight,Moeller$response) #forskellen mellem det observerede 
#og det prædikterede, kommer i mit miljø 

roc #her kommer værdien for AUC i mit output 

plot(1-roc$specificities,roc$sensitivities,type="l") #grafisk kurve kommer frem

#Fortolkning AUC er kun cirka 0.53, så prædiktionen er ret dårligt,
#grafisk kan vi se på kurven at den ca. har ret halvdelen ad gangene. HUSK! Sæt
#sceenshots ind ad outcome og forklar. 


################################################################################
# LINEÆR REGRESSION MED INTERAKTIONER
################################################################################

# HVORNÅR SKAL DER BRUGES INTERAKTIONER?
# Når du vil teste om effekten af en variable afhænger af en anden variable
# Noteret med * i modellem 

# OBS: Et interaktionsled tester for effektmodifikation. Interaktion er den 
# statistiske metode, der bruges for at undersøge, om der er effektmodifikation

# Når vi bruger interaktion i lm-modellen er interaktionen automatisk additiv 
# Men lavede vi en interaktion i glm-modellen er interaktionen oftest multiplikativ

# lm() → ADDITIV
# glm() med family=binomial eller poisson → MULTIPLIKATIV

linreg_int <- lm(outcome ~ exposure*var1, data = data)

summary(linreg_int)
# FORTOLKNING AF INTERAKTIONER
# - Koefiicienter med ":" viser den ekstra effekt når begge variable er til stede
# - Hvis p-værdien for interaktionen < 0.05: effekten af exposure afhænger af 
# var1
# HVIS interaktionen IKKE er signifikant kan man fjerne interaktionsleddet fra 
# modellen. Så kan vi fortolke og konkludere på hovedeffekterne uafhængigt af 
# hinanden. ## OBS OBS OBS: DEtte er KUN relevant, hvis I en dag arbejder med 
# eget data - og opgaverne til eksamen kræver ikke dette :-) !
# HVIS interaktionen ER signifikant skal interaktionsleddet blev i modellen. 
# Men nu kan man ikke fortolke hovedeffekterne alene!! Da den reelle effekt af 
# var1 varierer afhængigt af værdien af var2 (og omvendt)

confint(linreg_int)

################################################################################
# LOGISTISK REGRESSION - HVORNÅR OG HVORDAN
################################################################################

# HVORNÅR BRUGES LOGISTISK REGRESSION?
# Når dit OUTCOME er binært (0/1, ja/nej, syg/rask)

# GRUNDLÆGGENDE LOGISTISK REGRESSION:
# Undersøger om exposure påvirker outcome
logreg <- glm(factor(outcome) ~ factor(exposure), data = data, family = "binomial")

# MED SUBSET (fx kun kvinder):
# Laver analysen kun for en del af datasættet
logreg <- glm(factor(outcome) ~ factor(exposure), 
              data = subset(data, sex == "kvinde"), 
              family = "binomial")

# JUSTERET FOR ANDRE VARIABLE:
# Tager højde for andre faktorer der kan påvirke resultatet
logreg <- glm(factor(outcome) ~ factor(exposure) + age + factor(sex), 
              data = data, 
              family = "binomial")

# NU SKAL DU SE RESULTATERNE - 4 TRIN:

# TRIN 1: SE COEFFICIENTER OG P-VÆRDIER
summary(logreg)
# Forklaring af output:
# - Intercept: log-odds for outcome når exposure = 0
# - For binær exposure: forskel i log-odds mellem exposure = 1 og 0
# - For kontinuert exposure: ændring i log-odds per enheds-stigning
# - P-værdi: < 0.05 betyder signifikant sammenhæng
# OBS: Coefficienter er i log-odds - skal konverteres i trin 2!

# TRIN 2: ODDS RATIOS (de tal du skal bruge!)
exp(coef(logreg))
# Dette konverterer log-odds til odds ratios:
# - OR = 1: Ingen effekt
# - OR > 1: Øget risiko (fx OR = 2 betyder dobbelt så stor risiko)
# - OR < 1: Reduceret risiko (fx OR = 0.5 betyder halveret risiko)

# TRIN 3: KONFIDENSINTERVALLER
exp(confint(logreg))
# Giver 95% konfidensintervaller for dine odds ratios
# Hvis intervallet indeholder 1, er effekten ikke signifikant

# TRIN 4: TJEK OM MODELLEN PASSER TIL DATA
performance_hosmer(logreg, n_bins = 10)

# Hosmer-Lemeshow testen evalueer om de forudsagte sandsynligheder fra modellen 
#matcher de observerede frekvenser i dataene. Den opdeler observationerne i 
#grupper (bins) og sammenligner: forvetende antal events (baseret på modellen)
#med observede antal event (faktiske data).

# Fortolkning: 
# p-værdi > 0.05. God model fit
# p-værdi < 0.05. dårlige model fit. 

# Valget af bins er en af de største begrænsinger ved metoden her. 

# ELLER BRUG OMNIBUS 
# Omnibus-testen: en test for om min logistiske regressionsmodel som helhed er
# signifikant. Denne test sammenligner: null-modellen (model uden prediktorer) 
# og min model (med alle prediktorer). 

#her opdateret med Sörens kode fra forelæsning, brug denne når I skal lave Omnibus:

logreg.res <- lrm(factor(Outcome) ~ Glucose, data = diabetes, y = TRUE, x = TRUE)
residuals(logreg.res, type = "gof")

# Fortolkning: 
# p-værdi > 0.05. God model fit
# p-værdi < 0.05. dårlige model fit. 

################################################################################
# KAPLAN-MEIER
################################################################################

# HVORNÅR BRUGES KAPLAN-MEIER?
# Når du vil visualisere og sammenligne overlevelse/tid-til-event mellem grupper
# - Outcome: Tid indtil en begivenhed indtræffer (død,sygdom)
# - Censuring: Nogle personer følges ikke hele vejen (dropout, studiet slutter)
# - Bruges til at lave overlevelseskurver og sammenligne grupper visuelt

# DU SKAL BRUGE TRE VARIABLE:
# 1. tid_variable = tid til event eller censurering
# 2. event_variable = binær (1 = event, 0 = censureret)
# 3. gruppe = gruppevariable (behandling vs. kontrol)

# KAPLAN-MEIER ANALYSE: 
survfit(Surv(time,event)~gruppe,data=data)
# eksempel på hvordan denne udfyldes, se biostat_w5 
# Forklaring af output
# Giver median overlevelsestid for hver gruppe med 95% konfidensintervaller 
# (den tid hvor 50% har oplevet eventet)
# gruppe1 = 0, under events = antal år 
# gruppe2 = 1, under events = antal år
# fortolkning: gruppe 1 får event median # år tidligere end gruppe 2

# LOG-RANK TEST: 
# Tester om der er signifikant forskel mellem overlevelseskurverne
survdiff(Surv(time, event) ~ gruppe, data = data)
# p-værdi < 0.05: signifikant forskel mellem grupperne
# nulhypotese: ingen forskel i overlevelse mellem grupper
# Output viser:
# - Observed: Faktisk antal events i hver gruppe
# - Expected: Forventet antal events hvis der ingen forskel var
# Stor forskel mellem  observed og expected indikerer større/mindre risiko

# SIMPEL PLOT UDEN KONFIDENSINTERVALLER:
plot(survfit(Surv(time, event ~ gruppe, data = data), 
     col = c("blue", "red"),
     xlab = "Tid (år)", 
     ylab = "Andel uden event"))
     
legend("topright", 
       legend = c("Gruppe 0", "Gruppe 1"),
       col = c("blue", "red"), 
       lty = 1)

# PLOT MED KONFIDENSINTERVALLER (autoplot):
km <- survfit(Surv(time, event) ~ gruppe, data = data)
autoplot(km)
# Viser automatisk konfidensintervaller omkring kurverne

# En tredje metode med mere endnu mere udførligt plot
ggsurvplot(
  km,
  pval = TRUE,
  conf.int = TRUE,
  risk.table = TRUE,
  ggtheme = theme_minimal(),
  xlab = "Tid",
  ylab = "event",
  legend.title = "covariates",
  legend.labs = c("Nej", "Ja")
)


################################################################################
# COX-REGRESSION 
################################################################################

# HVORNÅR BRUGES COX-REGRESSION
# Når du vil analysere tid-til-event OG justere for andre variable (covariates)
# - Outcome: Tid indtil event (som Kaplan-Meier)
# - Kan justere for alder, køn, uddannelse og andre faktorer
# - Giver Hazard Ratios (HR) - risiko for event til ethvert tidspunkt

# DU SKAL BRUGE:
# 1. tid_variable = tid til event eller censurering
# 2. event_variable = binær (1 = event, 0 = censureret)
# 3. exposure = din primære eksponering
# 4. covariates = variable du vil justere for

# Simpe cox (uden justering):
cox_simple <- coxph(Surv(time, event) ~ exposure, data = data)

# JUSTERET COX MODEL:
# Justerer for alder, køn, uddannelse og andre relevante variable
# OBS: Hvis binær var1 factor() foran.
cox_adj <- coxph(Surv(time, event) ~ exposure + factor(var1) + var2, 
                 data = data)

# SE RESULTATERNE - 3 TRIN:

# TRIN 1: SE COEFFICIENTER OG P-VÆRDIER
summary(cox_adj)
# Forklaring af vigtige dele:
# - coef: log(HR) - skal konverteres til HR i trin 2
# - exp(coef): Hazard Ratio (HR)
# - Pr(>|z|): P-værdi (< 0.05 betyder signifikant effekt)
# - Likelihood ratio test: Test af modellen som helhed (skal være p < 0.05)
# - Concordance: Mål for modelens prædiktion (>0.7 er godt)

# TRIN 2: HAZARD RATIOS (de tal du skal bruge!)
exp(coef(cox_adj))
# Fortolkning af HR:
# - HR = 1: Ingen effekt
# - HR > 1: Øget risiko (fx HR = 1.58 betyder 58% højere risiko)
# - HR < 1: Reduceret risiko (fx HR = 0.89 betyder 11% lavere risiko)
# For kontinuerte variable (fx alder): HR per enheds-stigning
# - HR = 1.03 for alder betyder 3% højere risiko per år

# TRIN 3: KONFIDENSINTERVALLER
exp(confint(cox_adj))
# Giver 95% konfidensintervaller for hazard ratios
# Hvis intervallet inkluderer 1, er effekten ikke signifikant
# Eksempel: CI: 1.16-2.15 inkluderer ikke 1, så effekten er signifikant

# TJEK PROPORTIONAL HAZARDS ANTAGELSEN:
# Cox-modellen antager at hazard ratios er konstante over tid
cox.zph(cox_adj, transform = "km")
# P-værdi > 0.05 for hver variabel: Antagelsen er opfyldt (ønsket resultat)
# P-værdi < 0.05: Antagelsen er brudt (problem!)
# GLOBAL p-værdi: Test af hele modellen samlet

# Hvis antagelsen er brudt, kan du:
# 1. Stratificere på den problematiske variabel
# 2. Inkludere tid-afhængige covariates
# 3. Dele analysen op i tidsperioder

# COX MODEL MED INTERAKTION:
# Test om effekten af exposure afhænger af en anden variabel
cox_int <- coxph(Surv(time, event) ~ exposure*var1 + factor(var2) + var3, 
                 data = data)
summary(cox_int)

# Nedenfor er optional (I kan bruge dem, hvis I gerne vil have de specifikke
# tal ud, og ikke læse outputtet)

exp(coef(cox_int))
exp(confint(cox_int))

# FORTOLKNING AF INTERAKTIONER I COX:
# - Hvis interaktionsleddet (exposure:var1) er signifikant (p < 0.05):
#   Effekten af exposure varierer med niveauet af var1
# - Hvis interaktionen IKKE er signifikant: (OBS kun gør dette, hvis I bliver
# spurgt specifikt om det!!!!! Eller til jeres eventuelle fremtidige forskerkarrier)
#   Fjern interaktionen og brug hovedeffekter-modellen 
# - Når interaktion er signifikant i Cox: effekterne er MULTIPLIKATIVE
#   (i modsætning til lineær regression hvor de er additive)

################################################################################
# FORSKELLIGE VISUALISERINGSPLOT TIL DATA
################################################################################

# Lineær regression (kotinuert outcome og kontinuert eksponering)

ggplot(data = data, aes(x = exposure, y = outcome)) +
  geom_point(alpha = 0.6) +  # scatter points
  geom_smooth(method = "lm", color = "blue", se = TRUE) +  # regression line with CI
  labs(
    x = "Exposure variable",
    y = "Outcome variable",
    title = "Linear regression between exposure and outcome"
  ) +
  theme_minimal()

# Boxplots (kontinuert outcome, kategorisk eksponering)

ggplot(data = data, aes(x = factor(exposure), y = outcome, fill = factor(exposure))) +
  geom_boxplot() +
  labs(
    x = "Exposure group",
    y = "Outcome variable",
    title = "Boxplot of outcome across exposure groups"
  ) +
  theme_minimal() +
  theme(legend.position = "none")

# Violinplot (god til at vise fordeling og median)

ggplot(data = data, aes(x = factor(exposure), y = outcome, fill = factor(exposure))) +
  geom_violin(trim = FALSE, alpha = 0.7) +
  geom_boxplot(width = 0.1, fill = "white", outlier.shape = NA) +
  labs(
    x = "Exposure group",
    y = "Outcome variable",
    title = "Violinplot showing distribution of outcome by exposure"
  ) +
  theme_minimal() +
  theme(legend.position = "none")


# Histogram (fordeling af én kontinuert variable)

ggplot(data = data, aes(x = outcome)) +
  geom_histogram(bins = 30, fill = "steelblue", color = "white") +
  labs(
    x = "Outcome variable",
    y = "Count",
    title = "Distribution of outcome"
  ) +
  theme_minimal()



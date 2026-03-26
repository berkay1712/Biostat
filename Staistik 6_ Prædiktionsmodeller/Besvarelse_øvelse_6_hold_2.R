################################################
#Opgave 1
################################################
# Pakker
install.packages("caret")
library(caret)
install.packages("pROC")
library(pROC)
library(haven)


## a) Indlæs datasættet ”Andersen.RData” i R.
load(file="Andersen.RData")

## b) Lav en lineær regression der forudsiger frugtindtag baseret på personens alder 
# og køn på 70% af datasættet.

# Der genereres en ny kolonne hvor der ved tilfældighed tildeles 1 eller 0. der tildeles 1 til 70%

set.seed(42) # set.seed fastlåser en tilfældig talgenerator, så en talrække starter samme sted hver gang
# Det er ligegyldigt hvilket tal man bruger

Andersen$training = rbinom(dim(Andersen)[1],1,0.7) 
# rbinom laver en binominal fordelt værdi for hver række
# Andersen$training laver en ny kolonne
# dim(Andersen)[1] henter antallet af rækker i datasættet
# 1 betyder at der angivet 1 eller 0 til hver række en gang
# 0.7 betyder at der er 70% sandsynlighed for at det bliver 1

# Frugtindtag er outcome (kontinuert) 
# Baseret på alder og justeret for køn
# Kun på 70% af datasættet, hvor training er 1
linreg <- lm(fruits ~ age+factor(sex), data = subset(Andersen,training==1))
summary(linreg)
# Alder er ikke signifikant associeret med frugtindtag (p-værdi 0,463)
# Køn er signifikant associeret med frugtindtag (p-værdi 0,000000276) hvor mænd spiser 108g mindre 
# frugt end kvinder


## c) Bestem prædiktionen og prædiktionsintervallet for en 50-årig kvinde.
# Vi laver en ny dataframe med de to betingelser
new_Andersen <- data.frame(age=50,sex=1)

# De to betingelser bindes sammen med outputtet predict ud fra linreg
cbind(new_Andersen,predict(linreg, newdata = new_Andersen, interval = "predict"))

# Alternativt delt op
predict_data <- predict(linreg, newdata = new_Andersen, interval = "predict")
new <- cbind(new_Andersen, predict_data)

# Dette giver den predikterede værdi (forventede) og det predikterede interval
# Prædikteret værdi 292.5 [-69 : 654]
# Meget bredt interval, stor variation eller svag model


## d) Evaluer prædiktionen grafisk på de resterende 30% af datasættet

# Først beregnes en prædikteret værdi for hver række samt et prædikteret interval
# Med cbind bindes datasættet Andersen sammen med de nye kolonner der dannes med predict
Andersen2 = cbind(Andersen,predict(linreg, newdata = Andersen, interval = "predict"))

# For kun at plotte de resterende 30% af datasættet vælges training = 0
# Vi vælger hvad der skal være på x og y aksen (fruits og fit)
plot(subset(Andersen2,training==0)$fruits,subset(Andersen2,training==0)$fit)

# Vi tegner en ret linje gennem 0 med hældning 1
# Hvis de prædikterede værdier passede godt til de observerede
# så ville punkterne følge linjen 
abline(0,1)
# Punkterne ligger slet ikke på linjen men i stedet opdelt i to grupper (mænd og kvinder)

# Vi kan bestemme korrelationen mellem de observerede og prædikterede værdier
cor(subset(Andersen2,training==0)$fruits,subset(Andersen2,training==0)$fit)
# Jo nærmere 1 desto bedre. 0.2 er ikke en god korrelation
#Det ser ret dårligt ud, hvilket skyldes at alder betyder næsten ingenting.
#Så basalt set kommer alle mænd i en gruppe omkring 210 og alle kvinde i en gruppe omkring 300


###############################################################################
#Opgave 2
###############################################################################

## a) Indlæs datasættet ”Andersen.RData” i R.
load(file="Andersen.RData")

## b) Lav en lineær regression der forudsiger frugtindtag baseret på personens alder, 
# køn og økologisk på 70% af datasættet.

# Vi danner en ny kolonne der er 1 for 70% af datasættet
set.seed(42)
Andersen$training = rbinom(dim(Andersen)[1],1,0.7)

# Der laves en lineær model for sammenhængen mellem frugtindtag og alder 
# justeret for køn og øko når training er = 1, for at få 70% af datasættet
linreg <- lm(fruits ~ age+factor(sex)+factor(ecological), data = subset(Andersen,training==1))
summary(linreg)
# Hverken alder eller øko har en signifikant effekt
# Køn har en signifikant effekt på frugtindtag

## c) Bestem prædiktionen og prædiktionsintervallet for en 35-årig mand der spiser økologisk, 
# og en 35-årig mand, der ikke spiser økologisk.

# Der laves et nyt datasæt med betingelserne
# Vi har både en række for en 35-årig mand der spiser øko og en der ikke gør
new_Andersen <- data.frame(age=c(35,35),sex=c(2,2),ecological=c(1,0))
# De forskellige betingelser bindes sammen med outputtet predict ud fra linreg
cbind(new_Andersen,predict(linreg, newdata = new_Andersen, interval = "predict"))
# Vi får en prædikteret værdi for hver gruppe samt et prædikteret interval
# øko_1 149 [-245 : 543]
# øko_0 123 [-269 : 516]
# Meget bredt interval

## d) Evaluer prædiktionen grafisk på de resterende 30% af datasættet

# Vi danner en ny kolonne med prædikterede værdier og intervaller
Andersen2 = cbind(Andersen,predict(linreg, newdata = Andersen, interval = "predict"))

# De observerede og de prædikterede værdier plottes
plot(subset(Andersen2,training==0)$fruits,subset(Andersen2,training==0)$fit)
# Der tegnes en ret linje fra 0,0 med hældningen 1
abline(0,1)
# korrelationen mellem de prædikterede og observerede værdier bestemmes
cor(subset(Andersen2,training==0)$fruits,subset(Andersen2,training==0)$fit)
#Stadig ikke overbevisende (men måske lidt bedre end i opgave 1, 0,22 vs. 0,20)

##############################################################################
#Opgave 3
#############################################################################

## a) Indlæs datasættet ”Nielsen.RData” i R.
load(file="Nielsen.RData")

## b) Lav en logistisk regression der forudsiger lymfekræft baseret på personens alder, 
# køn og tatovering på 70% af datasættet.

# Der laves en ny kolonne med 70% af datasættet
set.seed(42)
Nielsen$training = rbinom(dim(Nielsen)[1],1,0.7)
# Denne gang er outcome binominal (1 eller 0) derfor bruges glm
# Der justeres for alder, køn og tatoo
# Analysen laves kun på de 70% af datasættet
logreg <- glm(factor(case) ~ age+factor(sex)+factor(tatoo), data = subset(Nielsen,training==1), 
              family = "binomial")
summary(logreg)
exp(coef(logreg))
exp(confint(logreg))
# Baseline odds for at blive case er 0.4 [0.29 : 0.56]
# Alder, køn og tatoo er ikke signifikante
# Måske man kunne argumentere for at det var værd at se på tatoo
# der viser 18% højere risiko, selvom CI overlapper 1 og p 0.087

## c) Tegn er ROC-kurve på de resterende 30% og beregn AUC. Hvad fortæller denne kurve jer?
# Installer pakken pROC
install.packages("pROC")
library(pROC)

# Vi laver en ny kolonne med sandsynligheden for at være gruppe 0 eller 1
# Hvis værdierne er tættest på 0 er det mest sandsynligt at hører til gruppe 0
Nielsen2 = cbind(Nielsen,response=predict(logreg, Nielsen, type="response"))
# Alle værdier ligger omkring 0.2 til 0.3, så modellen adskiller ikke grupperne ret godt

# Vi laver en ROC analyse
# Bruges til at vurdere hvor godt en binær model skelner mellem de to klasser
# Datasættet inddeles med subset for case og response, i begge tilfælde kun for training = 0
roc <- roc(subset(Nielsen2$case,Nielsen2$training==0),subset(Nielsen2$response,Nielsen2$training==0))
# For at se en opsummering skrives elementets navn
roc
# Vi kan se at AUC er 0.5129
# AUC på 0.5 = tilfældighed
# AUC på 1 = perfekt skelnen

# Vi plotter kurven for sensitivitet vs 1-specificitet
# Sensitivitet = sand positiv rate
# Specificitet = sand negativ rate
# 1- specificitet = falsk positiv rate
plot(1-roc$specificities,roc$sensitivities,type="l")
#Kurven er næsten diagonal og AUC=0.5129, så modellen er ikke for alvor bedre end at gætte
# Hvis modellen var god ville linjen ligge oppe mod venstre hjørne = højere AUC

## d) Bestem sensitivitet og specificitet for et cut-off på 0.25 (på de 30% valideringsdata).
# hvis sandsynligheden er >= 0.25 defineres de som cases
# Hvis sandsynligheden er < 0.25 defineres de som kontroller/ case = 0

# Først defineres cutoff
cutoff = 0.25

# Vi laver en ny kolonne der hedder highrisk
# Hvis response >= cutoff så kommer der til at stå 1, ellers 0
Nielsen2$highrisk = ifelse(Nielsen2$response>=cutoff,1,0)

# Vi kan bruge table til at se hvor mange der er i hver gruppe 
# for cases og kontroller
# table(A, B), A = rækker/vandret, B = kolonner/lodret
table(Nielsen2$case,Nielsen2$highrisk)
# Man kan også skrive det på
table(Nielsen2$case,Nielsen2$highrisk, dnn = c("case", "highrisk"))

# Installer pakke
install.packages("caret")
library(caret)

# Beregn sensitiviteten
sensitivity(factor(Nielsen2$highrisk), factor(Nielsen2$case))
# 0.569 = 57% af dem der faktisk er cases fanges af modellen

# Beregn specificiteten
specificity(factor(Nielsen2$highrisk), factor(Nielsen2$case))
# 0.472 = 47% af dem der faktisk er kontroller klassificeres korrekt

# Modellen er ikke ret god til at finde cases og heller ikke til at "frikende" ikke-cases


# memory control
rm(list = ls())
gc()




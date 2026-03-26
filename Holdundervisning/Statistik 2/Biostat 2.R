library(pastecs) # til stat.desc
library(sur)
library(gmodels)
library(boot)
library(dplyr) # til metoden, hvor vi benytter denne %>% 
library(ggplot2) # til at lave de flotte plots

################################################################################
# Opgave 1 
###############################################################################

# OPGAVE 1.1. Indlæs datasættet Berg2RData
# Ændre working directory
setwd("C:/Users/idol/OneDrive - Syddansk Universitet/Documents/PhD/Undervisning/Biostat F26")

# Load datasættet
load(file = "Berg2.RData")


# OPGAVE 1.2. Bestem gennemsnit og spredning for start af tidskud (agestart) i de to gr
# Metode 1: 
Berg %>%
  group_by(Group) %>%
  summarise(
    mean_agestart = mean(agestart, na.rm = TRUE),
    sd_agestart = sd(agestart, na.rm = TRUE),
    n = n()
  )

# Group 0, mean = 2.65, sd = 1.42
# Group 1, mean = 2.91, sd = 1.36

# Metode 2:
by(Berg$agestart,Berg$Group,stat.desc)

# Alternativ metode fra Sören
mean(subset(Berg,Group==0)$agestart)
sd(subset(Berg,Group==0)$agestart)

mean(subset(Berg,Group==1)$agestart)
sd(subset(Berg,Group==1)$agestart)

# OPGAVE 1.3. Bestem median og kvartiler for start af tidskud (agestart) i de to grupper

# Metode 1:
Berg %>%
  group_by(Group) %>%
  summarise(
    median = median(agestart,na.rm=TRUE),
    q25 = quantile(agestart, 0.25, na.rm=TRUE),
    q75 = quantile(agestart, 0.75, na.rm=TRUE)
  )

# Group 0, median = 2.31, q25 = 1.73, q75 = 3.27
# Group 1, median = 2.69, q25 = 1.89, q75 = 3.50

# Metode 2:
aggregate(agestart~Group,Berg,quantile,probs=c(0.25,0.5,0.75),na.rm=TRUE)

# Group 0, median = 2.31, q25 = 1.73, q75 = 3.27
# Group 1, median = 2.69, q25 = 1.89, q75 = 3.50

# OPGAVE 1.4. Tjek om observationerne for start af tidskud (agestart) i de to grupper
# er normalfordelt

# Metode 1: 
ggplot(Berg,aes(sample=agestart))+
  geom_qq(size=1)+ # man kan bestemme størrelsen på prikkerne i plottet
  geom_qq_line(color="blue")+ # man kan bestemme farven på linjen
  facet_wrap(~Group)

# Sören metode: 
qqnorm(Berg[Berg$Group==1,]$agestart)
qqline(Berg[Berg$Group==1,]$agestart)
qqnorm(Berg[Berg$Group==0,]$agestart)
qqline(Berg[Berg$Group==0,]$agestart)


# OPGAVE 1.5. Gennefør en t.test for start af tidskud (agestart) i de to grupper
t.test(agestart~Group,data=Berg)
# p = 0.3411
# Nulhypotese: Der er ikke forskel i gennemsnitlig agestart mellem grupperne
# Konklusionen: p=0.3411 > 0.05 
# Vi fandt ikke evidens for, at der er forskel i gennemsnitlig agestart mellem grupperne

# OPGAVE 1.6. Gennemfør en Mann-Whitnes/Wilcoxon ranksumtest for agestart i de grupper

wilcox.test(agestart~Group,data=Berg)
# Denne syntaks ~ fortæller R at agestart er den afhængige variable, og Group 
# er groupperingsvariablen
# p = 0.1399 

# OPGAVE 1.7. Hvilken af de to tests vurderer I er mest retvisende og hvorfor?

# Valg af test:
# t.test bruges når:
# 1) Data er tilnærmelsesvist normalfordelte indenfor grupper
# 2) Varians i grupperne er nogenlunde ens
# Wilcoxon test bruges når:
# 1) Data ikke er normalfordelte
# 2) Små stikprøver, hvor normalitet ikke kan antages
# 3) Vi ønsker robusthed overfor outliers eller skævhed

# Derfor vælger vi t.test

################################################################################
# Opgave 2 
################################################################################

# 2.1. Indlæs datasættet Berg2.RData i R
load(file="Berg2.RData")

# 2.2. Bestem gennemsnit og spredning for tid til fuldt tilskud i de to grupper 

# Metode 1: 
Berg %>% 
  group_by(Group) %>%
  summarise(
    mean = mean(timefull,na.rm=TRUE),
    sd = sd(timefull,na.rm=TRUE),
  )

# Group 0 - mean: 24.2 - sd: 37.0
# Group 1 - mean: 27.0 - sd: 70.2 

# Metode 2: 
by(Berg$timefull,Berg$Group,stat.desc)

# Group 0 - mean: 24.2 - sd: 37.0
# Group 1 - mean: 27.0 - sd: 70.2 

# Alternativ metode fra Sören
mean(subset(Berg,Group==0)$timefull)
sd(subset(Berg,Group==0)$timefull)

mean(subset(Berg,Group==1)$timefull)
sd(subset(Berg,Group==1)$timefull)

# 2.3. Bestem median og kvartiler for tid til fuldt tilskud (timefull) i de to gr
# Metode 1:
Berg %>%
  group_by(Group) %>%
  summarise(
    median = median(timefull,na.rm=TRUE),
    q25 = quantile(timefull, 0.25, na.rm=TRUE),
    q75 = quantile(timefull, 0.75, na.rm=TRUE)
  )

# Group 0 - median: 10.8 - q25: 4.12 - q75: 27.1 
# Group 1 - median: 5.74 - q25: 2.09 - q75: 16.5 

# Metode 2:
aggregate(timefull~Group,Berg,quantile,probs=c(0.25,0.5,0.75),na.rm=TRUE)

# 2.4. Tjek om observationerne for tid til fuldt tilskud i de to grupper er 
# normalfordelte

# Metode 1: Med denne metode og brugen af facet_wrap(~Group) får vi både plottet
# over Gruppe 0 og 1 frem:
ggplot(Berg,aes(sample=timefull))+
  geom_qq(size=1)+ # man kan bestemme størrelsen på prikkerne i plottet
  geom_qq_line(color="blue")+ # man kan bestemme farven på linjen
  facet_wrap(~Group)


# Metode 2: 
qqnorm(Berg[Berg$Group==1,]$timefull)
qqline(Berg[Berg$Group==1,]$timefull)

qqnorm(Berg[Berg$Group==0,]$timefull)
qqline(Berg[Berg$Group==0,]$timefull)


# 2.5. Gennemfør en t-test for s tid til fuldt tilskud (timefull) i de to grupper
t.test(timefull~Group,data=Berg)
# Nul hypotesen: Der er ingen forskel i gennemsnitlig tid til fuldt tilskud mellem
# de to grupper
# p-værdi: 0.8002 
# konklusion: Vi kan ikke forkaste nul hypotesen (p > 0.05). Der er ingen 
# statistisk signifikant forskel mellem grupperne.

# 2.6. Gennemfør en Mann-Whitney/Wilcoxon ranksum-test for tid til fuldt tilskud
wilcox.test(timefull~Group,data=Berg)
# Nul hypotesen: Der er ingen forskel i median tid til fuldt tilskud mellem de to 
# grupper
# p-værdi: 0.03766 
# Konklusion: Vi forkaster nulhypotesen (p<0.05). Der er statistisk signifikant
# forskel mellem grupperne. 

# 2.7. Hvilken af de to tests vurderer I mest retvisende og hvorfor?
# QQ-plottene er ikke særlig pæne, så Wilcoxon-testen er at foretrække

################################################################################
# Opgave 3
################################################################################

# Her laver vi en tom dataframe/tabel, der skal gemme de resultater, vi får.
# Lige nu er den helt tom, men vi har givet den en kolonne, som vi kalder p.
# Senere skal denne kolonne bruges til p-værdier
res <- data.frame(p=c())

# Nu angiver vi med N hvor mange observationer/personer, der er hver groppe 
# Der er altså 100 personer i gruppe 0 og 100 personer i gruppe 1 
N <- 100 # og vi kalder variablen for N

# R laver tilfældige tal, med ved at sætte et "seed" sikrer vi, at de tilfældige 
# tal bliver de samme hver gang vi kører programmet. Ellers ville resultaterne 
# se forskellige ud, hver gang man kørte koden.
set.seed(24) 

# Her starter vi et loop, som er en løkke/gentagelse, hvor vi gør det samme 
# 10 000 gange. Det gør vi fordi vi vil se, hvor ofte en t-test finder en forskel
# mellem de to groupper. Jo flere gange vi gentager, jo mere præcist resultat 
# får vi
for (i in 1:10000){ 
  
  #Vi laver en gruppe-variable, her står rep(1, each=N) for "gentag tallet 1, N gange
  # så vi får 100 stk (gruppe 1) og 100 stk (gruppe 0). Resultatet er en liste 
  # med 200 personer.
  Group=c(rep(1,each=N),rep(0,each=N)) 
  
  # Vi laver her en pladsholder til vores data (200 værdier). Lige nu er alle 
  # værdier sat til NA (not available)
  x = rep(NA,each=2*N) 
  
  # Nu laver vi de rigtige data. Til gruppe 1 laver vi 100 tilfældige tal, der 
  # ligger omkring gennemsnittet 10.1 (spredning = 1). 
  # Til gruppe 0 laver vi 100 tilfældige tal, der ligger omkring gennemsnittet 
  # 10.0 (spredning = 1). Det er med funktionen rnorm() vi får tallene til at 
  # være normalfordelte
  x[Group==1] = rnorm(N,10.1,1)
  x[Group==0] = rnorm(N,10,1)
  
  # Vi laver en t-test: statistisk test, der kan undersøge, om de grupper har 
  # forskellige gennemsnit: Er gennemsnittet i gruppe 1 forskelligt fra 
  # gennemsnittet i gruppe 0?
  ttest = t.test(x~Group)
  
  # Fra t-testen gemmer vi kun p-værdien. P-værdien fortæller os, hvor stærkt 
  # bevis vi har for, at grupperne virkelig er forskellige.
  # p < 0.05 -> forskellen er statistisk signifikant 
  # p > 0.05 -> vi har ikke bevis nok for forskel
  # Vi gemmer alle p-værdierne i rækken res.
  res = c(res,ttest$p.value)
} # slut på loopet

# Til sidst regner vi ud, hvor mange af p-værdierne der er mindre end 0.05. 
# sum(res<0.05) fortæller hvor mange p-værdier er under 0.05
# length tæller hvor mange p-værdier vi har i alt. Det tal er vores power: hvor 
# tit testen finder en forskel, når der faktisk er en.
sum(res<0.05)/length(res)

# Så efter 10 000 simuleringer af t-testen mellem de to grupper var p-værdien 
# mindre end 0.05 i 11.58% af tilfældene. Så fordi forskellen mellem gennemsnit 
# i de grupper kun var 0.1 finder testen kun en signifikant forskel ca. 12% af
# gangene. 


rm(res) # denne kode står for remove, og I kan benytte den til at fjerne variable
# og dataset i environment 
rm(ttest)

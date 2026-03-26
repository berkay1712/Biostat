################################################################################
# install packackages 
################################################################################

#install.packages("pastecs")
#install.packages("sur")
#install.packages("gmodels")
#install.packages("boot")
library(pastecs) # til stat.desc
library(sur)
library(gmodels)
library(boot)
library(dplyr) # til metoden, hvor vi benytter denne %>% 
library(ggplot2) # til at lave de flotte plots
library(haven) # for at kunne faktoriserer variable

################################################################################
# Opgave 1.a.
###############################################################################

# Indlæs datasættet Andersen.RData
# Ændre working directory
setwd("C:/Users/idol/OneDrive - Syddansk Universitet/Documents/PhD/Undervisning epi + biostat/Biostat øvelser")

# Load datasættet
load(file = "Andersen.RData")

################################################################################
# OPGAVE 1.b. 
################################################################################

# Undersøg vha. en statistisk test, om den som spsier økologisk spiser en større
# mængde frugt. Dernæst skal der justeres for køn. Hvad er konklusionen? 

# Da vores outcome er kontinuert, kan vi ikke bruge logistisk regression, men
# der bruges i stedet lineær regression

linreg <- lm(fruits ~ factor(ecological), data=Andersen)
summary(linreg)
# Estimat for ecological: 67.36, p-værdi = 0.000781
# Dem, der spiser økologisk, spiser i gennemsnit 67.36 gram mere frugt end dem,
# der ikke spsier økologisk. Forskellen er statistisk signifikant.
confint(linreg)
# Konfidensintervallet er [28.24;106.50]

# Samlet konklusion: Personer, der spiser økol 67.36 gram, 95% CI: [28.2;106.5],
# p-værdi: 0.00078).

# Nu justerer vi for køn: 
linreg_adj <- lm(fruits ~ factor(ecological) + factor(sex), data=Andersen)
summary(linreg_adj)
# Estimat for ecological: 31.22, p-værdi = 0.138
# Økologisk spisere spiser stadig mere frugt i gennemsnit, men effekten er ikke
# statitisk signifikant. Man kan faktisk også se på p-værdien for køn i outputtet
# at der er en signifikant forskel mellem kønnene.

confint(linreg_adj)
# Konfidensintervallet er [-10.1;72.5] 
# Da intervallet går over 0 er det ikke signifiaknt.

# Samlet konklusion: Når der justeres for køn, er forskellen ikke længere 
# signifikant (estimat 31.2, 95% CI [-10.1;72.5], p-værdi: 0.138).

################################################################################
# Opgave 1.c. 
################################################################################

# Undersøg, om forudsætninger er opfyldt i ovenstående analyse, hvor der justeres
# for køn. Hvad er konklusionen?

par(mfrow = c(2, 2)) # Denne kommando deler grafvinduet op i 2x2 grid 
plot(linreg) # kommandoen laver fire standarddiagnostiske plots fra den lineære
# model

# Når vi har en binær eksponering og kontinuert outcome, vil nogle af plotene 
# se anderledes ud. 

# I Residual vs. Fitted og Scale-Location plots ser vi to tydelige søjler, 
# én ved hver værdi af den binære eksponering - detet skyldes at de fitted
# values kun kan tage to værdier (gennemsnit for eksponeret gr. vs ikke-eksponeret)

# I Residuals vs. Fitted skal I tjekke:
# Derfor skal vi kigge efter om residualerne er nogenlunde symmetrisk fordelt 
# omkring 0 i hver af de to søjler, og om spredningen ser nogenlunde ens ud. 

# I scale-location skal I tjekke: 
# om de standardiserede residualer har samme spredning i begge grupper 
# (kaldes også homoskedasticitet)

# Q-Q plot: 
# Er residualerne nogenlunde fordelt langs en lineær linje?

# Residuals vs. Leverage
# Bruges til at identificere outliers og indflydelsesrige observationer

# Konklusionen for os: Det ser pænt ud! Residualerne ser symmetrisk fordelt
# ud i begge gruppre, spredningen virker sammenlignelig. Q-Q plot viser normalitet

################################################################################
# Opgave 1.d. 
################################################################################

# Undersøg, om der er en interaktion mellem økologi og køn i deres association 
# med mængden af frugt. Hvad er konklusionen?

linreg_int <- lm(fruits ~ factor(ecological)*factor(sex),data=Andersen)
summary(linreg_int)

# Når vi er interesserede i interaktion, kigger vi på interaktionseffekten i 
# outputtet som er kendetegnet ved ":", altså factor(ecological)1:factor(sex)2 
# estimat: 133.6, p = 0.00541. Dette er statistisk signifikant, og det betyder 
# at sammenhængen mellem økologi og frugt indtag er forskellig for mænd og 
# kvinder. 
# coefficients: 
# Intercept, estimat: 303.5 - gns. frugtindtag for ref. gr. (ikke-øko, køn=1)
# ecological effect, estimat: -2.885 - for ref. gr. (køn=1) er der næsten ingen 
# forskel mellem øko og ikke-øko
# sex effect, estimat: -113.7: for ikke-øko personer spiser køn=2 betydeligt 
# mindre frugt end køn = 1. 

################################################################################
# Opgave 1.d. 
################################################################################

# Lav en analyse hvor associationen mellem mængden af frugt og økologi, splittes 
# op i kvinder og mænd

# Her bruger vi subset for at definere netop et subset af hele datamængden
linreg <- lm(fruits ~ factor(ecological), data = subset(Andersen,sex==1))
summary(linreg)
confint(linreg)

# Der er ingen signifikant forskel i frugtindtag mellem kvinder, der spiser øko
# vs. kvinder, der ikke spiser øko. Kvinder, der spiser øko, spiser i gns. 2.89 
# gram mindre frugt per dag, men dette er ikke statistisk signifikant (p = 0.915)
# konfidensintervallet inkluderer 0, hvilket bekræfter den manglende signifikans
# [-56.08;50.31]

linreg <- lm(fruits ~ factor(ecological), data = subset(Andersen,sex==2))
summary(linreg)
confint(linreg)

Andersen$ecological <- as_factor(Andersen$ecological)

# Der er en stærkt signifikant positiv sammenhæng mellem at spise øko og frugt-
# indtag blandt mænd. Mænd, der køber øko spiser i gennemsnit 130.7 gram mere 
# frugt per dag sammenlignet med mænd, der ikke spiser øko (p=0.0002), 
# 95% CI [62.1;199.3]

# Samlet konklusion: Interaktionen er klar: Økologisk indkøb er kun associeret 
# med højere frugtindtag blandt mænd, ikke blandt kvinder. 



################################################################################
# Opgave 2.a.
###############################################################################

# Indlæs datasættet Andersen.RData
# Ændre working directory
setwd("C:/Users/idol/OneDrive - Syddansk Universitet/Documents/PhD/Undervisning epi + biostat/Biostat øvelser")

# Load datasættet
load(file = "Andersen.RData")

################################################################################
# OPGAVE 2.b. 
################################################################################

# Undersøg ved hjælp af en statistisk test, om dem som spiser økologisk, spiser 
# en større mængde frugt, når der er justeret for alder. Dernæst skal der også 
# justeres for køn. Hvad er konklusionen af disse to outputs, hvor man inddrager
# estimatet, 95% CI og p-værdi af sidste model?

# Da vores outcome er kontinuert, kan vi ikke bruge logistisk regression, men
# der bruges i stedet lineær regression

linreg <- lm(fruits ~ factor(ecological) + age, data=Andersen)
summary(linreg)
confint(linreg)

# Efter justering for alder spiser personer, der også spiser øko, signifikant 
# mere frugt - i gennemsnit 68 gram mere per dag, end dem, der ikke køber øko 
# (p = 0.000656, 95% CI [29.26;107.61])

# Nu justerer vi for køn: 
linreg_adj <- lm(fruits ~ factor(ecological) + factor(sex) + age, data=Andersen)
summary(linreg_adj)
confint(linreg_adj)

# Efter justering for både alder og køn er forskellen i frugtindtag mellem 
# økologiske og ikke-økologiske spisere ikke længere statistik signifkant. 
# Estimatet er: 32 gram per dag, men p = 0.126, og 95% CI inkluderer 0: 
# [-9.08;73.53]

################################################################################
# Opgave 2.c. 
################################################################################

# Undersøg, om forudsætninger er opfyldt i ovenstående analyse, hvor der justeres
# for alder og køn. Hvad er konklusionen?

par(mfrow = c(2, 2)) # Denne kommando deler grafvinduet op i 2x2 grid 
plot(linreg_adj) # kommandoen laver fire standarddiagnostiske plots fra den lineære
# model

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
# høj leverage, men ingen krydser Cook's distance-linjerne, så ingen obs har 
# kritisk stor indflydelse

# Konklusionen: Modelforudsætningerne er generelt opfyldt. Linearitet, 
# normalitet og homoskedasticitet ser acceptabel ud, og der er ingen
# problematiske outliers.

################################################################################
# Opgave 2.d. 
################################################################################

# Undersøg, om der er en interaktion mellem økologi og køn i deres association 
# med mængden af frugt, når der justeres for alder. Hvad er konklusionen?

linreg_int <- lm(fruits ~ factor(ecological)*factor(sex) + age,data=Andersen)
summary(linreg_int)

# Når vi er interesserede i interaktion, kigger vi på interaktionseffekten i
# outputtet, som er kendetegnet ved ":", altså: factor(ecological)1:factor(sex)2
# Estimat: 135 gram, p = 0.00479. Dette er statistisk signifikant, og det betyder
# at sammenhængen mellem øko og frugtindtag er forskellig for mænd og kvinder, 
# når der justeres for alder.

# Fortolkning af koefficienterne:
  
# Intercept (74.319): Gennemsnitligt frugtindtag for referencegruppen 
# (ikke-økologisk, køn=1/kvinder) ved alder 0
# Ecological effect (-2.277): For referencegruppen (kvinder) er der næsten ingen 
# forskel mellem økologisk og ikke-økologisk spisere (ikke signifikant, p=0.925)
# Sex effect (-114.428): For ikke-økologiske personer spiser køn=2 (mænd)
# betydeligt mindre frugt end køn=1 (kvinder)
# Age effect (3.765): For hvert år ældre spises der 3.8 gram mere frugt (ikke signifikant)
# Interaktion (135.463): Den ekstra effekt når både økologi=1 og køn=2 (mænd)

# Konklusion:
# Selv efter justering for alder forbliver interaktionen signifikant - økologiske 
# spisere påvirker kun frugtindtaget hos mænd, ikke hos kvinder.

################################################################################
# Opgave 2.d. 
################################################################################

linreg <- lm(fruits ~ factor(ecological)+age, data = subset(Andersen,sex==1))
summary(linreg)
confint(linreg)

# Estimat: -2.19 gram frugt per dag
# 95% CI: [-55.43;51.05]
# p-værdi: 0.935 

# Konklusion: Der er ingen signifikant sammenhæng mellem økologisk-spusere og
# frugtindtag blandt kvinder, også efter justering for alder. Kvinder der spiser
# økologisk spiser i gennemsnit 2.19 gram mindre frugt per dag, men forskellen 
# er ikke statistisk signifikant.

linreg <- lm(fruits ~ factor(ecological)+age, data = subset(Andersen,sex==2))
summary(linreg)
confint(linreg)

# Estimat: 133 gram frugt per dag
# 95% CI: [64;202] 
# p-værdi: 0.000194

# Konklusion: Der er en stærkt signifikant positiv sammenhæng mellem økologi-spisere
# og frugtindtag blandt mænd, også efter justering for alder. Mænd der spiser 
# økologisk spiser i gennemsnit 132.72 gram mere frugt per dag

################################################################################
# Opgave 3
################################################################################

# a) Kig på Tabel 1 og den omkringliggende tekst i afsnit 1.2. Hvorfor er der 
# tale om en interaktion i dette eksempel?

# Der er tale om en interaktion i dette eksempel, fordi effekten af rygning på 
# risiko for lungekræft varierer afhængigt af asbest-eksponering
# Interaktionen består i: Effekten af rygning er forskellig afhængigt af 
# asbest-eksponering. 

# Hvis de to faktorer ikke interagerede, ville man forvente, at den øgede risiko
# for at være både ryger og asbesteksponeret bare var summen af risikoen ved at
# ryge og ved at være udsat for asbest

# Derfor ser vi på følgende
# 1. Grundrisiko (uden rygning og asbest): 0.0011 
# 2. Ekstra risiko ved rygning alene: 0.0095-0.0011 = 0.0084
# 3. Esktra risiko ved asbest alene: 0.0067-0.0011 = 0.0056 

# Den forventedr risiko ved begge, hvis der IKKE var interaktion ville være:
0.0011+0.0084+0.0056 = 0.0151

# Men den observerede risiko for en person, der både ryger og er udsat for 
# asbest, er 0.0450, altså meget større end 0.0151. Effekten af de to faktorer 
# forstærker hinanden: additiv interaktion.


# b) Eksemplet finder forskelle mellem den additive og den multiplikative 
# interaktion. Hvordan skal disse to forskellige effekter fortolkes?

# Additiv interaktion: Den observerede risiko (4.5%) er højere end den 
# Forventede ved at ligge de individuelle risikostigninger samemn (1.51%)
# De to faktorer forstærker altså hinanden mere end ved bare at lægge deres
# effekter sammen

# Multiplikativ interaktion (negativ i dette tilfælde)
# Måler om den relative risiko (RR) for kombinationen matcher produktet af de 
# enkelte RR

# RR for rygning alene
0.0095/0.0011 # = 8.6
## RR for asbest alene 
0.0067/0.0011 # = 6.1

# Altså den forventede relative risiko ved multiplikationen 
8.6*6.1 # = 52.5

# Mens den observerede (taget fra tabellen) er:
0.0450/0.0011 # = 40.9

# Interaktions-RR: 
40.9/52.5 # = 0.78 (22% lavere end forventet)

# Foltolkning: På relativ skal "hjælper" de to faktorer ikke hinanden så meget
# som forventet

# c) I afsnit 1.7 diskuteres to forskellige måder at præsentere resultaterne på 
# (Tabel m5 og Tabel 6). Hvordan skal resultaterne fortolkes i de to tabeller?

# Tabel 5: sammenligner udelukkende asbest-eksponerede med ikke-asbest-eksponerede
# i hhv. ryger og ikke-ryger gruppe. Kan bruges hvis vi kun er interesserede i 
# effekten af asbest effekten hos rygere og ikke-rygere. 
# Tabel 6: sammenligner alle grupper ift. reference gruppe = 1 
# (ikke-asbest-eksponerede og ikke-rygere). Hvis vi er interesseret i både 
# asbest og rygning som eksponering 

################################################################################
# R introduktion 
################################################################################


# Heroppe kan man skrive den tekst man har lyst til
Men skriver man tekst uden et hashtag foran, læser R teksten som kode, og man 
vil få fejl, hvis man  prøver at køre hele koden

# R er et program, hvor alle og en hver kan lave deres egne pakker til 
# forskellige formål. Men bagsiden af medaljen ved denne detalje er, at vi skal
# downloade disse pakker for at kunne bruge dem. 

# Console/konsollen som er i venstreside under selve dette vindue er hvor vores
# output kommer. Altså vores resultater. Den kan også benyttes som en regulær
# regnemaskine. Man kan egentlig også bare skrive sin kode i konsollen, MEN
# gør man det, så gemmes koden ikke til næste gang i åbner programmet. Så ville 
# I skulle skrive koden påny. 

# Øverst i højreside har vi oversigt over vores "Environment", det er der vi kan
# se de datasæt vi uploader i programmet, de variable vi laver, osv. osv. 
# Første gang I åbner programmet, står der Environment is empty

# Nederst i venstre højrne har vi så oversigt over bl.a. filer og plots. 
# Her kommer jeres figurer frem! 

################################################################################
# Opsætning af mappe R gemmer og tager filer fra
################################################################################

# Når vi starter R op, vil vi gerne finde ud af hvilken mappe på computeren, som 
# R (1) Gemmer vores R-dokumenter i, (2) leder efter filer i. Det kan man gøre
# på følgende måde
getwd() 

# Nu vil vi opfordre jer til at lave en designeret R-mappe, hvor i ligger
# de datasæt Sören giver jer i, og vil gemme disse R-filer. Når I har lavet 
# denne mappe, kan I bruge koden nedenfor, hvor i kopierer filstien direkte
# Det vigtige her, er at "/" vender denne vej. Se mit eksempel herunder:
setwd("C:/Users/idol/OneDrive - Syddansk Universitet/Documents/PhD/Undervisning/Biostat F26")

# Når dette er gjort, kan I direkte loade datafilen fra Sören. HVIS I har gemt 
# den i den mappe I lige har skrevet ovenover!

################################################################################
# Opgave 1.1. Indlæs datasaættet "Berg.RData"
################################################################################

load(file="Berg.RData")

# Nu skulle datasættet gerne poppe op under Environment, øverst til højre

# For at lave mange ting i R, skal ma hente de førnævnte pakker. Der er nogle pakker
# som man bare kan hente ved følgende kommendo library() 
# Mens ande kræver, at man installerer dem først, hvilket man gør med kommandoen
# herunder, pakken skal være i ""
install.packages("pastecs")
library(pastecs)

################################################################################
# Opgave 1.2. få overblik over datasættet
################################################################################

View(Berg) # kommandoer er følsomme over for store/små bogstaver, skrives der
view(Berg) # kommer der fejl i funktionen

################################################################################
# Opgave 1.3. Bestem gennesnit og spredning for fødselsvægt
################################################################################

# Med denne kommando beder du om at åf statistic descriptives, deriblandt 
# spredning og gennemsnit. Inden i parentesen specificere jeg, at jeg ønsker
# at R benytter datasættet Berg, og så skal man derefter skrive hvilken variable
by(Berg$birthweight, Berg$Group, stat.desc)

# Gennemsnit Group 0: 1.16
# Spredning Group 0: 0.303

# Gennemsnit Group 1: 1.26
# Spredning Group 1: 0.398

# Eller man kan bruge denne kode
mean(subset(Berg,Group==0)$birthweight)
sd(subset(Berg,Group==0)$birthweight)

# Man kan også bruge denne kode, hvis man gerne vil have svarerne mere direkte

library(dplyr)
library(tidyverse)

Berg %>%
  group_by(Group) %>%
  summarise(
    gennemsnit = mean(birthweight,na.rm=TRUE),
    spredning = sd(birthweight,na.rm=TRUE),
    antal=n()
  )


################################################################################
# Opgave 1.4. Bestem andelen af korikosteroid-burgere (corticosteroids) grupperne
################################################################################

# Kan også læses fra outputtet ovenfor, da jeg valgte at proppe "antal" i,
# ellers kan man bruge denne: 

Berg %>%
  group_by(Group) %>%
  summarise(
    antal=n()
  )

# Man kan også læse antallet fra denne kode: 
by(Berg$birthweight, Berg$Group, stat.desc)

# antal = nbr.val 

################################################################################
# Opgave 2.1 Gennemfør en t-test for forskellen mellem fødselsvægt mellem de to gr.
################################################################################

# Hvornår bruges t.test?
# T-TEST - bruges når:
  # - Data er tilnærmelsesvis normalfordelte (tjek med QQ-plot)

# HVad tester vi med en t.test - hvad er vores hypotese?
# Her er hypotesen at der IKKE er forskel på gennemsnittet af fødselsdvægt ml.
# De to grupper

t.test(birthweight~Group,data=Berg)

# OBS: Det er ikke ligegyldigt, om det er birthweight eller Group, der står først

t.test(Group~birthweight,data=Berg) # denne giver fejl. Hvorfor?
?t.test

# t test bruges til at teste forskel mellem grupper af to niveauer, Derfor kan 
# kommandoen ikke bruges således, da birthweight ofte er værdier mellem 1.5-4 kg. 

# p-val = 0.16 
# p > 0.05 - der er altså ingen evidens for forskel i fødselsvægt mellem de to
# grupper

################################################################################
# Opgave 2.2 Gennemfør en Mann-Whitney/wilcoxon for at teste forskellen ml.
# fødselsvægt i de to grupper
################################################################################

# Hvornår bruges wilcox?
# WILCOXON TEST - brug når:
  # - Data er IKKE normalfordelte
  # - Små stikprøver
  # - Mange outliers

wilcox.test(birthweight~Group,data=Berg)
?wilcox.test

# p-val = 0.12 
# p > 0.05 - dermed er konklusionen den samme - der er altså ingen evidens for 
# forskel i median-fødselsvægtens fordeling mellem de to grupper

################################################################################
# Opgave 2.3. Tjek normalfordelingen af fødselsvægt i de to grupper
################################################################################

# QQ-PLOT - den vigtigste normalitetstest:
# Punkterne skal ligge på den blå linje hvis data er normalfordelte

library(ggplot2)

# Sammenlign grupperne side om side:
ggplot(Berg, aes(sample = birthweight)) +
  geom_qq(size = 1) + 
  geom_qq_line(color = "blue") +
  facet_wrap(~Group) +                         # lav separate plots for hver gruppe
  ggtitle("QQ-plots for hver gruppe")

# Eller
qqnorm(subset(Berg,Group==0)$birthweight)
qqline(subset(Berg,Group==0)$birthweight)

# HISTOGRAM - viser fordelingen visuelt:
# Skal ligne en klokke hvis normalfordelt

ggplot(Berg,aes(x=birthweight))+
  geom_histogram(color="black",fill="lightblue",bins=15)+
  facet_wrap(~Group)+
  ggtitle("Histogram for hver gruppe")


# I kan også lave histogram vha. følgende kode:
hist(subset(Berg,Group==0)$birthweight,freq=FALSE)
curve(dnorm(x,mean(subset(Berg,Group==1)$birthweight)),
      col=2,lty=2,lwd=2,add=TRUE)


################################################################################
# Opgave 2.4. Hvilken af de to tests vurderer I er mest retvisende?
################################################################################

# t.test

################################################################################
# Opgave 3.1. Gennemfør chi-sqaured test for sammenhængen mellem kotikosteorider 
# og gruppe
################################################################################

# Undersøg data vha. CrossTable 
# KRYDSTABEL (CrossTable):
# Laver en tabel der viser antal og procenter

library(gmodels) 

CrossTable(
  Berg$corticosteroids,     # din variable (fx smoking)
  Berg$Group,       # din gruppe (fx Group)
  prop.c = TRUE,     # vis procent af kolonnetotal (dette vil du oftest bruge)
  prop.r = FALSE,    # vis procent af rækketotal
  prop.t = FALSE,    # vis procent af hele tabellen
  prop.chisq = FALSE # vis chi-square bidrag (skal være FALSE)
)

# FOR KATEGORISKE VARIABLE (ja/nej, ryger/ryger ikke osv.):

# Hvornår bruger vi CHI-SQUARED TEST?
# - Alle celler i krydstabellen har mindst 5 observationer

# Hvad er hypotesen? Hypotesen er, at der ikke er forskel i brugen af steorider
# i de to grupper.

chisq.test(Berg$corticosteroids, Berg$Group)

#chisq.test# p-val = 0.90,
# Altså: Vi har ikke evidens for, at der er forskel i brugen af steorider ml.
# de to grupper.

################################################################################
# Opgave 3.2. Gennemfør Fishers eksakt test for sammenhængen mellem kotikosteorider 
# og gruppe
################################################################################

# Hvornår bruges Fishers eksakt?
# FISHER'S EXACT TEST - brug når:
# - Nogle celler har mindre end 5 observationer

# Hvad er hypotesen? Hypotesen er, at der ikke er forskel i brugen af steorider
# i de to grupper.

fisher.test(Berg$corticosteroids, Berg$Group)

# p-val = 0.82,
# Altså: Vi har ikke evidens for, at der er forskel i brugen af steorider ml.
# de to grupper.

################################################################################
# Opgave 3.3. Hvilken af de to test vurderer I er mest retvisende?
################################################################################

# Chi-squared: kategorisk + nok observationer

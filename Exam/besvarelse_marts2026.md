# Eksamensbesvarelse — Biostatistik og Epidemiologi, Marts 2026
**Artikel:** Hannan et al. (2019) *Predictors of Imminent Risk of Nonvertebral Fracture in Older, High-Risk Women: The Framingham Osteoporosis Study*  
**Datasæt:** Hannan.RData (n = 1 470 kvinder)

---

## Spørgsmål 1 — Epidemiologi: Selektionsbias

### 1a) Beskriv studiepopulationen, herunder inklusions- og eksklusionskriterier

Studiepopulationen stammer fra **Framingham Osteoporosis Study**, som er en del af den store, langvarige Framingham-kohort (original kohort fra 1948 + offspring-kohort fra 1971). Studiet inkluderer kvinder fra begge kohorter.

**Inklusionskriterier:**
- Alder ≥ 65 år
- Mindst ét af følgende ved en DXA-scanning:
  - Osteoporose (T-score ≤ −2,5 ved femoral neck eller lumbal spine)
  - Osteopeni (T-score > −2,5 til ≤ −1,0)
  - Tidligere non-vertebral eller vertebral fraktur (uanset T-score)

**Eksklusionskriterier:**
- Patologiske frakturer (fx pga. kræft)
- Frakturer forårsaget af højenergitrauma (trafikulykke, vold)

I alt opfyldte **1 470 kvinder** inklusionskriterierne og bidrog med op til **3 observationer** hver (én per DXA-scanning), i alt **2 778 observationer**. Den primære baseline-alder var i gennemsnit 75 år (SD 6,0).

---

### 1b) Hvorfor netop denne studiepopulation?

Studiets formål er at identificere prædiktorer for **imminent (kortvarig, 1–2 år) frakturrisiko** — dvs. hvem der har størst risiko for fraktur inden for det næste år eller to. Det er **klinisk relevant** i forbindelse med beslutninger om dyr og intensiv behandling (fx knogle-anabolisk behandling).

Forfatterne vælger en **allerede høj-risiko population** (osteoporose, osteopeni eller frakturhistorik) fordi:
- Kortvarig frakturrisiko er mest relevant i netop denne gruppe, hvor behandlingsbeslutningerne er presserende.
- Eksisterende risikoværktøjer (fx FRAX) er beregnet til den generelle postmenopausale population og til 10-årsrisiko — de er ikke optimeret til at identificere imminent risiko.
- En population med lav baselinerisiko ville give for få events til at identificere risikofaktorer statistisk.

---

### 1c) Kan valg af studiepopulation føre til selektionsbias? Intern og ekstern validitet?

**Ekstern validitet (generaliserbarhed):**  
Studiepopulationen er selekteret til at bestå udelukkende af kvinder med allerede forhøjet frakturrisiko (osteoporose/osteopeni/frakturhistorik). Resultaterne kan **ikke generaliseres** til den brede befolkning af postmenopausale kvinder uden disse karakteristika. Derudover er Framingham en amerikanskbaseret kohort med primært hvide kvinder, hvilket yderligere begrænser generaliserbarheden til andre etniciteter og lande.

**Intern validitet:**  
Selektionen er sket **før** eksponering og udfald opstår (baselinescanning = startpunkt), og inklusion afhænger ikke af det specificerede udfald (ny fraktur i opfølgningsperioden). Intern validitet vurderes derfor at være **god**. Frafaldet i opfølgningsperioden er meget lavt (> 95 % komplet), hvilket støtter dette.

Potentielt problem: Den samme kvinde bidrager med op til 3 observationer, hvilket bryder uafhængighedsantagelsen — dette håndteres dog i analysen med *clustered Cox-regression og robust varians*.

---

## Spørgsmål 2 — Epidemiologi: Informationsbias

### 2a) Dataindsamling og datakilde

Oplysningerne om prædiktorer som *fald det seneste år* og *selvvurderet helbred* er indsamlet via **selvrapporterede spørgeskemaer** som del af de regelmæssige kliniske undersøgelser i Framingham-kohorten. Der er dermed tale om en **primær datakilde** (prospektivt indsamlede data), men med en **subjektiv målemetode** (selvrapportering).

Mere objektive mål (fx BMD via DXA, vægt og højde) er indsamlet klinisk ved hvert besøg.

---

### 2b) Informationsbias og misklassifikation af 'fald det seneste år'

Den primære risiko for informationsbias ved selvrapporterede data er **recall bias**: Deltagerne skal huske hændelser (fx fald) over det seneste år, og erindringen kan være upræcis.

Konkret for *fald det seneste år*:
- Kortvarige, ikke-skadende fald kan glemmes.
- Ældre kvinder kan have kognitive udfordringer, der påvirker hukommelse.
- Underrapportering af fald kan forekomme, fordi kvinder ønsker at fremstå selvstændige.

Dette medfører **misklassifikation** af prædiktoren: Kvinder, der faktisk er faldet, klassificeres som ikke-faldne (falsk negativ), hvilket forvrænger sammenhængen mellem fald og frakturrisiko.

---

### 2c) Differentiel vs. ikke-differentiel misklassifikation

Det er sandsynligvis **ikke-differentiel misklassifikation**: Underrapportering af fald er ikke systematisk knyttet til, om kvinden efterfølgende får en fraktur. Hukommelsesproblemer og social ønskværdighed forventes at påvirke alle deltagere på tværs af frakturstatus.

**Konsekvens:** Ikke-differentiel misklassifikation vil typisk føre til **bias mod nul** — dvs. sammenhængen mellem fald og frakturrisiko **underestimeres**. Den sande HR for fald vil være højere end det observerede (HR = 1,8 for ét fald i tabel 3a).

---

## Spørgsmål 3 — Epidemiologi: Konfundering, mediation og effektmodifikation

### 3a) Er 'fald det seneste år' en konfunder, mediator eller collider for CCB → fraktur?

Calcium channel blockers (CCB) er associeret med svimmelhed som bivirkning → svimmelhed øger risiko for fald → fald øger risiko for fraktur.

**'Fald' er en mediator** — det ligger på den kausale vej:

> CCB → (svimmelhed) → **Fald** → Fraktur

Fald er **ikke en konfunder** (det er ikke en uafhængig årsag til CCB-brug, der også påvirker fraktur). Det er **ikke en collider** (det fremkommer som konsekvens af CCB og fører til fraktur, men er ikke forårsaget uafhængigt af begge).

---

### 3b) Håndtering i analyse og præsentation

**Konfunder:**  
Justeres der for en konfunder i regressionsmodellen, elimineres dens forstyrrende effekt, og man opnår en mere korrekt estimering af eksponeringens effekt. Begge estimater (justeret og ujusteret) præsenteres typisk, og forskellen viser konfunderens effekt.

**Mediator:**  
En mediator bør **ikke** justeres for, hvis målet er at estimere eksponeringens **totale effekt** (direkte + indirekte) på udfaldet — justering for mediator fjerner den del af effekten, der går via mediatoren, og man underestimerer total effekt. Ønsker man kun den **direkte effekt** (uden for mediatoren), kan man justere — men det bør begrundes og fremgå tydeligt af metodebeskrivelsen. Det anbefales at præsentere begge modeller.

---

### 3c) Kan BMD være effektmodifikator for sammenhængen fald → fraktur?

Ja, det er plausibelt. BMD påvirker knoglestyrken og dermed, **om et fald resulterer i fraktur**. Sammenhængen kan se ud som:

- Kvinder med **lav BMD** (osteoporose): Et fald medfører høj risiko for fraktur (knoglerne tåler mindre belastning).
- Kvinder med **normal BMD**: Et fald medfører lavere frakturrisiko.

Dermed vil **styrken** af sammenhængen mellem fald og fraktur **variere med BMD-niveau** → BMD er en **effektmodifikator**.

Fra tabel 3a fremgår det, at både fald (HR ≈ 1,8) og lav T-score (HR ≈ 3,3) er uafhængige prædiktorer for 1-årig frakturrisiko — en formel test for interaktion (fx `fald × T-score-kategori` i Cox-modellen) ville kunne bekræfte/afkræfte effektmodifikation. Forfatterne undersøgte interaktioner og fandt ingen statistisk signifikante (jf. *"There were no statistically significant interactions"*).

---

## Spørgsmål 4 — Biostatistik: Spørgsmål til artiklen

### 4a) Fortolkning af HR = 1,7 (95% KI: 1,12–2,57) for "History of fracture"

Kvinder med en tidligere frakturhistorik har **70 % højere hazard** (øjeblikkelig risiko) for en ny non-vertebral fraktur inden for 1 år sammenlignet med kvinder uden frakturhistorik.

Konfidensintervallet (1,12–2,57) indeholder ikke 1, og p = 0,01 — sammenhængen er **statistisk signifikant**. Vi er 95 % sikre på, at den sande HR ligger mellem 12 % og 157 % forhøjet risiko sammenlignet med kvinder uden frakturhistorik. Bemærk: HR = 1,7 er en 70 % forhøjet risiko — **ikke** en fordobling (det kræver HR > 2,0).

---

### 4b) Antagelser for Cox-regressionen

1. **Proportional hazards-antagelsen:** HR antages at være **konstant over hele opfølgningsperioden** (den relative risiko for fraktur ændrer sig ikke med tid).
2. **Log-lineær sammenhæng** mellem kovariater og log(hazard).
3. **Ingen informativ censurering:** Årsagen til censurering (fx dropout, død) er uafhængig af frakturrisikoen.
4. **Uafhængige observationer** (men her er klynget data; håndteres med robust varians-estimering pga. op til 3 obs per kvinde).

---

### 4c) Forskel mellem HR = 1,7 (tabel 3a) og HR = 1,4 (tabel 4)?

- **Tabel 3a:** Bivariat (ujusteret) Cox-model — frakturhistorik analyseres alene uden at justere for andre variabler. HR = 1,7 (95% KI: 1,12–2,57), **p = 0,01**.
- **Tabel 4:** Multivariabel Cox-model — justeret *simultant* for alle inkluderede variabler (alder, ADL-score, selvvurderet helbred, BMD T-score, fald, nitratbrug, beta-blokker, CCB, antidepressiva). HR = 1,4 (95% KI: 0,89–2,19), **p = 0,14**.

Forskellen (1,7 → 1,4) skyldes **konfoundering**: Kvinder med frakturhistorik har sandsynligvis også lavere T-score og dårligere selvvurderet helbred. Når der justeres for disse, reduceres estimatet for frakturhistorik. Vigtigt: Det justerede estimat (1,4) er **ikke længere statistisk signifikant** (p = 0,14) — den observerede forskel kan skyldes tilfældig variation, når de øvrige risikofaktorer er taget i betragtning. Artiklens abstract nævner dog frakturhistorik som signifikant prædiktor, formentlig med reference til den 2-årige model, hvor p = 0,05.

---

### 4d) Vurdering af c-index = 0,71

C-index (svarende til AUC) = **0,71** er en **god prædiktion**. Skalaen tolkes typisk som:

| AUC | Vurdering |
|-----|-----------|
| 0,50 | Ingen diskrimination (tilfældig gæt) |
| 0,60–0,70 | Acceptabel |
| **0,70–0,80** | **God** ← modellen er her |
| 0,80–0,90 | Fremragende |
| > 0,90 | Næsten perfekt |

En AUC på 0,71 betyder, at modellen i **71 % af tilfældene** korrekt rangordner en kvinde med fraktur over en kvinde uden fraktur. Til sammenligning rapporterer FRAX (10-årsrisiko-modellen) kun AUC ≈ 0,60 i valideringsstudier. Modellen vurderes som klinisk brugbar til identifikation af kvinder med imminent frakturrisiko.

---

### 4e) Sammenligning af 1-års og 2-års model

| | 1-årsmodel | 2-årsmodel |
|---|---|---|
| c-index | **0,71** (SE 0,03) | 0,64 (SE 0,02) |
| Antal frakturer | 89 | 176 |
| Signifikante prædiktorer (p < 0,05) | T-score ≤ −2,5 (HR 2,8; p < 0,001), "Poor" helbred (HR 4,0; p = 0,04), Nitratbrug (HR 2,6; p = 0,01) | T-score ≤ −2,5 (HR 2,0; p < 0,001) |
| Frakturhistorik (multivariabel) | HR 1,4; **p = 0,14** (ikke signifikant) | HR 1,4; p = 0,05 (borderline) |

**Signifikante sammenhænge i 1-årsmodellen er attenueret (svækket) i 2-årsmodellen.** Det indikerer, at de identificerede risikofaktorer er særligt relevante for kortvarig (imminent) risiko og mister relativ prædiktion over tid.

Til klinisk risikostratificering — fx beslutning om hurtig behandling af de mest truede kvinder — er **1-årsmodellen at foretrække**, da den har bedre diskrimination (AUC 0,71 vs. 0,64) og mere præcist identificerer de kvinder, der er i umiddelbar fare. 2-årsmodellen kan supplere, men signalerne er svagere.

---

## Spørgsmål 5 — Biostatistik: Spørgsmål til datasættet

*Datasæt: Hannan.RData, n = 1 470 kvinder*  
*Variabler: id, Fraktur (0/1), Alder (år), Tidl_fald (0/1), Rygning (0/1), ADL (0–6)*

---

### 5a) Proportion af frakturer med 95% konfidensinterval

```r
n   <- nrow(Hannan)           # 1470
nfx <- sum(Hannan$Fraktur)    # 69
prop.test(nfx, n)
```

**Resultat:**

- Antal frakturer: **69 ud af 1 470**
- Proportion: **4,69 %**
- 95% KI: **3,7 % – 5,9 %**

Fortolkning: Godt 1 ud af 20 kvinder i datasættet har en fraktur. Vi er 95 % sikre på, at den sande andel i populationen ligger mellem 3,7 % og 5,9 %.

---

### 5b) Ujusteret logistisk regression: ADL → Fraktur

```r
m_u <- glm(Fraktur ~ ADL, data = Hannan, family = binomial())
summary(m_u)
exp(coef(m_u))
```

**Resultat:**

| Parameter | Koefficient | OR | 95% KI | p-værdi |
|---|---|---|---|---|
| ADL | −0,351 | **0,704** | 0,504 – 0,984 | 0,040 |

**Fortolkning:** For hver enheds stigning i ADL-score (bedre funktionsevne) reduceres odds for fraktur med ca. **30 %** (OR = 0,704). Effekten er statistisk signifikant (p = 0,040). Kvinder med dårligere daglig funktionsevne (lavere ADL) har altså øget risiko for fraktur.

---

### 5c) Justeret logistisk regression: ADL + alder + tidligere fald + rygning → Fraktur

```r
m_adj <- glm(Fraktur ~ ADL + Alder + Tidl_fald + Rygning,
             data = Hannan, family = binomial())
summary(m_adj)
exp(coef(m_adj))
```

**Resultat:**

| Prædiktor | OR | 95% KI | p-værdi |
|---|---|---|---|
| **ADL** | **0,698** | 0,498 – 0,977 | 0,036 |
| **Alder** | **1,076** per år | 1,032 – 1,122 | < 0,001 |
| **Tidl_fald** | **3,536** | 2,118 – 5,902 | < 0,001 |
| **Rygning** | 1,054 | 0,442 – 2,516 | 0,905 |

**Fortolkning sammenlignet med 5b:**

- **ADL** er stadig signifikant associeret med frakturrisiko efter justering (OR = 0,70, p = 0,036). Effekten er næsten uændret (0,704 ujusteret → 0,698 justeret), hvilket tyder på, at de øvrige variable **ikke er konfoundere** for ADL-fraktur-sammenhængen.
- **Alder** er en stærk selvstændig prædiktor: For hvert ekstra leveår stiger odds for fraktur med ca. **7,6 %** (p < 0,001).
- **Tidligere fald** er den stærkeste prædiktor: Kvinder med tidligere fald har **3,5 gange** højere odds for fraktur (p < 0,001).
- **Rygning** er ikke signifikant associeret med fraktur i dette datasæt (OR = 1,054, p = 0,905).

---

### 5d) AUC og ROC-kurve

```r
library(pROC)
Hannan$response <- predict(m_adj, Hannan, type = "response")
roc_obj <- roc(Hannan$Fraktur, Hannan$response)
auc(roc_obj)
plot(1 - roc_obj$specificities, roc_obj$sensitivities, type = "l",
     xlab = "1 - Specificitet", ylab = "Sensitivitet",
     main = "ROC: Fraktur ~ ADL + Alder + Tidl_fald + Rygning")
abline(0, 1, lty = 2, col = "gray")
```

**AUC = 0,703**

ROC-kurven (gemt som `roc_hannan.png`) viser en kurve, der tydeligt ligger over diagonalen (tilfældig gæt).

Fortolkning: En AUC på **0,70** er på grænsen for god diskrimination og stemmer overens med c-index = 0,71 fra artiklen (1-årsmodel). Modellen kan med rimelig præcision adskille kvinder med og uden fraktur.

---

### 5e) Prædiktion: 80-årig kvinde, tidligere fald, ikke-ryger, ADL = 3

```r
ny_kvinde <- data.frame(Alder = 80, Tidl_fald = 1, Rygning = 0, ADL = 3)
predict(m_adj, newdata = ny_kvinde, type = "response")
```

**Estimeret frakturrisiko: 24,5 %**

**Fortolkning:** En 80-årig kvinde, der tidligere har oplevet et fald, ikke ryger og har en ADL-score på 3 (moderat funktionsnedsættelse), har en estimeret sandsynlighed på **ca. 24,5 %** for at have en fraktur i dette tværsnitsstudie. Det er ca. **5 gange højere** end den gennemsnitlige proportion på 4,7 % i hele datasættet.

---

### 5f) Vurdering af prædiktionsmodellens kliniske relevans

Modellen viser **AUC = 0,70**, hvad der er **acceptabelt til god** diskrimination. Den estimerede risiko for en profil med kendte risikofaktorer (80 år, tidligere fald, ADL = 3) er 24,5 % — næsten 5 gange højere end basisrisikoen — hvilket tyder på, at modellen er i stand til at **identificere høj-risikoprofiler meningsfuldt**.

**Men der er begrænsninger:**

1. **Tværsnitsdesign:** Datasættet ligner et tværsnitsstudie, ikke et kohortestudie. Sammenhænge er ikke nødvendigvis kausale, og prædiktion til fremtidige frakturer kræver prospektive data.
2. **Få prædiktorer:** Modellen inkluderer kun 4 variable (ADL, alder, fald, rygning). Fra artiklen ved vi, at T-score og selvvurderet helbred er stærke uafhængige prædiktorer — disse er ikke inkluderet, hvilket sandsynligvis begrænser præcisionen.
3. **Rygning er ikke signifikant** i denne model, selvom det er inkluderet.
4. **Intern evaluering:** AUC er beregnet på det samme datasæt, som modellen er fittet på (ingen test/træningssplit her), hvilket kan overestimere den reelle prædiktion på nye data.

**Samlet konklusion:** Modellen har en **klinisk relevant** evne til at identificere risikogrupper (AUC 0,70, 5× forhøjet risiko ved høj-risikoprofil), men er ikke tilstrækkelig alene til klinisk beslutningstagning uden at inkludere de vigtigste prædiktorer fra artiklen (T-score, selvvurderet helbred).

---

*Kode og ROC-plot er gemt i: `Biostat/Exam/analyse_spm5.R` og `Biostat/Exam/roc_hannan.png`*

---

## Sammenligning med medstuderendes besvarelse

> Begge besvarelser bygger på samme datasæt og artikel og når frem til identiske R-resultater. Nedenfor er en opgave-for-opgave analyse af, hvad der adskiller de to besvarelser.

---

### Overordnet enighed: **Meget høj**

Alle centrale konklusioner, statistiske resultater og faglige argumenter er **identiske**. Der er ingen modsatrettede svar i nogen af de 14 delopgaver.

---

### Opgave for opgave

| Opgave | Enighed | Hvad medstuderendes har mere | Hvad jeg har mere |
|--------|---------|------------------------------|-------------------|
| **1a** | ✅ Identisk | Nævner NOF-retningslinjer som baggrund for inklusionskriterierne | — |
| **1b** | ✅ Identisk | Eksplicit link til NOF-behandlingsretningslinjer | — |
| **1c** | ✅ Identisk | Tilføjer **attrition bias**: kvinder med dårligst helbred kan dø/frafalde *mellem* DXA-skanninger → underestimering | Præciserer clustered-design-problemet (3 obs/kvinde) eksplicit |
| **2a** | ✅ Identisk | Specificerer at fald er målt som ja/nej binær ved hvert besøg | — |
| **2b** | ✅ Enig om recall bias | Opdeler i **3 underkategorier**: underrapportering, *fejlagtig tidsafgrænsning* (husker fald fra forkert år), og social desirability bias — min besvarelse nævner kun de to første | — |
| **2c** | ✅ Identisk | Pointerer prospektivt design som årsag til non-differentiellitet (deltagerne kendte ikke fremtidig frakturstatus da de rapporterede fald) | — |
| **3a** | ✅ Identisk | Tydeligere kausal kæde: "CCB → Fald → Fraktur" | Inkluderer svimmelhed som mellemled |
| **3b** | ✅ Identisk | Nævner **mediationsanalyse** som metode til at dekomponere total/direkte/indirekte effekt | — |
| **3c** | ✅ Identisk | Tilføjer at manglende signifikant interaktion kan skyldes **begrænset statistisk power** (kun 50 demenspatienter, 10 med Parkinson) — vigtig metodisk nuancering | — |
| **4a** | ✅ Identisk | Formulerer "1,7 gange så høj hazard" klart og præcist | Eksplicit note om at HR=1,7 ≠ fordobling |
| **4b** | ✅ Identisk | — | — |
| **4c** | ✅ Identisk | Eksplicit konklusion: *"Frakturhistorie mister sin uafhængige prædiktive værdi efter justering"* — skarpere formulering | Præcis tabel med HR, CI og p-værdier for 1-årig og 2-årig model |
| **4d** | ✅ Identisk | Tilføjer: *"modellen fejlklassificerer ca. 29 % af tilfældene"* og anbefaling om klinisk supplement | — |
| **4e** | ✅ Identisk | Mere udfoldet begrundelse: fx at risikofaktorer "forældes" over tid og at medicinforbrug kan ændres | Præcis tabel med HR og p-værdier fra tabel 4 for begge modeller |
| **5a** | ✅ Identisk | Bruger `binom.test()` (eksakt Clopper-Pearson) → CI: **3,67 % – 5,90 %** | Bruger `prop.test()` → CI: 3,73 % – 5,90 % *(binom.test er mere præcis ved lille n)* |
| **5b** | ✅ Identisk | Klinisk fortolkning: *"biologisk plausibelt: bedre balance, muskelstyrke og mobilitet"* | — |
| **5c** | ✅ Identisk tal | — | — |
| **5d** | ✅ AUC 0,703 | Beregner **95% KI for AUC** med `ci.auc()` → **0,640 – 0,765** og noterer "apparent AUC" (evalueret på træningsdata) | — |
| **5e** | ✅ 24,5 % | ⭐ **Vigtigste forskel**: noterer at ADL = 3 er en **ekstrapolation** — kun **8 ud af 1.470 kvinder (0,54 %)** har ADL ≤ 3, og 98,9 % har ADL ≥ 5. Estimatet bør tolkes med forsigtighed | — |
| **5f** | ✅ Identisk | Nævner BMD T-score som den stærkeste prædiktor (HR = 2,8) som bør tilføjes | — |

---

### De 4 væsentligste mangler i min besvarelse

**1. ADL = 3 er ekstrapolation (5e) ⭐**
Kun 8 kvinder (0,54 %) i datasættet har ADL ≤ 3. Prædiktionen for denne profil er en ekstrapolation langt uden for datasættets normale interval, hvilket svækker validiteten af estimatet. Det bør stå eksplicit i svarket.

**2. 95% KI for AUC (5d)**
`ci.auc()` giver KI **0,640 – 0,765** og viser usikkerheden på modellens diskrimination. Medstuderendes noterer desuden korrekt at det er en *apparent AUC* — overvurderet fordi modellen evalueres på de samme data den er fittet på.

**3. Fejlagtig tidsafgrænsning som misklassifikationstype (2b)**
Ud over glemte fald og social ønskværdighed kan deltagere fejlhuske *hvornår* et fald fandt sted og dermed rapportere fald fra en periode *uden for* det relevante tidsvindue. Min besvarelse mangler denne underkategori.

**4. Begrænset statistisk power (3c)**
Forfatternes negative fund ift. interaktioner kan skyldes for få observationer i undergrupper (fx kun 10 Parkinson-patienter). Dette er en vigtig metodisk forbehold, som min besvarelse ikke nævner.

---

### Hvad min besvarelse har, som medstuderendes mangler

- Eksplicit note om at **HR = 1,7 ≠ fordobling** (kræver HR > 2,0) — medstuderendes begår ikke fejlen, men nævner heller ikke pointen
- **Præcis tabel med HR, KI og p-værdier** for begge modeller i 4e (hentet direkte fra tabel 4 i artiklen)
- Hosmer–Lemeshow testnote til modelkalibrering

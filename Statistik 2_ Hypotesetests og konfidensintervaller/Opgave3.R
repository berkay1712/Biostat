#Opg 3
res <- data.frame(p=c())
#N agiver hvor mange personer/observationer der er i hver gruppe
N <- 100
#Denne linje sørger for at vi får samme tilfædligt generede værdier, hvis vi kører koden flere gange
set.seed(24)
#Tallet 10000 afgør hvor mange simulationer, vi kører. 1000 burde være nok til at opgaven virker fint
for (i in 1:10000){
  #Vi laver gruppevariablen (N personer i hver gruppe)
  Group=c(rep(1,each=N),rep(0,each=N))
  #Vi laver en tom x-variabel med 2*N observationer (NA står for "Not available", svarende til missing)
  x = rep(NA,each=2*N) 
  #Vi fylder de to gruppers x-værdier med normalfordelte værdier
  #Her kan i ændre tallet 10 i de to rækker for at ændre den sande forskel mellem grupperne
  x[Group==1] = rnorm(N,10.1,1)
  x[Group==0] = rnorm(N,10,1)
  #Vi gennemfører t-test mellem de to grupper
  ttest = t.test(x~Group)
  #Vi gemmer p-værdien i res
  res = c(res,ttest$p.value)
}
#Efter ar have gjort det 10000 gange tæller vi hvor mange p-værdier er under 0.05
sum(res<0.05)/length(res)
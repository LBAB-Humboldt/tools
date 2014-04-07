#Creates CSV files of occurrences for each species with a model (.RData)

load("C:/Users/jorge.velasquez/Google Drive/Bases/Ocurrencias/CO_GBIFSIB_23082013.RData")
load("C:/Users/jorge.velasquez/Google Drive/Bases/Ocurrencias/GEO_GBIFSIB_23082013.RData")
load("C:/Users/jorge.velasquez/Google Drive/Bases/Ocurrencias/GBIFSIB_23082013.RData")

df<-data.frame(id=paste0(db$db$collection,"-",db$db$catalogNumber),
               species=cofTable2$Nombre,
               speciesOriginal=db$db$species,
               x=db$db$lon,
               y=db$db$lat,
               locality=db$db$locality,
               adm2=db$db$adm2,
               adm1=db$db$adm1,
               alt=db$db$alt,
               earliestDateCollected=db$db$earliestDateCollected,
               institution=db$db$institution,
               collector=db$db$collector,
               basisOfRecordd=db$db$basisOfRecord)

rem=which(set16$bien_depto==1) #Seleccione registros con el departamento bien
df<-df[rem,]

#Quitar duplicados basados en los campos species, lat, lon

sub.df<-df[,c("species","x","y")]
idx<-duplicated(sub.df)
df<-df[!idx,]

#Create CSV
files<-list.files("W:/Modelos/20131122",pattern="*.RData$")
spNames<-sapply(strsplit(files,"\\."),"[[",1)
spNames2<-paste(sapply(strsplit(spNames,"_"),"[[",1),sapply(strsplit(spNames,"_"),"[[",2))

for (i in 1:length(spNames)){
  idx=which(df$species%in%spNames2[i])
  if(length(idx)==0){
    print(paste("model not available for ",spNames2[i]))
    next
  } else {
    print(spNames2[i])
    out.df<-df[idx,]
    write.csv(out.df,paste0("W:/Visor/20131122/CSV/",spNames[i],".csv"),row.names=F)
  }
}

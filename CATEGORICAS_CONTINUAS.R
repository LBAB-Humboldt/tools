##########################################################

#       SCRIPT VARIABLES CATEGORICAS A CONTINUAS      ####
#               Carolina Bello                          #
#               Junio 5 de 2013                         #
##########################################################

library("maptools")
library("raster")
library(ade4)
library(FactoMineR)
library(leaps)
memory.limit(size = 100000)
###########. 1. cargar cpas a convertir
setwd("~/SUELOS")
suelos=readShapePoly("suelos_project.shp")
eco=readShapePoly("eco_Project.shp" )
agro=readShapePoly("Agroecologia_project.shp")
grilla=raster("grilla.tif")
grilla=aggregate(grilla, fact=10,mean)

### llenar  cpa suelos con un id por categoria
idSuelos=as.data.frame(cbind(levels(suelos$SUELOS), id=as.numeric(1:length(levels(suelos$SUELOS)))))
suelos$id=NA
 for ( i in 1: nrow(suelos)) {
   if (!is.na(suelos$SUELOS[i])){
   suelos$id[i]=idSuelos$id[which(suelos$SUELOS[i]==idSuelos$V1)]
   }
}


### llenar  capa suelos con un id por paisaje
idPaisaje=as.data.frame(cbind(levels(agro$PAISAJE_), id=as.numeric(1:length(levels(agro$PAISAJE_)))))
agro$id_paisaje=NA
for ( i in 1: nrow(agro)) {
  if (!is.na(agro$PAISAJE_[i])){
    agro$id_paisaje[i]=idPaisaje$id[which(agro$PAISAJE_[i]==idPaisaje$V1)]
  }
}

### llenar  capa suelos con un id por relieve
idRelieve=as.data.frame(cbind(levels(agro$TIPO_DE_R_), id=as.numeric(1:length(levels(agro$TIPO_DE_R_)))))
agro$id_relieve=NA
for ( i in 1: nrow(agro)) {
  if (!is.na(agro$TIPO_DE_R_[i])){
    agro$id_relieve[i]=idRelieve$id[which(agro$TIPO_DE_R_[i]==idRelieve$V1)]
  }
}

### llenar  capa suelos con un id por material_parental 
idMatParental=as.data.frame(cbind(levels(agro$MATERIAL_P), id=as.numeric(1:length(levels(agro$MATERIAL_P)))))
agro$id_MP=NA
for ( i in 1: nrow(agro)) {
  if (!is.na(agro$MATERIAL_P[i])){
    agro$id_MP[i]=idMatParental$id[which(agro$MATERIAL_P[i]==idMatParental$V1)]
  }
}

### llenar  capa suelos con un id por pendiente 
idPendiente=as.data.frame(cbind(levels(agro$PENDIENTES), id=as.numeric(1:length(levels(agro$PENDIENTES)))))
agro$id_Pendiente=NA
for ( i in 1: nrow(agro)) {
  if (!is.na(agro$PENDIENTES[i])){
    agro$id_Pendiente[i]=idPendiente$id[which(agro$PENDIENTES[i]==idPendiente$V1)]
  }
}

### llenar  capa suelos con un id por erosion 
idErosion=as.data.frame(cbind(levels(agro$GRADO_DE_E), id=as.numeric(1:length(levels(agro$GRADO_DE_E)))))
agro$id_erosion=NA
for ( i in 1: nrow(agro)) {
  if (!is.na(agro$GRADO_DE_E[i])){
    agro$id_erosion[i]=idErosion$id[which(agro$GRADO_DE_E[i]==idErosion$V1)]
  }
}

### llenar  capa suelos con un id por profundidad 
idProfundidad=as.data.frame(cbind(levels(agro$PROFUNDIDA), id=as.numeric(1:length(levels(agro$PROFUNDIDA)))))
agro$id_profundidad=NA
for ( i in 1: nrow(agro)) {
  if (!is.na(agro$PROFUNDIDA[i])){
    agro$id_profundidad[i]=idProfundidad$id[which(agro$PROFUNDIDA[i]==idProfundidad$V1)]
  }
}

### llenar  capa suelos con un id por drenaje 
idDrenaje=as.data.frame(cbind(levels(agro$DRENAJE_NA), id=as.numeric(1:length(levels(agro$DRENAJE_NA)))))
agro$id_drenaje=NA
for ( i in 1: nrow(agro)) {
  if (!is.na(agro$DRENAJE_NA[i])){
    agro$id_drenaje[i]=idDrenaje$id[which(agro$DRENAJE_NA[i]==idDrenaje$V1)]
  }
}

### llenar  capa suelos con un id por fertilidad 
idFertilidad=as.data.frame(cbind(levels(agro$FERTILIDAD), id=as.numeric(1:length(levels(agro$FERTILIDAD)))))
agro$id_fertilidad=NA
for ( i in 1: nrow(agro)) {
  if (!is.na(agro$FERTILIDAD[i])){
    agro$id_fertilidad[i]=idFertilidad$id[which(agro$FERTILIDAD[i]==idFertilidad$V1)]
  }
}





## crear raster con id de suelos
suelosRas=rasterize(suelos,grilla, field="id")
## crear raster con id de geoforma
geoformaRas=rasterize(eco,grilla,field="IDGEO")
## crear raster con id de paisaje
paisajeRas=rasterize(agro,grilla,field="id_paisaje")
## crear raster con id de relieve
relieveRas=rasterize(agro,grilla,field="id_relieve")
## crear raster con id de material_parental 
MPRas=rasterize(agro,grilla,field="id_MP")
## crear raster con id de pendiente
pendienteRas=rasterize(agro,grilla,field="id_Pendiente")
## crear raster con id de erosion
erosionRas=rasterize(agro,grilla,field="id_erosion")
## crear raster con id de profundidad
profundidadRas=rasterize(agro,grilla,field="id_profundidad")
## crear raster con id de drenaje
drenajeRas=rasterize(agro,grilla,field="id_drenaje")
## crear raster con id de fertilidad
fertilidadRas=rasterize(agro,grilla,field="id_fertilidad")


grilla[1:ncell(grilla)]=1:ncell(grilla)


juntos=stack(grilla,suelosRas,geoformaRas,paisajeRas,relieveRas,MPRas,pendienteRas,erosionRas,profundidadRas,drenajeRas,fertilidadRas)
data=as.data.frame(juntos)

data2=na.omit(data)
names(data2)=c("grilla","suelos","geoforma","paisaje","relieve","MatP","pendiente","erosion","profundidad","drenaje","fertilidad")
row.names(data2)=data2[,1]
data2=data2[,-1]

data2$suelos=as.factor(data2$suelos)
data2$geoforma=as.factor(data2$geoforma)
data2$paisaje=as.factor(data2$paisaje)
data2$relieve=as.factor(data2$relieve)
data2$MatP=as.factor(data2$MatP)
data2$pendiente=as.factor(data2$pendiente)
data2$erosion=as.factor(data2$erosion)
data2$profundidad=as.factor(data2$profundidad)
data2$drenaje=as.factor(data2$drenaje)
data2$fertilidad=as.factor(data2$fertilidad)

#### AFM

grvar <- c(suelo=1,geo=5,fisicas=4)

afm <- MFA(data2,group=grvar,type=c("n","n","n"),name.group=names(grvar),graph =T)
afm$eig



##tomar cordenadas
coordenadas=individuos$coord

#generar rasters

dim1=grilla
dim1[as.numeric(row.names(coordenadas))]=coordenadas[,1]
dim1=mask(dim1,suelos)
dim1[dim1>max(coordenadas[,1])]=NA

dim2=grilla
dim2[as.numeric(row.names(coordenadas))]=coordenadas[,2]
dim2=mask(dim2,suelos)
dim2[dim2>max(coordenadas[,1])]=NA

dim3=grilla
dim3[as.numeric(row.names(coordenadas))]=coordenadas[,3]
dim3=mask(dim3,suelos)
dim3[dim3>max(coordenadas[,1])]=NA

dim4=grilla
dim4[as.numeric(row.names(coordenadas))]=coordenadas[,4]
dim4=mask(dim4,suelos)
dim4[dim4>max(coordenadas[,1])]=NA

dim5=grilla
dim5[as.numeric(row.names(coordenadas))]=coordenadas[,5]
dim5=mask(dim5,suelos)
dim5[dim5>max(coordenadas[,1])]=NA


plot(dim1)
plot(dim2)
plot(dim3)
plot(dim4)
plot(dim5)



dim2=grillplot(dim1)a
dim2[as.numeric(row.plot(dim1)names(coordenadas))]=coordenadas[,1]
dim2=mask(dim2,suelos)plot(dim1)
dim2[dim2>max(coordenadas[,1])]=NA

 # valores propios separados y conjuntos
a
attach(afm$separate.analyses)
names(suelo$eig) <- c("valor", "porcen", "acumul")
names(geo$eig) <- c("valor", "porcen", "acumul")
names(fisicas$eig) <- c("valor", "porcen", "acumul")

suelo$eig
geo$eig
fisicas$eig
par(mfrow=c(1,3))
barplot(suelo$eig[,1]);barplot(geo$eig[,1]);barplot(fisicas$eig[,1])
detach(afm$separate.analyses)
cbind(afm$group$coord,afm$group$contrib,afm$group$cos2,dis2=afm$group$dist2,
      afm$group$correlation)->salgru
round(salgru,2)
colSums(round(salgru,2))
# Lg y RV
round(cbind(afm$group$Lg,afm$group$RV),2) 
# ayuda para individuos
attach(afm$ind)
head(round(cbind(coord,contrib,cos2,within.inertia),2))
detach(afm$ind)
# ayuda para las variables
attach(afm$quanti.var)
round(cbind(coord,contrib,cos2,cor),2)
detach(afm$quanti.var)
# grafica para las variables
graphics.off()
plot(afm,choix="var", habillage = "group",las=1,title="")
# grafica para los caf?s
plot(afm,choix="ind",las=1,title="",habillage = "group")
# grafica superpuesta
plotMFApartial(afm,title="", habillage = "group")
#grafica de los grupos
plot(afm,choix="group",las=1,title="",habillage = "group")
#c?rculo de correlaciones con los ejes parciales
plot(afm,choix="axes",las=1,title="",habillage = "group")
# relaci?n de inertia entre / inercia total
afm$inertia.ratio




### ACM

perros.act <- data2[2]


perros.act[,1]<-as.factor(perros.act[,1])
# 1. TDC 
prueba=acm.disjonctif(perros.act) ##z
prueba2=matrix(NA,nrow(prueba),ncol(prueba))
 for ( i in 1 : ncol(prueba)){
   prueba2[,i]= as.character(prueba[,i])
 }
prueba2=as.data.frame(prueba2,stringsAsFactors =T)
# 3. tabla de Burt
burt=acm.burt(perros.act,perros.act)
# 4. ACM 
acm <- dudi.acm(prueba2,scannf=T,nf=3)

inertia.dudi(acm)


#cordenadas

cordenadas=acm$li

completa=cbind(perros.act, cordenadas)


#graficar  coordendas

grilla[1:ncell(grilla)]=1:ncell(grilla)
grilla[as.numeric(row.names(completa))]<-completa$Axis10

grilla[grilla>=4]<-NA

plot(grilla)


barplot(acm$eig,las=1);plot(acm$eig,las=1)


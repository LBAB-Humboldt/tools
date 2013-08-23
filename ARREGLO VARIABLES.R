library(raster)
library(sp)
library(maptools)
ambientales<-stack(list.files(pattern="*.asc$"))


nombres=list.files(pattern="*.tif$")

#MODELOS<-stack(nombres)# stack  sobreponer cpas solo para raster

mascara=raster(nombres[1])
ext=extent(col)
MODELOS2=mascara
for (i in 2:length(nombres)){
  especie=raster(nombres[[i]])
  #plot(especie)
  capa=resample(especie,mascara,method="ngb")
  capa=crop(capa,mascara)
  extent(capa)<-extent(mascara)
  #corte=mask(capa,col)
  #data=na.omit(as.data.frame(corte))
  #compara=compare(MODELOS,modelo,extent=T)
  MODELOS2=addLayer(MODELOS2,capa)
}

setwd("C:/Users/GIC 9/Google Drive/Scripts & Bdatos/predictors_CC/CSMK3/CSMK3_A2")

for ( k in 1:dim(MODELOS2)[3]){
  variable=MODELOS2[[k]]
  nombre=paste(names(variable),"asc",sep=".")
  writeRaster(variable,nombre, overwrite=TRUE, format="ascii" )
}

rios=MODELOS2[[23]]; rios[rios[,]>0]=1

RiosSA=readShapeLines("Rios_suramericaWGS84.shp")
RiosSAraster=rasterize(RiosSA,MODELOS2[[1]])
RiosSAraster[RiosSAraster[,]>0]=1


distRios<- mask(gridDistance(RiosSAraster,origin=1),rios) 
MODELOS2=stack(MODELOS2,distRios)

writeRaster(distRios,"distRios2.asc", overwrite=TRUE, format="ascii" )

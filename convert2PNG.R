library(raster)
setwd("W:/Modelos/20131122")
outKMZ="W:/Visor/20131122/KMZ"
outPNG="W:/Visor/20131122/PNG"

#Get the list of files to process
files<-list.files(getwd(),pattern="*.RData$")

spNames<-sapply(strsplit(files,"\\."),"[[",1)

files2process<-vector()
include=c("_min.tif","_min_cut.tif","_10p.tif","_10p_cut.tif",
          "_ess.tif","_ess_cut.tif","_mss.tif","_mss_cut.tif")
for(i in 1:length(spNames)){
  files2process<-c(files2process,paste(spNames[i],include,sep=""))
}

#Plotting parameters
tr=rgb(255,255,255,0,maxColorValue=255)
fill=rgb(231,58,0,maxColorValue=255)

#Start parallel plotting
sfInit(parallel=T,cpus=8)#Initialize nodes
sfExportAll() #Export vars to all the nodes
sfLibrary(raster)

#Run MAXENT models in parallel

sfClusterApplyLB(files2process,function(j){
  inRaster<-raster(files2process[j])
  name=strsplit(files2process[j],"[.]")[[1]][1]
  KML(inRaster,filename=paste0(outKMZ,"/",name,".kmz"),maxpixels=ncell(inRaster),col=c(tr,fill),overwrite=T)
  unzip(paste0(outKMZ,"/",name,".kmz"),exdir=outPNG)
  file.remove(paste0(outPNG,"/",name,".kml"))
})
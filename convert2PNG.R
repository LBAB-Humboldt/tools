#convert2PNG.R
#
#Converts all the tif files in a folder to KMZ and PNG
#as long as their filename matches any of the strings in the argument include. The color
#scheme is thought only for the binary color scheme used in BioModelos.
#
#Args:
# inFolder = folder that contains .tif files to convert
# include = character vector with the string patterns that filenames should match
# outPNG = folder where PNGs will be saved
# outPNG = folder where KMZs will be saved
#
#Usage:
#  include=c("_min.tif","_min_cut.tif","_10p.tif","_10p_cut.tif","_ess.tif","_ess_cut.tif","_mss.tif","_mss_cut.tif")
#  inFolder<-"W:/Modelos/20131122"
#  outKMZ="W:/Visor/20131122/KMZ"
#  outPNG="W:/Visor/20131122/PNG"
#  convert2PNG(inFolder,include,outKMZ,outPNG)
#
#Author: Jorge Velásquez
#Date: 26-02-2014

convert2PNG<-function(inFolder,include,outKMZ,outPNG){
  require(raster)
  require(snowfall)

  #Get the list of files to process
  files<-list.files(in.folder,pattern="*.RData$")
  spNames<-sapply(strsplit(files,"\\."),"[[",1)
  files2process<-vector()
  for(i in 1:length(spNames)){
    files2process<-c(files2process,paste(spNames[i],include,sep=""))
  }
  
  #Plotting parameters
  tr=rgb(255,255,255,0,maxColorValue=255)
  fill=rgb(193,140,40,maxColorValue=255)
  
  #Start parallel plotting
  sfInit(parallel=T,cpus=8)#Initialize nodes
  sfExportAll() #Export vars to all the nodes
  sfLibrary(raster)

  sfClusterApplyLB(files2process,function(j){
    inRaster<-raster(files2process[j])
    name=strsplit(files2process[j],"[.]")[[1]][1]
    KML(inRaster,filename=paste0(outKMZ,"/",name,".kmz"),maxpixels=ncell(inRaster),col=c(tr,fill),overwrite=T)
    unzip(paste0(outKMZ,"/",name,".kmz"),exdir=outPNG)
    file.remove(paste0(outPNG,"/",name,".kml"))
  })
}
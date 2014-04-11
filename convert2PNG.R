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
# outThumb = folder where thumbs will be saved
#
#Usage:
#  include=c("_min.tif","_min_cut.tif","_10p.tif","_10p_cut.tif","_ess.tif","_ess_cut.tif","_mss.tif","_mss_cut.tif")
#  inFolder<-"W:/Modelos/20131122"
#  outKMZ="C:/Visor/KMZ"
#  outPNG="C:/Visor/PNG"
#  outThumb="C:/Visor/thumbs"
#  convert2PNG(inFolder,include,outKMZ,outPNG)
#
#Author: Jorge Velásquez
#Date: 26-02-2014

convert2PNG<-function(inFolder,include,outKMZ,outPNG,outThumb){
  require(raster)
  require(snowfall)
  require(sp)
  require(rgdal)

  #Get the list of files to process
  files<-list.files("W:/Modelos/20131122",pattern="*.RData$")
  spNames<-sapply(strsplit(files,"\\."),"[[",1)
  files2process<-vector()
  for(i in 1:length(spNames)){
    files2process<-c(files2process,paste(spNames[i],include,sep=""))
  }
  
  #Plotting parameters
  tr=rgb(255,255,255,0,maxColorValue=255)
  fill=rgb(193,140,40,maxColorValue=255)
  
  #Create base rasters
  colombia<-readOGR(dsn="C:/Users/aves/Google Drive H/Google Drive/SDM_BaseFiles/tmp","COL_adm0")
  thumb_aoi<-readOGR(dsn="C:/Users/aves/Google Drive H/Google Drive/SDM_BaseFiles/tmp","thumbnail_area")
  dem<-raster("C:/Users/aves/Google Drive H/Google Drive/SDM_BaseFiles/tmp/alt.asc")
  dem1000_co <- crop((dem > 1000),thumb_aoi)
  mask.co <- rasterize(colombia,dem1000_co,field=1)
  dem1000_co <- dem1000_co * mask.co
  
  #Start parallel plotting
  sfInit(parallel=T,cpus=12)#Initialize nodes
  sfExportAll() #Export vars to all the nodes
  sfLibrary(raster)

  sfClusterApplyLB(files2process,function(j){
    #Plots for geovisor
    inRaster<-raster(paste0(inFolder,"/",j))*1
    name=strsplit(j,"[.]")[[1]][1]
    print(name)
    KML(inRaster,filename=paste0(outKMZ,"/",name,".kmz"),
        maxpixels=ncell(inRaster),col=c(tr,fill),overwrite=T)
    unzip(paste0(outKMZ,"/",name,".kmz"),exdir=outPNG)
    file.remove(paste0(outPNG,"/",name,".kml"))
    
    #Generate thumbnails
    in.raster_co <- crop(inRaster,thumb_aoi)*mask.co
    png(paste0(outThumb,"/",name,"_thumb.png"),width=145,height=205,units="px",type="cairo")
    op <- par(mar = rep(0, 4),bg=NA)
    image(dem1000_co,axes=F,xlab="",ylab="",col=c(tr,"grey90"))
    image(in.raster_co,col=c(tr,fill),axes=FALSE,add=T)
    plot(colombia,add=T,lwd=1,border="grey40",)
    dev.off()
    unlink(list.files(tempdir()),recursive=T)
  })
  sfStop()
}
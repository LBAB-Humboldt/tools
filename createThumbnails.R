require(raster)
require(sp)
require(rgdal)
#Load files
colombia<-readOGR(dsn="D:/Datos/BaseLayers","COL_adm0")
thumb_aoi<-readOGR(dsn="D:/Datos/BaseLayers","thumbnail_area")
dem<-raster("D:/Datos/worldclim/aoi/alt.asc")

#Color parameters
tr=rgb(255,255,255,0,maxColorValue=255)
fill=rgb(193,140,40,maxColorValue=255)

#Create base rasters
dem1000_co <- crop((dem > 1000),thumb_aoi)
mask.co <- rasterize(colombia,dem1000_co,field=1)
dem1000_co <- dem1000_co * mask.co
#Select files to convert and saving parameters
in.folder="W:/Modelos/20131122"
out.folder="W:/Visor/20131122/thumbs"
include=c("10p_cut.tif")

files<-list.files(in.folder,pattern="*.tif$")


sfInit(parallel=T,cpus=4)#Initialize nodes
sfExportAll() #Export vars to all the nodes
sfLibrary(raster)
sfLibrary(sp)
sfLibrary(rgdal)

sfClusterApplyLB(1:length(files),function(i){
  if(sum(sapply(include,grepl,files[i]))>0){
    print(files[i])
    in.raster <- raster(paste0(in.folder,"/",files[i]))
    in.raster_co <- crop(in.raster,thumb_aoi)*mask.co
    name=strsplit(files[i],"[.]")[[1]][1]
    #Begin PNG plot
    png(paste0(out.folder,"/",name,"_thumb.png"),width=145,height=205,units="px")
    op <- par(mar = rep(0, 4),bg=NA)
    image(dem1000_co,axes=F,xlab="",ylab="",col=c(tr,"grey90"))
    image(in.raster_co,col=c(tr,fill),axes=FALSE,add=T)
    plot(colombia,add=T,lwd=1,border="grey40",)
    dev.off()
  }
})
sfStop()



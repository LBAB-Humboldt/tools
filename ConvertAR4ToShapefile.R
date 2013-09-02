#ConvertAR4ToShapefile.R
#Convert 20 year climatologies from http://www.ipcc-data.org/ from netCDF to shapefile.
#Arguments: 
# file: filename of netCDF file
# file.dir: directory where the netCDF is located.
#Returns:
# A SpatialPointsDataFrame object with variable (e.g. tas, pr) values for each month
# in the "data" slot. It also writes the shapefile to the file.dir directory.
#Author: Jorge Velásquez
#Date: September 2, 2013

ConvertAR4ToShapefile<-function(file,file.dir){
  library(raster)
  library(rgdal)
  #This function corrects the longitude provided in IPCC AR4 datasets
  FlipLon <- function(x){
    if(x > 180){
      return(x - 360)
    } else {
      return(x)
    }
  }
  
  path = paste0(file.dir, "/", file)
  
  raster1 <- raster(path, 1)#Read the first band
  df <- as.data.frame(raster1, xy=T)
  
  latitudes <- unique(df$y)
  longitudes <- unique(df$x)
  
  xres = abs(longitudes[1] - longitudes[2])
  yres = abs(latitudes[1] - latitudes[2])
  
  df$x <- df$x+xres / 2
  df$y <- df$y+yres / 2
  df$nx <- sapply(df$x, FlipLon, USE.NAMES=F)
  
  out.file <- data.frame(x=df$nx, y=df$y)
  
  for(i in 1:12){
    tmp.raster <- raster(path, i) #Read band i of raster
    out.file[, paste0("month_", i)] <- as.data.frame(tmp.raster, xy=F)
  }
  
  new.shp<-SpatialPointsDataFrame(out.file[, c("x","y")],out.file[, 3:14], proj4string=CRS("+proj=longlat +ellps=WGS84"))
  writeOGR(new.shp, file.fir,
           strsplit("BCM2_SRA1B_1_tas-change_2011-2030.nc","\\.")[[1]][1],
           driver="ESRI Shapefile",
           check_exists=T,
           overwrite_layer=TRUE)
  return(new.shp)                               
}

#Example:
  tas_BCM2<-ConvertAR4ToShapefile("BCM2_SRA1B_1_tas-change_2011-2030.nc",
                                  "D:/Datos/IPCC/IPCC-Data/A1B_anomalies/tas/2011-2030")
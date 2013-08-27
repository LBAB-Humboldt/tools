#computeTSS.R
#Purpose: Compute the true skill statistic of a presence absence map (in raster format)
#based on xy coordinates of true presences and absences.

#Based on Allouche et al.(2006), Assessing the accuracy of species distribution 
#models: prevalence, kappa and the true skill statistic (TSS). 
#Journal of Applied Ecology, 43: 1223-1232.

#Args: inRaster - RasterLayer object with binary map to evaluate
#      pres - data frame with xy coordinates of presences
#      abs  - data frame with xy coordinates of absences
#Returns: True Skill Statistic value
#Date: August 27th, 2013

#Usage: computeTSS(model,pres,abs)

computeTSS<-function(inRaster,pres,abs){
  library(raster)
  #Remove duplicate records
  cellPres<-unique(cellFromXY(inRaster,pres))
  cellAbs<-unique(cellFromXY(inRaster,abs))
  
  #If a species is recorded as both present and absent in a cell,
  #the species is present in the cell
  cellAbs<-cellAbs[!(cellAbs%in%cellPres)]
  
  #Compute sensitivity and specificity
  presVals<-na.omit(extract(inRaster,cellPres))
  absVals<-na.omit(extract(inRaster,cellAbs))
  sens<-sum(presVals)/length(presVals)
  spec<-(length(absVals)-sum(absVals))/length(absVals)
  
  #Return TSS
  return(sens+spec-1)
}

# Introduction
This repository hosts miscellaneous functions used in LBAB analyses

# Recommendations
 * Save a function per file ending in .R (not .r). Functions should be named using verbs.
 * Follow [Google's Style guide for R] (http://google-styleguide.googlecode.com/svn/trunk/Rguide.xml)
 * Comment your code in English
 * Include a header at the beginning of your function file including:
  * Name of the function
  * Purpose: brief description of file's purpose
  * Args: description of arguments necessary to run the function
  * Returns: description of the object returned by the function
  * Author: who wrote the code? Give necessary credit when modifying someone else's code
  * Date: date the code was last modified
  * For example:

>
    #updateGSDB.R
    #Automatic download of all georeferenced GBIF and SIB data within a selected area
    #Arguments:
    # root: Character. Path to directory where downloaded files will be saved.
    # co: SpatialPolygonsDataFrame object with spatial extent of interest.
    # resume: Logical. Do you want to resume a previous download session?
    # resumeObj: List, including objects step1,step2 and errorIter. step1 and step2 are logicals that
    # indicate whether the download session should resume from step1 (downloading of GBIF data)or step2
    # (downloading of SIB data). errorIter is the iteration from which downloading should resume.
    #Returns: a list object with elements db (data frame with compiled GBIF and SIB data) and
    # isDuplicate (which indicates whether a GBIF record is already included in SIB).
    #Author: Jorge Velásquez (jvelasquez@humboldt.org.co)
    #Date: March 15, 2013
>
    #IUCN_consulta_individual_sp.R
    #Extract a groups species shape files and write them
    #Código para extraer los polígonos de una especie de los mpas experto de la IUCN.
    #Se desarrolla este código porque dichos mapa experto traen todos los polígonos de las
    #especies del grupo en una sola capa
    #Arguments: Se deben tener los shapes de grupos de la IUCN

    #Author: Ivan Gonzalez (igonzalez@humboldt.org.co)
    #Date: March 15, 2014
	
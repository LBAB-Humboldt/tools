""" 

    Código para extraer los polígonos de una especie de los mpas experto de la IUCN.
    Se desarrolla este código porque dichos mapa experto traen todos los polígonos de las
    especies del grupo en una sola capa.

"""

# Cargar bibliotecas
library(maptools)
library(rgdal)

# Asignar rutas de trabajo
setwd("C:/IAvH/Shapes grupos/IUCN_2014-03-28/Originales")

# Listar los grupos disponibles
(grupos <- gsub(".dbf","",list.files(pattern = ".dbf")))

# Escoger el grupo deseado. Indicar dentro del paréntesis la posición del grupo de la lista anterior
grupo <- readShapePoly(grupos[2])

# listar las especies disponibles
all.spp <- unique(grupo@data$binomial)

# Organizar las especies disponibles
(sort.spp <- sort(all.spp))

# Buscar la especie y anotar la posición en la que está
sort.spp[1900:2000]

# Identificar la sp. de interés y asignar la posición 
(sp <- sort.spp[1979])

# Extraer el poligono de la especie de interes
polygon <- grupo[which(grupo@data$binomial == sp),]

# Graficar poligono 
plot(polygon)

# Asignar carpeta donde se guardara el poligono
out.dir <- "C:/IAvH/Chicharrones/Chiguiro"

# Asignar nombre del archivo epsacial del poligono
name.outfile <- "Hydrochoeris isthmius"

# Guardar el archivo
writeOGR(obj = polygon, dsn = out.dir, layer = name.outfile, driver = "ESRI Shapefile")

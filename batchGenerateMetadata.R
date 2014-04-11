# getOption("encoding")
# options(encoding='ISO8859-1')
# options(encoding='UTF-8')

files=list.files("W:/Modelos/20131122/",pattern=".RData")
spNames<-gsub(".RData","",files)

options(encoding='ISO8859-1')
for(i in 1:length(spNames)){
  x<-readLines("~/GitHub/tools/generateMetadata.Rmd")
  y=gsub("Abarema_barbouriana",spNames[i],x)
  options()
  cat(y,file=paste0("~/tmp/",spNames[i],".Rmd"),sep="\n")
}


for(i in 1:length(spNames)){
  options(encoding='ISO8859-1')
  knit(paste0("~/tmp/",spNames[i],".Rmd"),paste0("~/tmp/md/",spNames[i],".md"))
  options(encoding="UTF-8")
  markdownToHTML(paste0("C:/Users/GIC 14/Documents/tmp/md/",spNames[i],".md"),
                 paste0("C:/Users/GIC 14/Documents/tmp/html/",spNames[i],".html"))
}
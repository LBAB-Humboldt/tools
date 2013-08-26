# Script name: fun_install_github.R
# Purpose: Source all functions from a GitHub repo
# Author: Jorge Velásquez
# Date: 23 August 2013
# Credit: modified from Kay Cichini on 
# http://www.r-bloggers.com/r-function-to-source-all-functions-from-a-github-repository/
# Packages needed: RCurl
# Arguments: 
#   repo: repository name
#   username: username of repository owner
#   branch: branch to copy files from

fun_install_github <- function (repo,username,branch){
 require(RCurl)
 message("\nInstalling ", repo, " R-functions from user ", username)
 name <- paste(username, "-", repo, sep = "")
 url <- paste("https://github.com/", username, "/", repo,
              sep = "")
 zip_url <- paste("https://github.com/", username,
                  "/", repo, "/archive/", branch,".zip",sep = "")
 print(zip_url)
 src <- file.path(tempdir(), paste(name, ".zip", sep = ""))
 content <- getBinaryURL(zip_url, .opts = list(followlocation = TRUE,
                                               ssl.verifypeer = FALSE))
 writeBin(content, src)
 on.exit(unlink(src), add = TRUE)
 repo_name <- basename(as.character(unzip(src, list = TRUE)$Name[1]))
 out_path <- file.path(tempdir(), repo_name)
 unzip(src, exdir = tempdir())
 on.exit(unlink(out_path), add = TRUE)
 fun.path <- dir(out_path, full.names = T,pattern="*.R")
 for (i in 1:length(fun.path)) {
   source(fun.path[i])
   cat("\n Sourcing function: ", dir(out_path,pattern="*.R")[i])}
 cat("\n")
}

# Example:
# fun_install_github("dataDownload","LBAB-Humboldt","master")
library(mets)
reload <- function(...) {
  mylib <- paste("mh2", .Platform$dynlib.ext, sep = "")
  if (is.loaded("MH"))
  dyn.unload(mylib)
  try(dyn.load(mylib))
  source("simphreg.R")
  source("weibullMLE.R")
  source("StEM.R")  
}
reload()

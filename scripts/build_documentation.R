stopifnot(file.exists("_quarto.yml"))
status <- system2("quarto",c("render"))
if(status != 0) stop("Quarto rendering failed")

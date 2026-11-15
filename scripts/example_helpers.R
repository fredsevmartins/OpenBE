# Sourced by standalone examples. No absolute machine-specific paths.
run_design <- function(id, example_dir) {
  library(OpenBE)
  meta <- read.csv(file.path(root,"inst/extdata/designs.csv"),stringsAsFactors=FALSE)
  z <- meta[meta$id==id, ]
  endpoints <- if (id==1) c("AUClast","Cmax") else z$endpoint
  for (endpoint in endpoints) {
    d <- example_dataset(id,if(id==1) endpoint else "AUClast")
    result <- if (id==1) analyze_2x2(d) else if(id<=11)
      analyze_replicate(d,missing="omit") else if(id==12) analyze_parallel(d) else analyze_williams(d)
    output <- file.path(example_dir,"outputs",endpoint)
    write_analysis(result,output)
    plot_analysis(result,file.path(output,"figures"),z$title,z$provenance,
                  paste0("examples/",z$directory,"/analysis.R"))
    write.csv(d,file.path(example_dir,paste0("dataset_",endpoint,".csv")),row.names=FALSE)
    print(result$summary)
  }
}

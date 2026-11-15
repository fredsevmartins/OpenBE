files<-list.files("man",pattern="[.]Rd$",full.names=TRUE)
text<-c("# API reference","","The installed R help is authoritative: `help(package='OpenBE')`.",
 "All public functions are documented. Generated from the same Rd files using `Rscript scripts/generate_api_reference.R`.","")
for(f in files) {
 doc<-capture.output(tools::Rd2txt(f,options=list(underline_titles=FALSE)))
 doc<-gsub(".\b","",doc)
 text<-c(text,paste0("## ",sub("[.]Rd$","",basename(f))),"","```text",doc,"```","")
}
writeLines(sub("[[:blank:]]+$", "", text),"docs/api-reference.md")

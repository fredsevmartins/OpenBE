# Retrieval is evidence of access, never automatic policy qualification.
library(OpenBE)
rules<-regulatory_rules()
dir.create("docs/regulatory/sources",recursive=TRUE,showWarnings=FALSE)
out<-lapply(seq_len(nrow(rules)),function(i) {
 r<-rules[i, ];path<-file.path("docs/regulatory/sources",paste0(r$rule_id,".html"))
 err<-NULL
 status<-tryCatch(utils::download.file(r$source_url,path,quiet=TRUE,method="libcurl"),
   error=function(e){err<<-conditionMessage(e);1L})
 ok<-status==0L && file.exists(path) && file.info(path)$size>0
 sha<-if(ok)digest::digest(file=path,algo="sha256") else NA_character_
 if(!ok && file.exists(path))unlink(path)
 data.frame(rule_id=r$rule_id,source_url=r$source_url,checked_utc=format(Sys.time(),tz="UTC",usetz=TRUE),
  status=if(ok)"RETRIEVED_NOT_REVIEWED" else "RETRIEVAL_BLOCKED",sha256=sha,
  reason=if(is.null(err))"Retrieved source still requires content, scope and effective-date review" else err)
})
write.csv(do.call(rbind,out),"docs/regulatory/source-access.csv",row.names=FALSE)
print(do.call(rbind,out)[c("rule_id","status")],row.names=FALSE)

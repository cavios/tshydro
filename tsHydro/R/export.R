export.tsHydro<-function(x, filename='ts.dat', exportPar=FALSE){
    time<-x$data$times
    wl<-x$pl$u
    wlsd<-x$plsd$u
    out<-cbind(time,wl,wlsd)
    file.create(filename)
    cat("Saving output to file: ", filename,"\n")
    cat("time\t wl\t wlsd\n", file=filename,append=TRUE)
    write.table(out,file=filename,append=TRUE, row.names=FALSE, quote=FALSE,col.names=FALSE)
    if(exportPar){
        Sigma<-as.numeric(exp(fit$opt$par[1]))
        SigmaRW<-as.numeric(exp(fit$opt$par[2]))
        outPar<-c(Sigma,SigmaRW)
        parFile<-'tsPar.dat'
        file.create(parFile)
        cat("Saving parameters to file: ", parFile,"\n")
        cat("Sigma\t SigmaRW\n", file=parFile,append=TRUE)
        cat(round(Sigma,3),"\t", round(SigmaRW,3),"\n", file=parFile,append=TRUE)
    }
}

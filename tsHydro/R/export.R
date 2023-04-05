#' Export output
#'
#' This function saves the predicted water levels to a file
#' @param x An object of class "tsHydro"
#' @param filename Name of output file
#' @param exportPar Logic variable to specify if the estimated model parameters are saved to a file "tsPar.dat".
#' @param addError To add error bars
#' @return The following elements
#' \itemize{
#' \item{oupfile("ts.dat") } A text file that contains three colunms;
#' "time", "wl", "wlsd". "time" is the time of each pass, where the water
#' level is estimated. "wl" is the estimated water level and "wlsd" is
#' the standard deviation of the estimated water level.
#' \item{"tspar.dat" } A text file that contains the optimized model parameters
#' }
#' @keywords plot
#' @export
#' @examples
#'data(lakelevels)
#' fit<-get.TS(lakelevels)
#' export.tsHydro(fit,file="myTS.dat",exportPar=TRUE)
#'

export.tsHydro<-function(x, filename='ts.dat', exportPar=FALSE){
    time<-x$obstimes
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

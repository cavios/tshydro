summary.tsHydro <- function(x){
	npar <- length(x$opt$par)
	logLik <- x$opt$objective
	conv <- x$opt$convergence == 0
        Sigma<-as.numeric(exp(fit$opt$par[1]))
        SigmaRW<-as.numeric(exp(fit$opt$par[2]))
	#res<-list(numpar = npar,
	#	nlogLik = logLik,
	#	converged = conv,
        cat("\n-------------------------\n")
	cat("Summary for get.TS\n")
        cat("-------------------------\n")
	cat(paste(ifelse(conv,"Converged","Not converged"),"with a negative log likelihood of",round(logLik,3),"\n\n"))
	cat(paste("Number of parameters:",npar,"\n\n"))
        cat(paste("Par 1: Sigma = ",round(Sigma,3),"\n\n"))
        cat(paste("Par 2: Sigma RW = ",round(SigmaRW,3),"\n\n"))
        
}

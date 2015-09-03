get.TS <-
function(dat, init.logsigmarw=0, init.logSigma=10, init.logit=log(0.3/(1-0.3)), estP=FALSE){

  data <- list(
    height=dat$height,
    times=unique(dat$time),
    timeidx=as.integer(dat$track)
  )
  
  parameters <- list(
    logSigma=init.logSigma,
    logSigmaRW=init.logsigmarw,
    logitp=init.logit,
    u=0*data$times
    )

  obj <- MakeADFun(data,parameters,random="u",DLL="tsHydro", map=list(logitp=factor(ifelse(estP,1,NA))))
  
  opt<-nlminb(obj$par,obj$fn,obj$gr)

  pl <- obj$env$parList()
  rep<-sdreport(obj, getJointPrecision=TRUE)
  allsd<-sqrt(diag(solve(rep$jointPrecision)))
  plsd <- obj$env$parList(par=allsd)

  ret<-list(pl=pl,plsd=plsd, data=data, opt=opt, obj=obj)
  class(ret)<-"tsHydro"
  return(ret)
}

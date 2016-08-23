get.TS <-
function(dat, init.logsigmarw=0, init.logSigma=10, init.logit=log(0.3/(1-0.3)), estP=FALSE, weights=rep(1,nrow(dat))){
  sorttime<-sort(unique(dat$time))

  o<-order(dat$track)
  dat<-dat[o,]

  obsfrom=sapply(unique(dat$track), function(i)min(which(dat$track==i)))-1
  obsto=sapply(unique(dat$track), function(i)max(which(dat$track==i)))-1
  obsn=obsto-obsfrom+1
  
  data <- list(
    height=dat$height,
    times=sorttime,
    timeidx=match(dat$time, sorttime),
    trackinfo=cbind(obsfrom,obsto,obsn),
    weights=weights[o]  
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

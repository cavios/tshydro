get.TS <-
function(dat, init.logsigmarw=0, init.logSigma=10, init.logit=log(0.3/(1-0.3)), priorHeight=numeric(0), priorSd=numeric(0), estP=FALSE, weights=rep(1,nrow(dat))){
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
    weights=weights[o],
    priorHeight=priorHeight,
    priorSd=priorSd
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
  cov<-solve(rep$jointPrecision)
  nU<-length(pl$u)
  allsd<-sqrt(diag(cov))
  idx<-rownames(cov)=="u"
  cov<-cov[idx,idx]
  plsd <- obj$env$parList(par=allsd)
  W<-1/plsd$u^2
  W<-W/sum(W)
  aveH<-W%*%pl$u
  sdAveH<-sqrt(t(W)%*%cov%*%W)
  ret<-list(pl=pl,plsd=plsd, data=data, opt=opt, obj=obj, aveH=aveH, sdAveH=sdAveH)
  class(ret)<-"tsHydro"
  return(ret)
}

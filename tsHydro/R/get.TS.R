getSigmaInit<-function(id){
  if(is.null(id)){10}else{rep(10,length(unique(id)))}
}


get.TS <-function(dat, init.h=0,init.logsigmarw=0,
             init.logSigma=getSigmaInit(dat$satid),
             bias=rep(0,length(unique(dat$satid))-1),
             init.logit=log(0.3/(1-0.3)), priorHeight=numeric(0),
             priorSd=numeric(0),
             estP=FALSE,
             weights=rep(1,nrow(dat)),
             varPerTrack=FALSE,
             varPerQuality=FALSE,
             newdat=NULL,
             ...)
{
    if(is.null(dat$satid)) dat$satid<-rep(0,nrow(dat))
    if(is.null(dat$qf)) dat$qf<-rep(0,nrow(dat))
    sorttime<-sort(unique(c(dat$time, newdat$time)))

    o<-order(dat$track)
    dat<-dat[o,]

  obsfrom=sapply(unique(dat$track), function(i)min(which(dat$track==i)))-1
  obsto=sapply(unique(dat$track), function(i)max(which(dat$track==i)))-1
  obsn=obsto-obsfrom+1
  
  data <- list(
    height=dat$height,
    times=sorttime,
    timeidx=match(dat$time, sorttime),
    newtimeidx=match(newdat$time, sorttime),
    group=if(!is.null(newdat$group)){newdat$group}else{numeric(0)},
    trackinfo=cbind(obsfrom,obsto,obsn),
    satid=dat$satid,
    qfid=dat$qf,
    weights=weights[o],
    priorHeight=priorHeight,
    priorSd=priorSd,
    varPerTrack=ifelse(varPerTrack,1,0),
    varPerQuality=ifelse(varPerQuality,1,0),
    trackidx=as.integer(as.factor(dat$track))-1
 )
  if(varPerTrack){
      init.logSigma <- getSigmaInit(dat$track)
  }

  if(varPerQuality){
      init.logSigma <- getSigmaInit(dat$qf)
  }
  parameters <- list(
    logSigma=init.logSigma,
    logSigmaRW=init.logsigmarw,
    logitp=init.logit,
    u=rep(init.h,length(data$times)),
    bias=bias
    )

  obj <- MakeADFun(data,parameters,random="u",DLL="tsHydro", map=list(logitp=factor(ifelse(estP,1,NA)),...))
  
  opt<-nlminb(obj$par,obj$fn,obj$gr)

  rep<-sdreport(obj)
  pl<-as.list(rep, "Est")
  plsd<-as.list(rep, "Std")
  newdat$est<-pl$u[data$newtimeidx]
  newdat$sd<-plsd$u[data$newtimeidx]
  pl$u<-pl$u[unique(data$timeidx)]
  plsd$u<-plsd$u[unique(data$timeidx)]
  obstimes<-data$times[unique(data$timeidx)]
  groupAve<-data.frame(Est=as.list(rep, "Est", report=TRUE)$groupAve,
                       Std=as.list(rep, "Std", report=TRUE)$groupAve)  
  ret<-list(pl=pl,plsd=plsd, data=data, opt=opt, obj=obj, aveH=rep$value[names(rep$value)=="aveH"], sdAveH=rep$sd[names(rep$value)=="aveH"], newdat=newdat, obstimes=obstimes, groupAve=groupAve)
  class(ret)<-"tsHydro"
  return(ret)
}

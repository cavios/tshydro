getSigmaInit<-function(id){
  if(is.null(id)){10}else{rep(10,length(unique(id)))}
}

#' Reconstruct water level
#'
#' Estimate the model parameters and return the estimated water levels
#' @param dat A data.frame containing at least the columns: time, height, and track
#' @param init.h Initial value for the mean water levels. The default value is 0.
#' @param init.logsigmarw Initial value for the log of the standard deviation of the random walk 
#' @param exportPar Logic variable to specify if the estimated model parameters are saved to a file "tsPar.dat".
#' @param init.logSigma Initial value for the log of the standard deviation of the random walk 
#' @param bias Optional, vector of length N-1 with Initial values of the bias estimates, where N is the numbers of satellite missions used. To estimate the bias "dat" must have a column "satid" with the ids of the satellites for each observation, 0,1,2,3,..,N-1. The number of bias estimates is N-1. The bias estimates is w.r.t. the satellite with the largest id. If dat$satid is provided the observation standard deviation is estimated pr satellite   
#' @param init.logit Initial value for the log of the standard deviation of the observation noise
#' @param priorHeight ...
#' @param priorSd ...
#' @param estP A logic value \code{FALSE} if the outlier fraction is kept fixed at its initial value
#' @param weights Optional vector of weights. 
#' @param varPerTrack Optional, a logic value: If TRUE, an observation standard deviation is "logSigma" is estimated per track.  
#' @param varPerQuality Optional, a logic value: If TRUE, an observation standard deviation is "logSigma" is estimated per quality id. If this option is used "dat" must have a column named "qf"  
#' @param newdat Optional, a data frame which at least should include a column named "time", containing the time in decimal years where the modeled water level is predicted. newdat may also include a column named "group" with a group id for each observation. Groups could be based on month, years, or something else. If "group" is provided a average water level pr group is also provided    
#'@details The function can handle the observation based standard deviation in different ways; either pr satellite, pr track, or pr quality. However, these options cannot be used together. 
#' @return An object of class "tsHydro" with the following elements
#' \itemize{
#' \item{oupfile("ts.dat") } A text file that contains three colunms;
#' "time", "wl", "wlsd". "time" is the time of each pass, where the water
#' level is estimated. "wl" is the estimated water level and "wlsd" is
#' the standard deviation of the estimated water level.
#' \item{"tspar.dat" } A text file that contains the optimized model parameters
#' }
#' @keywords time series
#' @useDynLib tsHydro
#' @export
#' @examples
#'data(lakelevels)
#' fit<-get.TS(lakelevels)
#' 
#'
get.TS <-function(dat, init.h=0,init.logsigmarw=0,
             init.logSigma=getSigmaInit(dat$satid),
             bias=rep(0,length(unique(dat$satid))-1),
             init.logit=log(0.1/(1-0.1)), priorHeight=numeric(0),
             priorSd=numeric(0),
             estP=FALSE, silent=TRUE,
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

  obj <- TMB::MakeADFun(data,parameters,random="u",DLL="tsHydro", map=list(logitp=factor(ifelse(estP,1,NA)),...),silent=silent)
  
  opt<-nlminb(obj$par,obj$fn,obj$gr)

  rep<-TMB::sdreport(obj)
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

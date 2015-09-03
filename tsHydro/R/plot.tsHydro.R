plot.tsHydro <-
function(x,addRawDat=FALSE,addLine=FALSE,addError=FALSE,zoomOut=FALSE,...)
    {
        time<-x$data$times
        wl<-x$pl$u
        wlsd<-x$plsd$u
        delta<-(max(wl)-min(wl))*0.2
        plot(time,wl,xlab="time",ylab="Elevation",...)
        if(addRawDat){
            points(x$data$times[x$data$timeidx], x$data$height, pch=1, cex=1,col=gray(0.4))
            points(time,wl,...)
        }
        if(addLine)lines(time,wl,lty=2,...) 
        if(addError)arrows(time, wl-2*wlsd, time, wl+2*wlsd, length=0.05, angle=90, code=3,...)
        if(zoomOut){
             plot(x$data$times[x$data$timeidx], x$data$height, pch=1, cex=1,col=gray(0.4),xlab="time",ylab="Elevation")
             points(time,wl,...)

        }
         }


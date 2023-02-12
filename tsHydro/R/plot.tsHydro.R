
#' A Plot function
#'
#' Plot an object returned by the function get.TS()
#' @param x Object returned by get.TS()
#' @param addRawdat Adds the data, which the estimated water levels are based on 
#' @param addLine To add a line between the points that represents the estimated water levels. 
#' @param addError To add error bars 
#' @param zoomOut To zoom out. This option creates a plot which displays the range of the water level data.
#' @param lwd Line width
#' @param col Color
#' @param ... Additional argumants to plot
#' @keywords plot
#' @export
#' @examples
#' data(lakelevels)
#' fit<-get.TS(lakelevels)
#'#Plot with error bars
#' plot(fit,addError=TRUE,col='blue')
#' #plot that includes the water level data
#'#and displays the entire data range
#'plot(fit,zoomOut=TRUE,col='red')


plot.tsHydro <-
function(x,addRawDat=TRUE,addLine=TRUE,addError=FALSE,zoomOut=FALSE,lwd=4,col='blue',...)
    {
        time<-x$obstimes
        wl<-x$pl$u
        wlsd<-x$plsd$u
        delta<-(max(wl)-min(wl))*0.2
        plot(time,wl,xlab="time",ylab="Elevation",...)
        if(addRawDat){
            points(x$data$times[x$data$timeidx], x$data$height, pch=1, cex=1,col=gray(0.4))
            points(time,wl,...)
        }
        if(zoomOut){
             plot(x$data$times[x$data$timeidx], x$data$height, pch=1, cex=1,col=gray(0.4),xlab="time",ylab="Elevation")
             points(time,wl,...)

        }
        if(addLine)lines(time,wl,lty=2,lwd=lwd,col=col,...) 
        if(addError)arrows(time, wl-2*wlsd, time, wl+2*wlsd, length=0.05, angle=90, code=3,...)
    }


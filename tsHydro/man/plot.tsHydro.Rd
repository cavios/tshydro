\name{plot.tsHydro}
\alias{plot.tsHydro}
\title{Plotting of time series}
\description{Function for plotting the output of the class "tsHydro"}
\usage{
plot.tsHydro(x, addRawDat = TRUE, addLine = TRUE, addError = FALSE, zoomOut = FALSE,lwd=4,col='blue', ...)
}

\arguments{
  \item{x}{
Object of class "tsHydro"
}
  \item{addRawDat}{
To add the data, which the estimated water levels are based on 
}
  \item{addLine}{
To add a line between the points that represents the estimated water levels. 
}
  \item{addError}{
To add error bars 
}
  \item{zoomOut}{
To zoom out. This option creates a plot which displays the range of the
  water level data.
}
 \item{lwd}{
...
}
\item{col}{
...
}
 

  \item{\dots}{
other parameters to be passed through to plotting functions
}
}

\references{
my paper ....
}
\author{
Karina Nielsen
}
\seealso{
\code{\link{get.TS}}
}
\examples{
data(lakelevels)
fit<-get.TS(lakelevels)

#Plot with error bars
plot(fit,addError=TRUE,col='blue')
#plot that includes the water level data
#and displays the entire data range
plot(fit,zoomOut=TRUE,col='red')
} 


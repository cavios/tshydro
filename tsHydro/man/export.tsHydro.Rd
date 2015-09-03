\name{export.tsHydro}
\alias{export.tsHydro}

\title{
Export output
}
\description{
This function saves the predicted water levels to a file
}
\usage{
export.tsHydro(x, filename = "ts.dat", exportPar = FALSE)
}

\arguments{
  \item{x}{
An object of class "tsHydro"
}
  \item{filename}{
Name of output file
}
  \item{exportPar}{
Logic variable to specify if the estimated model parameters are saved to
  a file "tsPar.dat". 
}
}

\value{
\item{oupfile("ts.dat") }{A text file that contains three colunms;
  "time", "wl", "wlsd". "time" is the time of each pass, where the water
  level is estimated. "wl" is the estimated water level and "wlsd" is
  the standard deviation of the estimated water level.
  }
\item{"tspar.dat" }{A text file that contains the optimized model parameters}

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
export.tsHydro(fit,file="myTS.dat",exportPar=TRUE)
}
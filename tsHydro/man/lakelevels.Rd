\name{lakelevels}
\alias{lakelevels}
\docType{data}
\title{
lakelevels
}
\description{
The data set "lakelevels" originate from the ESA Radar altimeter
satellite CryoSat-2 and represent water levels for the lake Okeechobee, FL, US.

The water levels are relative to the EGM2008 geoid model.

The water levels have been extracted from LARS (Lars Advanced Retraking System) 
}
\usage{data(lakelevels)}
\format{
  A data frame with 5433 observations on the following 4 variables.
  \describe{
    \item{\code{height}}{a numeric vector}
    \item{\code{lake}}{a numeric vector}
    \item{\code{track}}{a numeric vector}
    \item{\code{time}}{a numeric vector}
  }
}
\details{
...
}
\source{
...
}
\references{
  CryoSat-2 data Handbook
  Lars data
}
\examples{
data(lakelevels)
## maybe str(lakelevels) ; plot(lakelevels) ...
}
\keyword{datasets}

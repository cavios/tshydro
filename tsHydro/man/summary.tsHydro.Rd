\name{summary.tsHydro}
\alias{summary.tsHydro}
\title{Summary
}
\description{
  The summary writes information regarding the fitting done
  in the function "get.TS"on the screen
}
\usage{
summary.tsHydro(x)
}
\arguments{
  \item{x}{
An object of class "tsHydro"
}
}
\details{
  Print out information about: convergent, number of parameters, and Parameter names and values
}
\references{
My paper ....
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
summary(fit)
}

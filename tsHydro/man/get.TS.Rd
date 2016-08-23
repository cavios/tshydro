\name{get.TS}
\alias{get.TS}
\title{
get.TS
}
\description{
Estimate the model parameters and return the estimated water levels
}
\usage{
get.TS(dat, init.logsigmarw = 0, init.logSigma = 10, init.logit = log(0.3/(1 - 0.3)), estP = FALSE, weights=rep(1,nrow(dat)))
}

\arguments{
  \item{dat}{The data.frame containing at least the columns
  \code{height}, \code{time}, and \code{track}
}
  \item{init.logsigmarw}{Initial value for the log of the standard
  deviation of the random walk 
}
  \item{init.logSigma}{
Initial value for the log of the standard
  deviation of the observation noise
}
  \item{init.logit}{
Initial value for the logit of the fraction of outliers 
}
  \item{estP}{
A logic value \code{FALSE} if the outlier fraction is kept fixed at its
  initial value
}
  \item{weights}{
Optional vector of weights. 
}
}
\details{
...
}
\value{
 An object of class tsHydro
}
\references{
my paper 
}
\author{
Karina Nielsen
}
\note{
...
}


\seealso{
...
}
\examples{
data(lakelevels)
get.TS(lakelevels)
}


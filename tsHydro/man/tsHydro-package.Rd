\name{tsHydro-package}
\alias{tsHydro-package}
\alias{tsHydro}
\docType{package}
\title{
Robust fit of lakelevels
}
\description{
This package estates robust water level time series for inland water
bodies, based on along-track measurement of the water level.      
}
\details{
Satellite altimetry measurement over inland water bodies may be
contaminated with signals from the surrounding land, which can lead to
erroneous water levels. It is therefore essential to take these
erroneous data into account when estimating the final time series of the
water level.

In this package the observations are described by a mixture between the
Cauchy and Gaussian distributions. The mixture distribution ensures that
the final estimates are not severely bias by erroneous data.

A state space model is used to construct the final times series, where the
process model is described by a random walk. This model-setup ensures
that the temporal correlation in the data is taken into account.   
  
This package depends on the R package TMB.

\tabular{ll}{
Package: \tab tsHydro\cr
Type: \tab Package\cr
Version: \tab 1.0\cr
Date: \tab 2015-08-12\cr
License: \tab GPL-2\cr
}
}
\author{
Karina Nielsen
}
\references{
Nielsen et al. 2015, Validation of CryoSat-2 SAR mode based lake
levels. Submitted to Remote Sensing of Environment.
}
\keyword{ package }
\seealso{\code{\link{get.TS}}, \code{\link{plot.tsHydro}},\code{\link{summary.tsHydro}},\code{\link{export.tsHydro}} 
}

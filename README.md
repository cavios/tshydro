# tshydro
R package that estimates water level time series from satellite altimetry data

## Installing the package

The package requires [`TMB`](http://www.tmb-project.org) to be installed.

To install the package from GitHub use

```
library(remotes)
install_github("cavios/tshydro/tsHydro")
```
Alternatively, it can be installed from r-universe by:
```R
install.packages('tsHydro',
                 repos=c(CRAN="https://cloud.r-project.org/",
		         tshydro='https://cavios.r-universe.dev'))
```








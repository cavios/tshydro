library(tsHydro)
data(namco)
fit<-get.TS(namco)
plot(fit)

fit<-get.TS(namco, varPerTrack=TRUE)

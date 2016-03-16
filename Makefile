R=R
# -> you can do    R=R-devel  make .

PACKAGE=tsHydro
VERSION=0.0.3
TARBALL=${PACKAGE}_${VERSION}.tar.gz
ZIPFILE=${PACKAGE}_${VERSION}.zip

CPP_SRC = $(PACKAGE)/src/*.cpp

all:
	make doc-update
	make build-package
	make install
	make pdf

#doc-update: $(PACKAGE)/R/*.R
#	echo "library(roxygen2);roxygenize(\"$(PACKAGE)\",roclets = c(\"collate\", \"rd\"))" | $(R) --slave
#	@touch doc-update

#namespace-update :: $(PACKAGE)/NAMESPACE
#$(PACKAGE)/NAMESPACE: $(PACKAGE)/R/*.R
#	echo "library(roxygen2);roxygenize(\"$(PACKAGE)\",roclets = c(\"namespace\"))" | $(R) --slave
#	sed -i -e "s/importFrom(lme4,sigma)/if(getRversion()>='3.3.0') importFrom(stats, sigma) else importFrom(lme4,sigma)/" $(PACKAGE)/NAMESPACE

build-package: $(TARBALL)
$(TARBALL): $(PACKAGE)/NAMESPACE $(CPP_SRC)
	$(R) CMD build --resave-data=no $(PACKAGE)

install: $(TARBALL)
	$(R) CMD INSTALL --preclean $(TARBALL)
	@touch install

## To enable quick compile, run from R:
##    library(TMB); precompile(flags="-O0 -g")
quick-install: $(PACKAGE)/src/tsHydro.so
	$(R) CMD INSTALL $(PACKAGE)

$(PACKAGE)/src/tsHydro.so: $(PACKAGE)/src/track.cpp
	cd $(PACKAGE)/src; echo "library(TMB); compile('track.cpp','-O0 -g')" | $(R) --slave
	cd $(PACKAGE)/src; mv track.so tsHydro.so

unexport TEXINPUTS
pdf: $(PACKAGE).pdf
$(PACKAGE).pdf: $(PACKAGE)/man/*.Rd
	rm -f $(PACKAGE).pdf
	$(R) CMD Rd2pdf --no-preview $(PACKAGE)

check:
	$(R) CMD check $(PACKAGE)

#quick-check: quick-install ex-test
#	echo "source('glmmTMB/tests/AAAtest-all.R', echo=TRUE)" | $(R) --slave



#unlock:
#	rm -rf `Rscript --vanilla -e 'writeLines(.Library)'`/00LOCK-glmmTMB
#               ------------------------------------------ = R's system library
#	rm -rf ${R_LIBS}/00LOCK-glmmTMB
##               ^^^^^^^ This only works if R_LIBS contains a single directory and the same that 'R CMD INSTALL' uses..

test: ex-test
ex-test:
	echo "library(tsHydro); example(get.TS)" | $(R) --slave


clean:
	\rm -f install doc-update

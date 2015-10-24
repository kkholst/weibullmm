CCACHE = ccache
CCACHE_DIR=/tmp/$(USER)/ccache
CXX := $(CCACHE) g++ 
R = R
RLIB = $(shell $(RSCRIPT) -e "cat(.libPaths()[1])")
RSCRIPT := $(R) --slave
RCPP := $(RLIB)/Rcpp
RCPPARMA := $(RLIB)/RcppArmadillo
UNAME_S := $(shell uname -s)
PKG_LIBS := -llapack -lblas -larpack
ifeq ($(UNAME_S),Darwin)
  PKG_LIBS := -framework Accelerate
endif
PKG_LIBS += $(EXTRA_LIB_FLAGS) -L$(RCPP)/libs -L$(RCPPARMA)/libs
PKG_CXXFLAGS = -I$(RCPP)/include -I$(RCPPARMA)/include -fpic -O2 -Wall -funwind-tables -fasynchronous-unwind-tables
export PKG_CXXFLAGS
export PKG_LIBS
# SRCS = 	$(foreach module,$(MODULES),$(patsubst %,$(TMP)/%.cpp,$(module)))

default: clean mh2
	@R --no-save < ex.R

mh2:
	$(RSCRIPT) CMD SHLIB -o $@.so $@.cpp $(PKG_LIBS) $(SRCS) $(PKG_LIBS)


x: mh2
	R --no-save < ex.R

.PHONY: a clean

clean: 
	@rm -f *.o *.so

leakfull:
	R -d "valgrind -v --tool=memcheck --leak-check=full" --vanilla < testleaks.R	

leak:
	$(MAKE) leakfull2 &> valgrind.out
##	R -d valgrind -v --vanilla < testleaks.R	


leakfull2:
	R -d "valgrind -v --tool=memcheck --leak-check=full" --vanilla < valgrind.R

leak2:
	R -d valgrind -v --vanilla < mhtest1.R	

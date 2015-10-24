#ifndef _MH2_H
#define _MH2_H

//#include <R.h>           //  Rprintf()
//#include <R_ext/Utils.h> //  user interrupts
//#include <Rdefines.h>
//#include <Rinternals.h>

#include <RcppArmadillo.h>
#include <iostream> 
#include <cmath>
#include <cstring>
#include <algorithm>

using namespace Rcpp;
using namespace std;
using namespace arma;

RcppExport SEXP MH(SEXP data,
		     SEXP cluster,
		   //		   SEXP init,
		     SEXP etainit,
		     SEXP Sigma,
		     SEXP modelpar, 
		     SEXP control);


RcppExport SEXP FastApprox(const SEXP a,
			   const SEXP t,
			   const SEXP z);


#endif /* _MH2_H */

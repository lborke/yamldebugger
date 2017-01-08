
### Matching lists & functions

#' Postprocessing for the data field \code{Published in} from the parsed YAML object.
#' NULL values are corrected to empty string. Further, a matching against the shortcut list is performed.
#'
#' @param publ_v data field \code{Published in} from the parsed YAML object
#'
#' @return The matched shortcut if such one is available in the \code{book_match_l} list otherwise the original string
#'
#' @examples
#' matchBook("statistics of financial markets i")
matchBook = function(publ_v) {

	if (is.null(publ_v)) {
		publ_v = "NA"
	}

	book_match_l = list("statistics of financial markets" = "SFE",
					"statistics of financial markets i" = "SFE",
					"applied multivariate statistical analysis" = "MVA",
					"statistics of financial markets : exercises and solutions" = "SFS",
					"basic elements of computational statistics" = "BCS",
					"nonparametric and semiparametric models" = "SPM",
					"statistical tools for finance and insurance" = "STF",
					"srm - stochastische risikomodellierung und statistische methoden" = "SRM",
					"an introduction to statistics with python" = "ISP",
					"univariate time series" = "RJMCMC",
					"spa - stochastic population analysis" = "SPA",
					"arr - academic rankings research" = "ARR",
					"xfg (3rd edition)" = "XFG",
					"applied quantitative finance" = "XFG",
					"applied quantitative finance (3rd edition)" = "XFG",
					"modern mathematical statistics : exercises and solutions" = "MSE",
					"time-varying hierarchical archimedean copulas using adaptively simulated critical values" = "TvHAC",
					"multivariate statistics: exercises and solutions" = "SMS"
					)

	b_match = publ_v
	b_test = tolower(b_match)

	if (b_test %in% names(book_match_l)) {
		b_match = book_match_l[[b_test]]
	}

	return(b_match)
}


#' Postprocessing for the data field \code{Published in} from the parsed YAML object.
#' NULL values are corrected to empty string. Further, a matching against the extension list is performed.
#'
#' @param publ_v data field \code{Published in} from the parsed YAML object
#'
#' @return The matched book extension if such one is available in the \code{book_match_l} list otherwise the original string
#'
#' @examples
#' matchBook("sfs")
expandBook = function(publ_v) {

	if (is.null(publ_v)) {
		publ_v = "NA"
	}

	book_match_l = list("sfs" = "Statistics of Financial Markets : Exercises and Solutions"
					)

	b_match = publ_v
	b_test = tolower(b_match)

	if (b_test %in% names(book_match_l)) {
		b_match = book_match_l[[b_test]]
	}

	return(b_match)
}

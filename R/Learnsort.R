# Code for interfacing and timing Learnsort
# (c) 2019 Dr. Jens Oehlschaegel
# All rights reserved
# Created: 2019-10-27

#' Learnsort
#'
#' Learned Sort, a model-enhanced sorting algorithm
#' that was published in 'The Case for a Learned Sorting Algorithm'
#'
#' Learned Sort (Learsort) is a novel specific sorting algorithm that
#' exploits the scale of the keys by 2-stage-projecting a learned
#' (linear-spline) CDF-function. In theory it is stable,
#' but this implementation is not: a) sorting of the spit-bucket was done with
#' std::sort, b) in the final leafes it seems to use a (synthetic) counting sort.
#'
#' See \code{\link[greeNsort]{algodb}} for the complete table of algorithms.
#'
#' @param x a double vector to be sorted
#' @param situation "insitu" will only allocate buffer memory and use the
#'   existing RAM for sorting, "exsitu" will allocate completely fresh RAM for
#'   data and buffer
#' @param method an attempt to classify the implementation,  "index" means the
#'   implementation rather indexes into arrays, "pointer" rather uses pointer
#'   arithmetic
#' @return a zero length logical vector with an attribute
#'   \code{\link[greeNsort]{perf}}, a named numeric vector with three elements
#'   \item{Memory \code{\link[greeNsort]{size}}}{the maximum memory used for
#'   execution (the size of data and buffer relative to the size of the data
#'   only)} \item{Runtime \code{\link[greeNsort]{secs}}}{the execution time
#'   measured in seconds} \item{Sustainability
#'   \code{\link[greeNsort]{sizesecs}}}{the integral of memory size over
#'   execution time where size is measured as number of elements}
#' @note The Code under the GPL-3-Licence is taken from
#'   \url{https://github.com/learnedsystems/LearnedSort}
#' @examples
#' n <- 2^10
#' x <- runif(n)
#' Learnsort(x)
#' x <- as.double(1:n)
#' Learnsort(x)
#' @export

Learnsort <- function(x
                        , situation=c("insitu","exsitu")
                        , method=c("pointer","index")
)
{
  if (!is.double(x))
    stop("only double vectors implemented")
  method <- match.arg(method)
  situation <- match.arg(situation)
  if (situation == 'insitu') {
    r <- Learnsort_insitu(x)$ret
  }else{
    r <- Learnsort_exsitu(x)$ret
  }
  retperf(r, "Learnsort")
}

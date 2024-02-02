# Code for interfacing and timing Pdqsort
# (c) 2019 Dr. Jens Oehlschaegel
# All rights reserved
# Created: 2019-10-27

#' Pdqsort
#'
#' Pattern-defeating quicksort (pdqsort) as implemented in C++ by Orson Peters
#' but NOT BRANCHLESS
#'
#' Pattern-defeating quicksort (pdqsort) is a novel sorting algorithm that
#' combines the fast average case of randomized quicksort with the fast worst
#' case of heapsort, while achieving linear time on inputs with certain
#' patterns. pdqsort is an extension and improvement of David Mussers introsort
#'
#' See \code{\link[greeNsort]{algodb}} for the complete table of algorithms.
#'
#' @param x a double vector to be sorted
#' @param situation "insitu" will only allocate buffer memory and use the
#'   existing RAM for sorting, "exsitu" will allocate completely fresh RAM for
#'   data abnd buffer
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
#' @note The Code under the zlib-Licence is taken from
#'   \url{https://github.com/orlp/pdqsort}
#' @seealso \code{\link[greeNsort]{Omitsort}}
#' @examples
#' n <- 2^10
#' x <- runif(n)
#' Pdqsort(x)
#' x <- as.double(1:n)
#' Pdqsort(x)
#' @export

Pdqsort <- function(x
                        , situation=c("insitu","exsitu")
                        , method=c("pointer","index")
)
{
  if (!is.double(x))
    stop("only double vectors implemented")
  method <- match.arg(method)
  situation <- match.arg(situation)
  if (situation == 'insitu') {
    r <- Pdqsort_insitu(x)$ret
  }else{
    r <- Pdqsort_exsitu(x)$ret
  }
  retperf(r, "Pdqsort")
}

#' PdqsortB
#'
#' Pattern-defeating quicksort (pdqsort) as implemented in C++ by Orson Peters
#' WITH BRANCHLESS tuning
#'
#' Pattern-defeating quicksort (pdqsort) is a novel sorting algorithm that
#' combines the fast average case of randomized quicksort with the fast worst
#' case of heapsort, while achieving linear time on inputs with certain
#' patterns. pdqsort is an extension and improvement of David Mussers introsort
#'
#' See \code{\link[greeNsort]{algodb}} for the complete table of algorithms.
#'
#' @param x a double vector to be sorted
#' @param situation "insitu" will only allocate buffer memory and use the
#'   existing RAM for sorting, "exsitu" will allocate completely fresh RAM for
#'   data abnd buffer
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
#' @note The Code under the zlib-Licence is taken from
#'   \url{https://github.com/orlp/pdqsort}
#' @seealso \code{\link[greeNsort]{Omitsort}}
#' @examples
#' n <- 2^10
#' x <- runif(n)
#' Pdqsort(x)
#' x <- as.double(1:n)
#' Pdqsort(x)
#' @export

PdqsortB <- function(x
                    , situation=c("insitu","exsitu")
                    , method=c("pointer","index")
)
{
  if (!is.double(x))
    stop("only double vectors implemented")
  method <- match.arg(method)
  situation <- match.arg(situation)
  if (situation == 'insitu') {
    r <- PdqsortB_insitu(x)$ret
  }else{
    r <- PdqsortB_exsitu(x)$ret
  }
  retperf(r, "PdqsortB")
}


# Code for interfacing and timing Skasort
# (c) 2019 Dr. Jens Oehlschaegel
# All rights reserved
# Created: 2019-11-29


#' Skasort
#'
#' The non-inplace version of skasort by Malte Skarupke
#'
#' Skasort is a generalized Radixsort with 100\% buffer, the user interface
#' requries a key-extraction function, this supports a variety of data/object
#' types, however, Skasort is less general than a comparision sort.
#'
#' See \code{\link[greeNsort]{algodb}} for the complete table of algorithms.
#'
#' @param x a double vector to be sorted
#' @param situation "insitu" will only allocate buffer memory and use the existing RAM for sorting, "exsitu" will allocate completely fresh RAM for data abnd buffer
#' @param method an attempt to classify the implementation,  "index" means the implementation rather indexes into arrays, "pointer" rather uses pointer arithmetic
#' @return a zero length logical vector with an attribute \code{\link[greeNsort]{perf}}, a named numeric vector with three elements
#' \item{Memory \code{\link[greeNsort]{size}}}{the maximum memory used for execution (the size of data and buffer relative to the size of the data only)}
#' \item{Runtime \code{\link[greeNsort]{secs}}}{the execution time measured in seconds}
#' \item{Sustainability \code{\link[greeNsort]{sizesecs}}}{the integral of memory size over execution time where size is measured as number of elements}
#' @note The Code under the Boost-Licence is taken from \url{https://github.com/skarupke/ska_sort}
#' @seealso
#' #' \code{\link{ISkasort}}
#' @examples
#' n <- 2^10
#' x <- runif(n)
#' Skasort(x)
#' x <- as.double(1:n)
#' Skasort(x)
#' @export

Skasort <- function(x
                        , situation=c("insitu","exsitu")
                        , method=c("pointer","index")
)
{
  if (!is.double(x))
    stop("only double vectors implemented")
  method <- match.arg(method)
  situation <- match.arg(situation)
  if (situation == 'insitu') {
    r <- Skasort_insitu(x)$ret
  }else{
    r <- Skasort_exsitu(x)$ret
  }
  retperf(r, "Skasort")
}


#' ISkasort
#'
#' The inplace version of skasort by Malte Skarupke
#'
#' Skasort is a generalized Inplace Radixsort (with 0\% buffer), the user
#' interface requries a key-extraction function, this supports a variety of
#' data/object types, however, unlike \code{\link[greeNsort]{Grailsort}} Skasort
#' is not stable and less general than a comparision sort.
#'
#' See \code{\link[greeNsort]{algodb}} for the complete table of algorithms.
#'
#' @param x a double vector to be sorted
#' @param situation "insitu" will only allocate buffer memory and use the existing RAM for sorting, "exsitu" will allocate completely fresh RAM for data abnd buffer
#' @param method an attempt to classify the implementation,  "index" means the implementation rather indexes into arrays, "pointer" rather uses pointer arithmetic
#' @return a zero length logical vector with an attribute \code{\link[greeNsort]{perf}}, a named numeric vector with three elements
#' \item{Memory \code{\link[greeNsort]{size}}}{the maximum memory used for execution (the size of data and buffer relative to the size of the data only)}
#' \item{Runtime \code{\link[greeNsort]{secs}}}{the execution time measured in seconds}
#' \item{Sustainability \code{\link[greeNsort]{sizesecs}}}{the integral of memory size over execution time where size is measured as number of elements}
#' @note The Code under the Boost-Licence is taken from \url{https://github.com/skarupke/ska_sort}
#' @seealso
#' #' \code{\link{Skasort}}
#' @examples
#' n <- 2^10
#' x <- runif(n)
#' ISkasort(x)
#' x <- as.double(1:n)
#' ISkasort(x)
#' @export

ISkasort <- function(x
                    , situation=c("insitu","exsitu")
                    , method=c("pointer","index")
)
{
  if (!is.double(x))
    stop("only double vectors implemented")
  method <- match.arg(method)
  situation <- match.arg(situation)
  if (situation == 'insitu') {
    r <- ISkasort_insitu(x)$ret
  }else{
    r <- ISkasort_exsitu(x)$ret
  }
  retperf(r, "ISkasort")
}


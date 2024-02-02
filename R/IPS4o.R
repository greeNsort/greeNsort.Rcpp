# Code for interfacing and timing IPS4o
# (c) 2019 Dr. Jens Oehlschaegel
# All rights reserved
# Created: 2019-10-27

if (FALSE){
  for (n in 2^(seq(14, 8, -0.1)))
  for (r in 1:100){
    cat(n, r, "\n")
    set.seed(r)
    x <- as.double(sample(n))
    y <- x[]
    IPS4o(y)
    if (is.unsorted(y))
      stop("IPS4o unsorted")
    # y <- x[]
    # IS4o(y)
    # if (is.unsorted(y))
    #  stop("IS4o unsorted")
  }
}


#' IPS4o
#'
#' In-place Parallel Super Scalar Samplesort by Axtmann, Witt, Ferizovic, and Sanders
#'
#' A sorting algorithm that works in-place, executes in parallel, is
#' cache-efficient, avoids branch-mispredictions, and performs work O(n log n)
#' for arbitrary inputs with high probability. It is, however, NOT stable.
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
#' @note The Code under the BSD 2-Clause "Simplified" License is taken from
#'   \url{https://github.com/SaschaWitt/ips4o}
#' @seealso \code{\link[greeNsort]{Omitsort}}
#' @examples
#' n <- 2^10
#' x <- runif(n)
#' Pdqsort(x)
#' x <- as.double(1:n)
#' Pdqsort(x)
#' @export

IPS4o <- function(x
                        , situation=c("insitu","exsitu")
                        , method=c("pointer","index")
)
{
  # if (length(x) < 2^12)
  #   warning("IPS4o seems to fail to sort for small N")
  if (!is.double(x))
    stop("only double vectors implemented")
  method <- match.arg(method)
  situation <- match.arg(situation)
  if (situation == 'insitu') {
    r <- IPS4o_insitu(x)$ret
  }else{
    r <- IPS4o_exsitu(x)$ret
  }
  retperf(r, "IPS4o")
}

#' IS4o
#'
#' In-place (non-Parallel) Super Scalar Samplesort by Axtmann, Witt, Ferizovic, and Sanders
#'
#' A sorting algorithm that works in-place, here the single-threaded version, is
#' cache-efficient, avoids branch-mispredictions, and performs work O(n log n)
#' for arbitrary inputs with high probability.
#' It is, however, NOT stable.
#'
#' The authors claim that IS4o is up to 1.5 times faster than the closest
#' sequential competitor, BlockQuicksort, however, I found PdqBsort to be
#' faster.
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
#' @note The Code under the BSD 2-Clause "Simplified" License is taken from
#'   \url{https://github.com/SaschaWitt/ips4o}
#' @seealso \code{\link[greeNsort]{Omitsort}}
#' @examples
#' n <- 2^10
#' x <- runif(n)
#' Pdqsort(x)
#' x <- as.double(1:n)
#' Pdqsort(x)
#' @export

IS4o <- function(x
                    , situation=c("insitu","exsitu")
                    , method=c("pointer","index")
)
{
  # warning("IS4o fails to sort for an unknown reason")
  if (!is.double(x))
    stop("only double vectors implemented")
  method <- match.arg(method)
  situation <- match.arg(situation)
  if (situation == 'insitu') {
    r <- IS4o_insitu(x)$ret
  }else{
    r <- IS4o_exsitu(x)$ret
  }
  retperf(r, "IS4o")
}


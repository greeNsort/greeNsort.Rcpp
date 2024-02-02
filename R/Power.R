# Code for interfacing and timing Multiway Powersort by Gelling, Nebel & Wild (2022)
# (c) 2022 Dr. Jens Oehlschaegel
# All rights reserved
# Created: 2019-10-27

if (FALSE){
  #for (n in 2^(seq(14, 8, -0.1)))
  n <- 100
    for (r in 1:100){
      cat(n, r, "\n")
      set.seed(r)
      x <- as.double(sample(n))
      y <- x[]
      Peeksort(y)
      if (is.unsorted(y))
        stop("Peeksort unsorted")
  }
}



#' gfxTimsort
#'
#' Timsort in Gelling, Nebel, Smith & Wild 2022 \url{https://github.com/sebawild/powersort}
#'
#' Sebastian Wild took the implementation from \url{https://github.com/timsort/cpp-TimSort}
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

gfxTimsort <- function(x
                     , situation=c("insitu","exsitu")
                     , method=c("pointer","index")
)
{
  # warning("Peeksort fails to sort for an unknown reason")
  if (!is.double(x))
    stop("only double vectors implemented")
  method <- match.arg(method)
  situation <- match.arg(situation)
  if (situation == 'insitu') {
    r <- gfxTimsort_insitu(x)$ret
  }else{
    r <- gfxTimsort_exsitu(x)$ret
  }
  retperf(r, "gfxTimsort")
}



#' Peeksort
#'
#' Peeksort by Munro & Wild 2018 (COPY_SMALLER) from \url{https://github.com/sebawild/powersort}
#'
#' "We simulate cutting the probability in half by finding the run
#' boundary closest to the middle of the array. We can do that by simply
#' scanning left and right from the middle, until we find the first out-of-order
#' pair. With two additional indices passed down to the recursive calls, we can
#' avoid every scanning the same run twice in this “peeking-at-the-middle”
#' process.
#'
#' The awesome property of peeksort is that we do not have to detect the runs up
#' front; we can delay this step until we really need to know a boundary. In
#' case the input does not contain long runs, we do not much more work than
#' standard top-down mergesort."
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

Peeksort <- function(x
                    , situation=c("insitu","exsitu")
                    , method=c("pointer","index")
)
{
  # warning("Peeksort fails to sort for an unknown reason")
  if (!is.double(x))
    stop("only double vectors implemented")
  method <- match.arg(method)
  situation <- match.arg(situation)
  if (situation == 'insitu') {
    r <- Peeksort_insitu(x)$ret
  }else{
    r <- Peeksort_exsitu(x)$ret
  }
  retperf(r, "Peeksort")
}



#' Powersort
#'
#' Powersort by Munro & Wild 2018 (COPY_SMALLER) from \url{https://github.com/sebawild/powersort}
#'
#' "Powersort is much more similar to Timsort than to standard mergesort: it
#' proceeds in one pass from left to right over the input, and detects the next
#' run in the input. For each new run, we may decide to do some merges now, or
#' we delay them and keep the runs on a to-do-stack.
#'
#'While Timsort uses a rather complicated set of rules to decide what and when
#'to merge, powersort assigns each adjacent pair of runs an easy to compute
#'integer, its “power” and upon arrival of a new pair, simply executes all
#'postponed merges of higher power. Like peeksort, powersort provably adapts
#'optimally to existing runs (up to linear terms), something Timsort provably
#'does not."
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

Powersort <- function(x
                     , situation=c("insitu","exsitu")
                     , method=c("pointer","index")
)
{
  # warning("Powersort fails to sort for an unknown reason")
  if (!is.double(x))
    stop("only double vectors implemented")
  method <- match.arg(method)
  situation <- match.arg(situation)
  if (situation == 'insitu') {
    r <- Powersort_insitu(x)$ret
  }else{
    r <- Powersort_exsitu(x)$ret
  }
  retperf(r, "Powersort")
}

#' Powersort4
#'
#' 4-way Powersort in Gelling, Nebel, Smith & Wild 2022 (GENERAL_BY_STAGES) \url{https://github.com/sebawild/powersort}
#'
#' Sebastian Wild comments:
#' "4-way Powersort implementation based on William Cawley Gelling's code.in
#' long runs, we do not much more work than standard top-down mergesort."
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

Powersort4 <- function(x
                       , situation=c("insitu","exsitu")
                       , method=c("pointer","index")
)
{
  # warning("Powersort4 fails to sort for an unknown reason")
  if (!is.double(x))
    stop("only double vectors implemented")
  method <- match.arg(method)
  situation <- match.arg(situation)
  if (situation == 'insitu') {
    r <- Powersort4_insitu(x)$ret
  }else{
    r <- Powersort4_exsitu(x)$ret
  }
  retperf(r, "Powersort4")
}

#' Powersort4s
#'
#' 4-way Powersort with sentinel (Inf) in Gelling, Nebel, Smith & Wild 2022 (WILLEM_TUNED) \url{https://github.com/sebawild/powersort}
#'
#' Sebastian Wild comments:
#' "4-way Powersort implementation based on William Cawley Gelling's code.in
#' long runs, we do not much more work than standard top-down mergesort."
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

Powersort4s <- function(x
                       , situation=c("insitu","exsitu")
                       , method=c("pointer","index")
)
{
  # warning("Powersort4s fails to sort for an unknown reason")
  if (!is.double(x))
    stop("only double vectors implemented")
  method <- match.arg(method)
  situation <- match.arg(situation)
  if (situation == 'insitu') {
    r <- Powersort4s_insitu(x)$ret
  }else{
    r <- Powersort4s_exsitu(x)$ret
  }
  retperf(r, "Powersort4s")
}


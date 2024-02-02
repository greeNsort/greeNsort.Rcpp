# Code for interfacing and timing Timsort
# (c) 2019 Dr. Jens Oehlschaegel
# All rights reserved
# Created: 2019-10-27

#' Timsort
#'
#' The well-known algorithm of Tim Peters as implemented in C++ by Timothy Van Slyke
#'
#' Timsort is a Natural Mergesort heavily tuned to be (ON(N)) adaptive to
#' (perfectly) presorted data, however, Timsort is based on an inefficient merge
#' which moves data twice per merge, and the heavy tuning makes it slower when
#' it comes to sorting truly unsorted data.
#'
#' See \code{\link[greeNsort]{algodb}} for the complete table of algorithms.
#'
#' @param x a double vector to be sorted
#' @param situation "insitu" will only allocate buffer memory and use the existing RAM for sorting, "exsitu" will allocate completely fresh RAM for data abnd buffer
#' @param method an attempt to classify the implementation,  "index" means the implementation rather indexes into arrays, "pointer" rather uses pointer arithmetic
#' @return like \code{\link{retperf}}
#' @note The Code under the MIT-Licence is taken from \url{https://github.com/tvanslyke/timsort-cpp/}
#' @seealso
#' \code{\link[greeNsort]{Omitsort}}
#' @examples
#' n <- 2^10
#' x <- runif(n)
#' Timsort(x)
#' x <- as.double(1:n)
#' Timsort(x)
#' @export

Timsort <- function(x
                        , situation=c("insitu","exsitu")
                        , method=c("pointer","index")
)
{
  if (!is.double(x))
    stop("only double vectors implemented")
  method <- match.arg(method)
  situation <- match.arg(situation)
  if (situation == 'insitu') {
    r <- Timsort_insitu(x)$ret
  }else{
    r <- Timsort_exsitu(x)$ret
  }
  retperf(r, "Timsort")
}


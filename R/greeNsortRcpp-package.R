# greeNsortRcpp package documentation
# (c) 2019 Dr. Jens Oehlschlägel
# All rights reserved
# Created: 2019-10-27

#' greeNsortRcpp - greeNsort extensions implemented in C++ code
#'
#' The algorithms are implemented in C++-code and measure their runtime and memory consumption.
#' The 'exsitu' option emulates sorting from storage that cannot or shall not be used for sorting, hence fresh RAM is allocated for data and buffer,
#' the memory where the data resides is treated as immutable, the data is copied to the fresh RAM, then sorted and finally copied back.
#' The 'insitu' method assumes that the data reside in 100\% RAM and allocate only the buffer memory required for the respective algorithm.
#' Note that the sorting functions do not follow R's convention to let their input unchanged and return sorted data; the sorting functions in this package do modify their input vector and return performance data:
#'
#' @importFrom Rcpp evalCpp
#' @useDynLib greeNsortRcpp, .registration = TRUE
#' 
#' @return The algorithms return a zero length logical vector with an attribute \code{\link[greeNsort]{perf}}, a named numeric vector with three elements
#' \item{Memory \code{\link[greeNsort]{size}}}{the maximum memory used for execution (the size of data and buffer relative to the size of the data only)}
#' \item{Runtime \code{\link[greeNsort]{secs}}}{the execution time measured in seconds}
#' \item{Sustainability \code{\link[greeNsort]{sizesecs}}}{the integral of memory size over execution time where size is measured as number of elements}
#'
#'
#'@name greeNsortRcpp-package
NULL

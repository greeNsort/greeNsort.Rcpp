#' Make perf return value
#'
#' takes a return value with  and gives proper \code{\link{dim}} and \code{\link{dimnames}}
#'
#' @param x the return value of a C-level sorting call with an attribute `perf`
#' @param rowname the rowname to be used
#'
#' @return measurements as a matrix with columns
#' \item{n}{number of elements}
#' \item{b}{(average) number of bytes per element}
#' \item{p}{number of cores}
#' \item{size}{average \%RAM}
#' \item{secs}{runTime in Seconds}
#' \item{base}{base energy in Joules}
#' \item{core}{core energy in Joules}
#' \item{unco}{uncore (GPU) energy in Joules}
#' \item{dram}{DRAM energy in Joules}
#' @export
#'
retperf <- function(x, rowname=""){
  structure(x, dim=c(1, 10), dimnames=list(rowname, c("n","b","p","t","size","secs","base","core","unco","dram")))
}

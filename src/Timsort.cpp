/*
# Code for interfacing and timing Timsort
# (c) 2019 Dr. Jens Oehlschaegel
# All rights reserved
# Created: 2019-10-27
*/

#include <Rcpp.h>
#include "tim/timsort.h"
#include <chrono>

#include "lib_energy.h"

using namespace Rcpp;


// [[Rcpp::export]]
List Timsort_insitu(NumericVector & orig) {
  PCapEnergyT eLast;
  GreensortEnergyT eNext;
  int n=orig.size();
  NumericVector ret(10);
  eLast = GreensortEnergyNow();
  auto start = std::chrono::high_resolution_clock::now();
  tim::timsort(orig.begin(), orig.end(), std::less<>{});
  //STABLE_TEST_PSEUDO_ROUND - IS STABLE:  tim::timsort(orig.begin(), orig.end(), [](auto x, auto y){ return floor(x) < floor(y); });
  auto stop = std::chrono::high_resolution_clock::now();
  eNext = GreensortEnergyDelta(&eLast);
  auto diff = stop - start;
  ret[0] = n;
  ret[1] = 8;
  ret[2] = 1;
  ret[3] = 1;
  ret[4] = 1.5;
  ret[5] = std::chrono::duration <double, std::ratio<1,1>> (diff).count();
  ret[6] = eNext.base;
  ret[7] = eNext.core;
  ret[8] = eNext.unco;
  ret[9] = eNext.dram;
  return List::create(Named("ret") = ret);
}


// [[Rcpp::export]]
List Timsort_exsitu(NumericVector & orig) {
  PCapEnergyT eLast;
  GreensortEnergyT eNext;
  int i,n=orig.size();
  NumericVector ret(10);
  eLast = GreensortEnergyNow();
  auto start = std::chrono::high_resolution_clock::now();
  NumericVector aux(n);
  for (i=0;i<n;i++)
      aux[i] = orig[i];
  tim::timsort(aux.begin(), aux.end(), std::less<>{});
  for (i=0;i<n;i++)
      orig[i] = aux[i];
  auto stop = std::chrono::high_resolution_clock::now();
  eNext = GreensortEnergyDelta(&eLast);
  auto diff = stop - start;
  ret[0] = n;
  ret[1] = 8;
  ret[2] = 1;
  ret[3] = 1;
  ret[4] = 1.5;
  ret[5] = std::chrono::duration <double, std::ratio<1,1>> (diff).count();
  ret[6] = eNext.base;
  ret[7] = eNext.core;
  ret[8] = eNext.unco;
  ret[9] = eNext.dram;
  return List::create(Named("ret") = ret);
}

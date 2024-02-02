/*
# Code for interfacing and timing Skasort
# (c) 2019 Dr. Jens Oehlschaegel
# All rights reserved
# Created: 2019-11-29
*/


#include <Rcpp.h>
#include "ska/ska_sort.hpp"
#include <chrono>
#include "lib_energy.h"

using namespace Rcpp;

template<typename It, typename OutIt, typename ExtractKey>
bool radix_sort(It begin, It end, OutIt buffer_begin, ExtractKey && extract_key)
{
    return ska::RadixSorter<typename std::result_of<ExtractKey(decltype(*begin))>::type>::sort(begin, end, buffer_begin, extract_key);
}

template<typename It, typename OutIt>
bool radix_sort(It begin, It end, OutIt buffer_begin)
{
    return ska::RadixSorter<decltype(*begin)>::sort(begin, end, buffer_begin, ska::IdentityFunctor());
}


template<typename It, typename ExtractKey>
static void inplace_radix_sort(It begin, It end, ExtractKey && extract_key)
{
    ska::inplace_radix_sort<1, 1>(begin, end, extract_key);
}

template<typename It>
static void inplace_radix_sort(It begin, It end)
{
    inplace_radix_sort(begin, end, ska::IdentityFunctor());
}




// [[Rcpp::export]]
List Skasort_insitu(NumericVector & orig) {
  NumericVector ret(10);
  int n=orig.size();
  PCapEnergyT eLast;
  GreensortEnergyT eNext;
  eLast = GreensortEnergyNow();
  auto start = std::chrono::high_resolution_clock::now();
  NumericVector buf(n);
  bool which = radix_sort(orig.begin(), orig.end(), buf.begin());
  //STABLE_TEST_PSEUDO_ROUND: bool which = radix_sort(orig.begin(), orig.end(), buf.begin(), [](auto i){ return floor(i); });
  auto stop = std::chrono::high_resolution_clock::now();
  eNext = GreensortEnergyDelta(&eLast);
  auto diff = stop - start;
  ret[0] = n;
  ret[1] = 8;
  ret[2] = 1;
  ret[3] = 1;
  ret[4] = 2.0;
  ret[5] = std::chrono::duration <double, std::ratio<1,1>> (diff).count();
  ret[6] = eNext.base;
  ret[7] = eNext.core;
  ret[8] = eNext.unco;
  ret[9] = eNext.dram;
  return List::create(Named("ret") = ret);
}


// [[Rcpp::export]]
List Skasort_exsitu(NumericVector & orig) {
  int i,n=orig.size();
  NumericVector ret(10);
  PCapEnergyT eLast;
  GreensortEnergyT eNext;
  eLast = GreensortEnergyNow();
  auto start = std::chrono::high_resolution_clock::now();
  NumericVector aux(n);
  for (i=0;i<n;i++)
      aux[i] = orig[i];
  NumericVector buf(n);
  bool which = radix_sort(aux.begin(), aux.end(), buf.begin());
  for (i=0;i<n;i++)
      orig[i] = aux[i];
  auto stop = std::chrono::high_resolution_clock::now();
  eNext = GreensortEnergyDelta(&eLast);
  auto diff = stop - start;
  ret[0] = n;
  ret[1] = 8;
  ret[2] = 1;
  ret[3] = 1;
  ret[4] = 2.0;
  ret[5] = std::chrono::duration <double, std::ratio<1,1>> (diff).count();
  ret[6] = eNext.base;
  ret[7] = eNext.core;
  ret[8] = eNext.unco;
  ret[9] = eNext.dram;
  return List::create(Named("ret") = ret);
}



// [[Rcpp::export]]
List ISkasort_insitu(NumericVector & orig) {
  PCapEnergyT eLast;
  GreensortEnergyT eNext;
  int n=orig.size();
  NumericVector ret(10);
  eLast = GreensortEnergyNow();
  auto start = std::chrono::high_resolution_clock::now();
    inplace_radix_sort(orig.begin(), orig.end());
    //STABLE_TEST_PSEUDO_ROUND - IS STABLE: inplace_radix_sort(orig.begin(), orig.end(), [](auto i){ return floor(i); });
    auto stop = std::chrono::high_resolution_clock::now();
    eNext = GreensortEnergyDelta(&eLast);
    auto diff = stop - start;
    ret[0] = n;
    ret[1] = 8;
    ret[2] = 1;
    ret[3] = 1;
    ret[4] = 2.0;
    ret[5] = std::chrono::duration <double, std::ratio<1,1>> (diff).count();
    ret[6] = eNext.base;
    ret[7] = eNext.core;
    ret[8] = eNext.unco;
    ret[9] = eNext.dram;
    return List::create(Named("ret") = ret);
}


// [[Rcpp::export]]
List ISkasort_exsitu(NumericVector & orig) {
  int i,n=orig.size();
  NumericVector ret(10);
  PCapEnergyT eLast;
  GreensortEnergyT eNext;
  eLast = GreensortEnergyNow();
  auto start = std::chrono::high_resolution_clock::now();
  NumericVector aux(n);
  for (i=0;i<n;i++)
      aux[i] = orig[i];
  inplace_radix_sort(aux.begin(), aux.end());

  for (i=0;i<n;i++)
      orig[i] = aux[i];
  auto stop = std::chrono::high_resolution_clock::now();
  eNext = GreensortEnergyDelta(&eLast);
  auto diff = stop - start;
  ret[0] = n;
  ret[1] = 8;
  ret[2] = 1;
  ret[3] = 1;
  ret[4] = 2.0;
  ret[5] = std::chrono::duration <double, std::ratio<1,1>> (diff).count();
  ret[6] = eNext.base;
  ret[7] = eNext.core;
  ret[8] = eNext.unco;
  ret[9] = eNext.dram;
  return List::create(Named("ret") = ret);
}


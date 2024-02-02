/*
# Code for interfacing and timing Multiway Powersort by Gelling, Nebel & Wild (2022)
# (c) 2019 Dr. Jens Oehlschaegel
# All rights reserved
# Created: 2019-10-27
*/

// peeksort powersort stuff
#include "power/algorithms.h"
#include "power/inputs.h"
#include "power/welford.h"
#include "power/sorts/timsort.h"
#include "power/sorts/merging.h"
#include "power/sorts/merging_multiway.h"
#include "power/sorts/peeksort.h"
#include "power/sorts/powersort.h"
#include "power/sorts/powersort_4way.h"
//#include "power/datatypes.h"

// INSERTIONSORT_LIMIT from ordermerge.h
#define INSERTIONSORT_LIMIT 64

#define ONLYINCREASINGRUNS false
//#define ONLYINCREASINGRUNS true

// up to 50% buffer
#define MERGINGMETHOD COPY_SMALLER
// 100% buffer
//#define MERGINGMETHOD COPY_BOTH
// -- this is nongeneral and needs a +inf sentinel --
//#define MERGINGMETHOD COPY_BOTH_WITH_SENTINELS
// Weirdly the code has a decprecated Default GENERAL_INDICES

#define MERGING4WAYMETHOD GENERAL_BY_STAGES
//#define MERGING4WAYMETHOD GENERAL_BY_STAGES_SPLIT
// -- these are non-general and need a +inf sentinel --
//#define MERGING4WAYMETHOD WILLEM_TUNED
//#define MERGING4WAYMETHOD WILLEM_VALUES
//#define MERGING4WAYMETHOD WILLEM_WITH_INDICES

// greensort additions
#include <Rcpp.h>
#include <chrono>
#include "lib_energy.h"


using namespace Rcpp;


 // [[Rcpp::export]]
 List gfxTimsort_insitu(NumericVector & orig) {
   PCapEnergyT eLast;
   GreensortEnergyT eNext;
   int n=orig.size();
   NumericVector ret(10);
   eLast = GreensortEnergyNow();
   auto start = std::chrono::high_resolution_clock::now();
   gfx::timsort(orig.begin(), orig.end());
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
 List gfxTimsort_exsitu(NumericVector & orig) {
   PCapEnergyT eLast;
   GreensortEnergyT eNext;
   int i,n=orig.size();
   NumericVector ret(10);
   eLast = GreensortEnergyNow();
   auto start = std::chrono::high_resolution_clock::now();
   NumericVector aux(n);
   for (i=0;i<n;i++)
     aux[i] = orig[i];
   gfx::timsort(aux.begin(), aux.end());
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




// [[Rcpp::export]]
List Peeksort_insitu(NumericVector & orig) {
  PCapEnergyT eLast;
  GreensortEnergyT eNext;
  int n=orig.size();
  NumericVector ret(10);
  eLast = GreensortEnergyNow();
  auto start = std::chrono::high_resolution_clock::now();
  std::make_unique<peekpower::peeksort<double *, INSERTIONSORT_LIMIT, ONLYINCREASINGRUNS, peekpower::MERGINGMETHOD>>()->sort(orig.begin(), orig.end());  // INSERTIONSORT_LIMIT from ordermerge.h
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
List Peeksort_exsitu(NumericVector & orig) {
  PCapEnergyT eLast;
  GreensortEnergyT eNext;
  int i,n=orig.size();
    NumericVector ret(10);
    eLast = GreensortEnergyNow();
    auto start = std::chrono::high_resolution_clock::now();
    NumericVector aux(n);
    for (i=0;i<n;i++)
        aux[i] = orig[i];
    std::make_unique<peekpower::peeksort<double *, INSERTIONSORT_LIMIT, ONLYINCREASINGRUNS, peekpower::MERGINGMETHOD>>()->sort(aux.begin(), aux.end());
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




 // [[Rcpp::export]]
 List Powersort_insitu(NumericVector & orig) {
   PCapEnergyT eLast;
   GreensortEnergyT eNext;
   int n=orig.size();
   NumericVector ret(10);
   eLast = GreensortEnergyNow();
   auto start = std::chrono::high_resolution_clock::now();
   std::make_unique<peekpower::powersort<double *, INSERTIONSORT_LIMIT, peekpower::MERGINGMETHOD, ONLYINCREASINGRUNS>>()->sort(orig.begin(), orig.end());
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
 List Powersort_exsitu(NumericVector & orig) {
   PCapEnergyT eLast;
   GreensortEnergyT eNext;
   int i,n=orig.size();
   NumericVector ret(10);
   eLast = GreensortEnergyNow();
   auto start = std::chrono::high_resolution_clock::now();
   NumericVector aux(n);
   for (i=0;i<n;i++)
     aux[i] = orig[i];
   std::make_unique<peekpower::powersort<double *, INSERTIONSORT_LIMIT, peekpower::MERGINGMETHOD, ONLYINCREASINGRUNS>>()->sort(aux.begin(), aux.end());
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




 // [[Rcpp::export]]
 List Powersort4_insitu(NumericVector & orig) {
   PCapEnergyT eLast;
   GreensortEnergyT eNext;
   int n=orig.size();
   NumericVector ret(10);
   eLast = GreensortEnergyNow();
   auto start = std::chrono::high_resolution_clock::now();
   std::make_unique<peekpower::powersort_4way<double *, INSERTIONSORT_LIMIT, peekpower::MERGING4WAYMETHOD, ONLYINCREASINGRUNS>>()->sort(orig.begin(), orig.end());
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
 List Powersort4_exsitu(NumericVector & orig) {
   PCapEnergyT eLast;
   GreensortEnergyT eNext;
   int i,n=orig.size();
   NumericVector ret(10);
   eLast = GreensortEnergyNow();
   auto start = std::chrono::high_resolution_clock::now();
   NumericVector aux(n);
   for (i=0;i<n;i++)
     aux[i] = orig[i];
   std::make_unique<peekpower::powersort_4way<double *, INSERTIONSORT_LIMIT, peekpower::MERGING4WAYMETHOD, ONLYINCREASINGRUNS>>()->sort(aux.begin(), aux.end());
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
 List Powersort4s_insitu(NumericVector & orig) {
   PCapEnergyT eLast;
   GreensortEnergyT eNext;
   int n=orig.size();
   NumericVector ret(10);
   eLast = GreensortEnergyNow();
   auto start = std::chrono::high_resolution_clock::now();
   std::make_unique<peekpower::powersort_4way<double *, INSERTIONSORT_LIMIT, peekpower::WILLEM_TUNED, ONLYINCREASINGRUNS>>()->sort(orig.begin(), orig.end());
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
 List Powersort4s_exsitu(NumericVector & orig) {
   int i,n=orig.size();
   NumericVector ret(10);
   PCapEnergyT eLast;
   GreensortEnergyT eNext;
   eLast = GreensortEnergyNow();
   auto start = std::chrono::high_resolution_clock::now();
   NumericVector aux(n);
   for (i=0;i<n;i++)
     aux[i] = orig[i];
   std::make_unique<peekpower::powersort_4way<double *, INSERTIONSORT_LIMIT, peekpower::WILLEM_TUNED, ONLYINCREASINGRUNS>>()->sort(orig.begin(), orig.end());
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

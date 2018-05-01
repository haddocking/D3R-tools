#!/usr/bin/env Rscript

args <- commandArgs(trailingOnly = TRUE)

if (length(args) != 2) {
  cat("\nUsage: Rscript <reference_sdf_file> <mobile_sdf_file>\n\n", sep="")
  stop()
}

suppressMessages(library(ChemmineR))
suppressMessages(library(fmcsR))

reference <- read.SDFset(args[1])
mobile <- read.SDFset(args[2])

mcs <- fmcs(reference, mobile, timeout=0, matching.mode='aromatic')

atomIndices <- cbind(mcs[['mcs1']]$mcs1$CMP1_fmcs_1, mcs[['mcs2']]$mcs2$CMP1_fmcs_1)

write.table(atomIndices, file='atom_indices.dat', row.names = F, col.names = F)

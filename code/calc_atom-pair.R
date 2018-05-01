#!/usr/bin/env Rscript

library(ChemmineR)

args <- commandArgs(trailingOnly = TRUE)

if (length(args) != 2) {
  cat("\nUsage: ./ap.R <template_sdf_file> <target_sdf_file>\n\n", sep="")
  stop()
}

templates = read.SDFset(args[1])
targets = read.SDFset(args[2])

templates = sdf2ap(templates)
targets = sdf2ap(targets)

l_template = length(templates)
l_target = length(targets)

m = sapply(1:l_template, function(x) {
  sapply(1:l_target, function(y) {
    cmp.similarity(templates[x], targets[y])
  })
})

m = sapply(1:dim(m)[2], function(x) {sprintf("%.3f", m[,x])} )
write.table(m, file="ap-tanimoto.matrix", row.names=F, col.names=F, quote=F, sep=',')

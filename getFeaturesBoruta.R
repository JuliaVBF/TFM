#!/usr/bin/env Rscript

parameters <- commandArgs(trailingOnly=TRUE)

boruta.file <- as.character(parameters[1])
output.file <- as.character(parameters[2])

data <- read.table(file=boruta.file, sep="\t", header=TRUE, quote="", stringsAsFactors=FALSE, check.names=FALSE)

output <- paste0(output.file, ".txt")

confirmed_KO <- data$feature[data$decision == "Confirmed"]

writeLines(confirmed_KO, con = output)



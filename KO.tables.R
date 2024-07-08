#!/usr/bin/env Rscript

## Libraries
library(dplyr)


## Functions
get.KOs <- function(file_path, table) {
  boruta <- read.table(file = file_path, header = TRUE, sep = "\t", quote = "", 
                       comment.char = "", check.names = FALSE, 
                       stringsAsFactors = FALSE)
  
  ko <- boruta %>% filter(decision == "Confirmed") %>% select(feature, DESCRIPTION)
  new.ko <- ko %>% filter(!feature %in% table$feature)
  table <- rbind(table, new.ko)
  
  return(table)
}



## CODE
folder <- "/path/to/files/"
file.pattern <- "results.boruta.*.tsv"
files <- list.files(path = folder, pattern = file.pattern, full.names = TRUE)

KO.table <- data.frame(feature = character(), DESCRIPTION = character(), 
                       stringsAsFactors = FALSE)

for (file in files) {
  KO.table <- get.KOs(file, KO.table)
}

KO.table <- KO.table[order(KO.table$feature),]

write.table(KO.table, file = paste0(folder, "tablaKOs.tsv"), sep = "\t", 
            quote = FALSE, row.names = FALSE)



#!/usr/bin/env Rscript

## Data
newID <- read.table("table_new-old_names.tsv", header = TRUE, sep = "\t", quote="", 
                    stringsAsFactors = FALSE, check.names = FALSE)

old.new.match <- setNames(New.IDs$new_ID, New.IDs$sample_ID) #sample_ID = old_ID

dat <- read.table("table.ID.names.old.tsv", header = TRUE, sep = "\t", 
                  quote="", stringsAsFactors = FALSE, check.names = FALSE)

new.names <- sapply(colnames(dat), function(x) {
  if (x == "TAXONOMY") {
    return(x)
  }
  return(ifelse(!is.na(match(x, names(old.new.match))), old.new.match[match(x, names(old.new.match))], x))
})


colnames(dat) <- new.names

write.table(dat, "table.new.names.tsv", sep = "\t", row.names = FALSE, quote = FALSE)
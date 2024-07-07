#!/usr/bin/env Rscript

library(RColorBrewer)


# Get phyla from file
input_folder <- "/path/to/folder/"
file_list <- list.files(path = input_folder, pattern = "results\\.boruta\\.Boruta\\..*\\.tsv$", 
                        full.names = TRUE, recursive = TRUE)
phyla_df <- data.frame(phylum = character())
for (file in file_list) {
  data <- read.table(file = file, header = TRUE, sep = "\t", 
                     check.names = FALSE, stringsAsFactors = FALSE)
  data$phylum <- sub("p__([^;]+);.*", "\\1", data$feature)
  new_phyla <- unique(data$phylum)
  all_phyla <- unique(c(phyla_df$phylum, new_phyla))
  phyla_df <- data.frame(phylum = all_phyla)
}

# Asign color to phyla
num_phyla <- length(phyla_df$phylum)
color_palette <- colorRampPalette(brewer.pal(12, "Set3"))(num_phyla)
phyla_df$color <- color_palette

# Save file with phyla-color 
write.table(phyla_df, file = "phyla_colors.tsv", sep = "\t", quote = FALSE, row.names = FALSE)



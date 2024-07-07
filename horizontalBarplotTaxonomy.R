## Libraries
library(ggplot2)

## Functions

getConfirmedFatures <- function(data, column = "log2FC") {
  
  confirmed <- subset(data, decision == "Confirmed")
  confirmed$feature <- as.factor(confirmed$feature)
  confirmed <- confirmed[order(-confirmed[[column]]),]
  confirmed$genus <- sub(".*g__", "", confirmed$feature)
  confirmed$phylum <- sub("p__([^;]+);.*", "\\1", confirmed$feature)
  confirmed$phylum <- as.factor(confirmed$phylum)
  
  return(confirmed)
  
}


doHorizontalBarplot <- function(data, phyla_colors_df , column = "log2FC", limX = 2, 
                                title = "", output_dir= workdir) {

  # Create color palette from Phyla-color file
  phyla_colors <- setNames(phyla_colors_df$color, phyla_colors_df$phylum)
  
  plot <- ggplot(data = data, 
                 aes_string(y = column, 
                            x = paste0("factor(genus, levels = rev(data$genus))"), 
                            fill = data$phylum)) +
    coord_flip() + # Horizontal barplot
    ylab("log2FC") +
    xlab("Genus") +
    scale_y_continuous(limits = c(-limX, limX)) +
    labs(fill = "Phylum") +
    scale_fill_manual(values = phyla_colors) + # Use same color for phyla in each plot
    theme(plot.title = element_text(hjust = 0.5)) +
    ggtitle(title)
  
  filename <- paste0(gsub(" ", "_", title), ".png")
  filepath <- file.path(output_dir, filename)
  ggsave(filepath, plot = plot)
  
  return(plot)
}


## Code
workdir <- getwd()
data <- read.table(file = "/path/to/data", header = TRUE, sep="\t", 
                   check.names=FALSE, stringsAsFactors=FALSE )
phyla_df <- read.table(file = "/path/to/phyla_colors.tsv",header = TRUE, sep="\t", 
                       check.names=FALSE, stringsAsFactors=FALSE)

confirmed <- getConfirmedFatures(data, column = "log2FC")
maxlogFC <- max(abs(data[["log2FC"]]))

a1<- doHorizontalBarplot(confirmed, phyla_colors_df = phyla_df, column = "log2FC", 
                         limX = maxlogFC, title = "PLOT TITLE")
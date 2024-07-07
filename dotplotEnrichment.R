## LIBRARIES
library(ggplot2)
library(tidyverse)


### FUNCTIONS
doDotPlot <- function(data, title = "", subtitle = "", output_dir = workdir) {
  
  plot <- ggplot(data, aes(x = p.value, y = reorder(pathway, -p.value), 
                           size = number.in.sel, color = status)) +
    geom_point(alpha = 0.6) + 
    scale_color_manual(values = c("Over-represented" = "#00C3C7", "Under-represented" = "#FC7173"))
    labs(x = "p-value", y = "Metabolic pathways", size = "Number of KOs") +
    theme_minimal() +
    ggtitle(title, subtitle = subtitle) +
    theme(axis.text.y = element_text(size = 10),
          plot.title = element_text(hjust = 0.5),
          plot.subtitle = element_text(hjust = 0.5)) +
    ggtitle(title)

  filename <- paste0(gsub(" ", "_", title), ".png")
  filepath <- file.path(output_dir, filename)
  ggsave(filepath, plot = plot)

}


### CODE
workdir <- getwd()

# Data
overrep <- read.table(file = "path/to/overrepresented/pathway/data", header = TRUE, 
                      sep="\t", check.names=FALSE, stringsAsFactors=FALSE )
overrep$status <- "Over"
colnames(overrep)[colnames(overrep) == "p.vals"] <- "p.value"

underrep <- read.table(file = "path/to/underrepresented/pathway/data", header = TRUE, 
                       sep="\t", quote="", stringsAsFactors=FALSE )
underrep$status <- "Under"
colnames(underrep)[colnames(underrep) == "p.vals"] <- "p.value"

all.pathways <- rbind(overrep, underrep)

doDotPlot(data = all.pathways, title = "Title", 
                  output_dir = workdir)
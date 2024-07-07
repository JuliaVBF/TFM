## LIBRARIES
library(ggplot2)
library(tidyverse)


## FUNCTIONS
getConfirmedFatures <- function(data, column = "log2FCdeseq") {

  confirmed <- subset(data, decision == "Confirmed")
  confirmed$feature <- as.factor(confirmed$feature)
  confirmed <- confirmed[order(-confirmed[[column]]),]
  return(confirmed)
  
}

getMaxLogFC <- function(data, column = "log2FCdeseq") {
  # Verificacion
  if (!column %in% names(data)) {
    stop(paste("La columna", column, "no existe en el dataframe"))
  }
  
  # Funcion
  max.logFC <- max(abs(data[[column]]))
  return(max.logFC)
}


doHorizontalBarplot <- function(data, column = "", limX = 2, title = "", output_dir= workdir) {
  
  plot <- ggplot(data = data, 
                 aes_string(y = column, 
                            x = paste0("factor(feature, levels = rev(data$feature))"), 
                            fill = paste0(column, " < 0"))) +
    geom_col() +
    coord_flip() +
    ylab("log2FC") +
    xlab("Features") +
    scale_y_continuous(limits = c(-limX, limX)) +
    theme(legend.position = "none", plot.title = element_text(hjust = 0.5)) +
    ggtitle(title)
  
  # Mostrar plot
  print(plot)
  # Guardar plot
  filename <- paste0(gsub(" ", "_", title), ".png")
  filepath <- file.path(output_dir, filename)
  ggsave(filepath, plot = plot)
}


## Code

data <- read.table(file = "/path/to/data/file", header = TRUE, sep="\t", 
                   check.names=FALSE, stringsAsFactors=FALSE )

confirmed <- subset(data, decision == "Confirmed")
confirmed$feature <- as.factor(confirmed$feature)
confirmed <- confirmed[order(-confirmed[["log2FCdeseq.notShrinked"]]),]

max.logFC <- max(abs(data[["log2FCdeseq.notShrinked"]]))

doHorizontalBarplot(confirmed, column = "log2FCdeseq.notShrinked", limX = max.logFC, 
                    title = "Title",
                    output_dir = workdir)
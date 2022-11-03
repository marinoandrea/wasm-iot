if (!require("ggplot2")) install.packages("ggplot2"); 

library(ggplot2)
source("utils.r")

# base visualization style settings
base_theme    <- theme(text = element_text(size = 20))
base_outliars <- geom_boxplot(outlier.colour="red", outlier.size=1)

plot_boxplot <- function(aes_selection, x_label, y_label, log) {
  plot <- ggplot(df, aes(x=language, y=energy_usage, color=language)) +
    base_outliars +
    base_theme +
    labs(x=x_label, y=y_label)
  if (log) { 
    plot <- plot + scale_y_continuous(trans='log2')
  }
  print(plot)
}
  
main <- function() {
  df <- read_dataset()

  # Hypothesis H^pl
  plot_boxplot(
    aes(x=language, y=energy_usage, color=language), 
    x_label="programming language",
    y_label="energy usage (Joules)",
    log=TRUE)
  plot_boxplot(
    aes(x=language, y=execution_time, color=language), 
    x_label="programming language",
    y_label="execution time (s)",
    log=TRUE)
  plot_boxplot(
    aes(x=language, y=memory_usage, color=language), 
    x_label="programming language",
    y_label="memory usage (%)",
    log=TRUE)

  # Hypothesis H^re
  plot_boxplot(
    aes(x=runtime, y=energy_usage, color=runtime), 
    x_label="runtime",
    y_label="energy usage (Joules)",
    log=TRUE)
  plot_boxplot(
    aes(x=runtime, y=execution_time, color=runtime), 
    x_label="runtime",
    y_label="execution time (s)",
    log=TRUE)
  plot_boxplot(
    aes(x=runtime, y=memory_usage, color=runtime), 
    x_label="runtime",
    y_label="memory usage (%)",
    log=TRUE)

  # Hypothesis H^{pl, re}
  plot_boxplot(
    aes(x=language, y=energy_usage, color=language, fill=runtime),
    x_label="programming language",
    y_label="energy usage (Joules)",
    log=TRUE)
  plot_boxplot(
    aes(x=language, y=execution_time, color=language, fill=runtime),
    x_label="programming language",
    y_label="execution time (s)",
    log=TRUE)
  plot_boxplot(
    aes(x=language, y=memory_usage, color=language, fill=runtime),
    x_label="programming language",
    y_label="memory usage (%)",
    log=TRUE)
}

if(!interactive()) {
  main()
}

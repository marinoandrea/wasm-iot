if (!require("ggplot2")) install.packages("ggplot2");

library(ggplot2)
source("utils.r")

base_theme    <- theme(text = element_text(size = 20))
base_style    <- geom_histogram(bins=60, color="black", fill="lightblue")

plot_histograms <- function(df_partial) {
  energy <- 
    ggplot(data=df_partial, aes(x=energy_usage)) + 
    base_style + 
    base_theme + 
    labs(y='samples', x='energy usage (Joules)')
  time <- 
    ggplot(data=df_partial, aes(x=execution_time)) + 
    base_style + 
    base_theme + 
    labs(y='samples', x='execution time (s)')
  memory <- 
    ggplot(data=df_partial, aes(x=memory_usage)) + 
    base_style + 
    base_theme + 
    labs(y='samples', x='memory usage (%)')
  print(energy)
  print(time)
  print(memory)
}

main <- function() {
  df <- read_dataset()

  # Hypothesis H^pl
  for (language in c('c', 'go', 'rust', 'javascript')) {
    df_partial <- subset(df, df$language == language)
    plot_histograms(df_partial)
  }

  # Hypothesis H^re
  for (runtime in c('wasmer', 'wasmtime')) {
    df_partial <- subset(df, df$runtime == runtime)
    plot_histograms(df_partial)
  }

  # Hypothesis H^{pl, re}
  for (language in c('c', 'go', 'rust', 'javascript')) {
    for (runtime in c('wasmer', 'wasmtime')) {
      df_partial <- subset(df, df$runtime == runtime & df$language == language)
      plot_histograms(df_partial)
    }
  }
}

if(!interactive()) {
  main()
}


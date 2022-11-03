install.packages("ggplot2"); library(ggplot2)

df <- read.csv(file.choose(), sep='\t')
df <- data.frame(
  language = as.factor(c(df$language)),
  runtime = as.factor(c(df$runtime)),
  energy_usage = as.numeric(df$energy_usage),
  execution_time = as.numeric(df$execution_time) / 1000, # in seconds
  memory_usage = as.numeric(df$memory_usage),
  cpu_usage = as.numeric(df$cpu_usage))

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
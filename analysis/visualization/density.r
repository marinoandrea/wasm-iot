if (!require("ggplot2")) install.packages("ggplot2"); 
if (!require("plyr")) install.packages("plyr"); 

library(ggplot2)
library(plyr)
source("utils.r")

base_theme    <- theme(text = element_text(size = 20))
base_style    <- geom_density(alpha = 0.3)

plot_density_language <- function(df, language, x_scale="log2", y_scale="log2") {
  mean_energy <- ddply(.data=df, .variables=c("language"), summarise, grp.mean=mean(energy_usage))
  mean_time   <- ddply(.data=df, .variables=c("language"), summarise, grp.mean=mean(execution_time))
  mean_memory <- ddply(.data=df, .variables=c("language"), summarise, grp.mean=mean(memory_usage))

  pdf(file=sprintf("%s_energy_usage.pdf", language))
  energy <- 
    ggplot(df, aes(x=energy_usage, fill=language), xScale=x_scale, yScale=y_scale) +
    base_style + 
    base_theme + 
    geom_vline(data=mean_energy, aes(xintercept=grp.mean, color=language), linetype="dashed") +
    labs(y='density', x='energy usage (Joules)')
  print(energy)
  dev.off()
  
  pdf(file=sprintf("%s_execution_time.pdf", language))
  time <- 
    ggplot(df, aes(x=execution_time, fill=language), xScale=x_scale, yScale=y_scale) +
    base_style + 
    base_theme + 
    geom_vline(data=mean_time, aes(xintercept=grp.mean, color=language), linetype="dashed") +
    labs(y='density', x='execution time (s)')
  print(time)
  dev.off()

  pdf(file=sprintf("%s_memory_usage.pdf", language))
  memory <-  
    ggplot(df, aes(x=memory_usage, fill=language), xScale=x_scale, yScale=y_scale) +
    base_style + 
    base_theme + 
    geom_vline(data=mean_memory, aes(xintercept=grp.mean, color=language), linetype="dashed") +
    labs(y='density', x='memory usage (%)')
  print(memory)
  dev.off()
}

plot_density_language_runtime <- function(df, language, runtime, x_scale="log2", y_scale="log2") {
  mean_energy <- ddply(.data=df, .variables=c("language", "runtime"), summarise, grp.mean=mean(energy_usage))
  mean_time   <- ddply(.data=df, .variables=c("language", "runtime"), summarise, grp.mean=mean(execution_time))
  mean_memory <- ddply(.data=df, .variables=c("language", "runtime"), summarise, grp.mean=mean(memory_usage))

  pdf(file=sprintf("%s_%s_energy_usage.pdf", language, runtime))
  energy <- 
    ggplot(df, aes(x=energy_usage, fill=language:runtime), xScale=x_scale, yScale=y_scale) +
    base_style + 
    base_theme + 
    labs(y='density', x='energy usage (Joules)')
  print(energy)
  dev.off()
  
  pdf(file=sprintf("%s_%s_execution_time.pdf", language, runtime))
  time <- 
    ggplot(df, aes(x=execution_time, fill=language:runtime), xScale=x_scale, yScale=y_scale) +
    base_style + 
    base_theme + 
    labs(y='density', x='execution time (s)')
  print(time)
  dev.off()

  pdf(file=sprintf("%s_%s_memory_usage.pdf", language, runtime))
  memory <-  
    ggplot(df, aes(x=memory_usage, fill=language:runtime), xScale=x_scale, yScale=y_scale) +
    base_style + 
    base_theme + 
    labs(y='density', x='memory usage (%)')
  print(memory)
  dev.off()
}

plot_density_runtime <- function(df, runtime, x_scale="log2", y_scale="log2") {
  mean_energy <- ddply(.data=df, .variables=c("runtime"), summarise, grp.mean=mean(energy_usage))
  mean_time   <- ddply(.data=df, .variables=c("runtime"), summarise, grp.mean=mean(execution_time))
  mean_memory <- ddply(.data=df, .variables=c("runtime"), summarise, grp.mean=mean(memory_usage))

  pdf(file=sprintf("%s_energy_usage.pdf", runtime))
  energy <- 
    ggplot(df, aes(x=energy_usage, fill=runtime), xScale=x_scale, yScale=y_scale) +
    base_style + 
    base_theme + 
    geom_vline(data=mean_energy, aes(xintercept=grp.mean, color=runtime), linetype="dashed") +
    labs(y='density', x='energy usage (Joules)')
  print(energy)
  dev.off()
  
  pdf(file=sprintf("%s_execution_time.pdf", runtime))
  time <- 
    ggplot(df, aes(x=execution_time, fill=runtime), xScale=x_scale, yScale=y_scale) +
    base_style + 
    base_theme + 
    geom_vline(data=mean_time, aes(xintercept=grp.mean, color=runtime), linetype="dashed") +
    labs(y='density', x='execution time (s)')
  print(time)
  dev.off()

  pdf(file=sprintf("%s_memory_usage.pdf", runtime))
  memory <-  
    ggplot(df, aes(x=memory_usage, fill=runtime), xScale=x_scale, yScale=y_scale) +
    base_style + 
    base_theme + 
    geom_vline(data=mean_memory, aes(xintercept=grp.mean, color=runtime), linetype="dashed") +
    labs(y='density', x='memory usage (%)')
  print(memory)
  dev.off()
}

main <- function() {
  df <- read_dataset()

  # Hypothesis H^pl
  for (treatment in c('c', 'go', 'rust', 'javascript')) {
    df_partial <- subset(df, df$language == treatment)
    plot_density_language(df_partial, treatment)
  }

  # Hypothesis H^re
  for (treatment in c('wasmer', 'wasmtime')) {
    df_partial <- subset(df, df$runtime == treatment)
    plot_density_runtime(df_partial, treatment)
  }

  # Hypothesis H^{pl, re}
  for (treatment1 in c('c', 'go', 'rust', 'javascript')) {
    for (treatment2 in c('wasmer', 'wasmtime')) {
      df_partial <- subset(df, df$runtime == treatment1 & df$language == treatment2)
      plot_density_language_runtime(df_partial, treatment1, treatment2)
    }
  }
}

if(!interactive()) {
  main()
}

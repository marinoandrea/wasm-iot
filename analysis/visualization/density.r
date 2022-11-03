if (!require("ggplot2")) install.packages("ggplot2"); 
if (!require("plur")) install.packages("plyr"); 

library(ggplot2)
library(plyr)
source("utils.r")

base_theme    <- theme(text = element_text(size = 20))
base_style    <- geom_density(alpha = 0.3)

plot_density <- function(df_partial, mean_discriminators, x_scale="log2", y_scale="log2") {
  mean_energy <- ddply(.data=df_partial, .variables=mean_discriminators, summarise, grp.mean=mean(energy_usage))
  mean_time   <- ddply(.data=df_partial, .variables=mean_discriminators, summarise, grp.mean=mean(execution_time))
  mean_memory <- ddply(.data=df_partial, .variables=mean_discriminators, summarise, grp.mean=mean(memory_usage))

  energy <- 
    ggplot(df_partial, aes(x=energy_usage, fill=language, xScale=x_scale, yScale=y_scale)) +
    base_style + 
    base_theme + 
    geom_vline(data=mean_energy, aes(xintercept=grp.mean, color=language), linetype="dashed") +
    labs(y='density', x='energy usage (Joules)')
  time <- 
    ggplot(df_partial, aes(x=execution_time, fill=language, xScale=x_scale, yScale=y_scale)) +
    base_style + 
    base_theme + 
    geom_vline(data=mean_time, aes(xintercept=grp.mean, color=language), linetype="dashed") +
    labs(y='density', x='execution time (s)')
  memory <-  
    ggplot(df_partial, aes(x=memory_usage, fill=language, xScale=x_scale, yScale=y_scale)) +
    base_style + 
    base_theme + 
    geom_vline(data=mean_memory, aes(xintercept=grp.mean, color=language), linetype="dashed") +
    labs(y='density', x='memory usage (%)')
  
  print(energy)
  print(time)
  print(memory)
}

main <- function() {
  df <- read_dataset()

  # Hypothesis H^pl
  for (language in c('c', 'go', 'rust', 'javascript')) {
    df_partial <- subset(df, df$language == language)
    plot_density(df_partial, mean_discriminators=c("language"))
  }

  # Hypothesis H^re
  for (runtime in c('wasmer', 'wasmtime')) {
    df_partial <- subset(df, df$runtime == runtime)
    plot_density(df_partial, mean_discriminators=c("runtime"))
  }

  # Hypothesis H^{pl, re}
  for (language in c('c', 'go', 'rust', 'javascript')) {
    for (runtime in c('wasmer', 'wasmtime')) {
        df_partial <- subset(df, df$runtime == runtime & df$language == language)
        plot_density(df_partial, mean_discriminators=c("language", "runtime"))
    }
  }
}

if(!interactive()) {
  main()
}

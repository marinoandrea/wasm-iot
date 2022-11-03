install.packages("ggplot2"); library(ggplot2)

df <- read.csv(file.choose(), sep='\t')
df <- data.frame(
  language = as.factor(c(df$language)),
  runtime = as.factor(c(df$runtime)),
  energy_usage = as.numeric(df$energy_usage),
  execution_time = as.numeric(df$execution_time) / 1000, # in seconds
  memory_usage = as.numeric(df$memory_usage),
  cpu_usage = as.numeric(df$cpu_usage))

# base visualization style settings
base_theme    <- theme(text = element_text(size = 20))
base_outliars <- geom_boxplot(outlier.colour="red", outlier.size=1)
  
# Hypothesis H^pl

pl_energy <- 
  ggplot(df, aes(x=language, y=energy_usage, color=language)) +
  scale_y_continuous(trans='log2') +
  base_outliars +
  base_theme +
  labs(x="programming language", y = "energy usage (Joules)")
print(pl_energy)

pl_time <-
  ggplot(df, aes(x=language, y=execution_time, color=language)) +
  scale_y_continuous(trans='log2') +
  base_outliars +
  base_theme +
  labs(x="programming language", y = "execution time (s)")
print(pl_time)

pl_memory <- 
  ggplot(df, aes(x=language, y=memory_usage, color=language)) +
  scale_y_continuous(trans='log2') +
  base_outliars +
  base_theme +
  labs(x="programming language", y = "memory usage (MB)")
print(pl_memory)

# Hypothesis H^re

re_energy <- 
  ggplot(df, aes(x=runtime, y=energy_usage, color=runtime)) +
  scale_y_continuous(trans='log2') +
  base_outliars +
  base_theme +
  labs(x="runtime", y = "energy usage (Joules)")
print(re_energy)

re_time <- 
  ggplot(df, aes(x=runtime, y=execution_time, color=runtime)) +
  scale_y_continuous(trans='log2') +
  base_outliars +
  base_theme +
  labs(x="runtime", y = "execution time (s)")
print(re_time)

re_memory <- 
  ggplot(df, aes(x=runtime, y=memory_usage, color=runtime)) +
  scale_y_continuous(trans='log2') +
  base_outliars +
  base_theme +
  labs(x="runtime", y = "memory usage (MB)")
print(re_memory)

# Hypothesis H^{pl, re}

plre_energy <-
  ggplot(df, aes(x=language, y=energy_usage, color=language, fill=runtime)) +
  scale_y_continuous(trans='log2') +
  base_outliars +
  base_theme +
  labs(x="runtime", y = "energy usage(Joules)") +
  scale_fill_grey()
print(plre_energy)

plre_time <-
  ggplot(df, aes(x=language, y=execution_time, color=language, fill=runtime)) +
  scale_y_continuous(trans='log2') +
  base_outliars +
  base_theme +
  labs(x="runtime", y = "execution time (s)") +
  scale_fill_grey()
print(plre_time)

plre_memory <-
  ggplot(df, aes(x=language, y=memory_usage, color=language, fill=runtime)) +
  scale_y_continuous(trans='log2') +
  base_outliars +
  base_theme +
  labs(x="runtime", y = "memory usage (MB)") +
  scale_fill_grey()
print(plre_memory)

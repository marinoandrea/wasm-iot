if (!require("ggplot2")) install.packages("ggplot2")

library(ggplot2)
source("../core/utils.r")

# base visualization style settings
base_theme <- theme(text = element_text(size = 20))
base_outliars <- geom_boxplot(outlier.colour = "red", outlier.size = 1)

format_field_name <- function(field) {
  return(substring(toString(field), first = 4))
}

setup_pdf_storage <- function(aes_selection) {
  x <- format_field_name(aes_selection$x)
  y <- format_field_name(aes_selection$y)
  if (exists("fill", where = aes_selection)) {
    z <- format_field_name(aes_selection$fill)
    pdf(file = sprintf("%s_%s_%s.pdf", x, z, y))
  } else {
    pdf(file = sprintf("%s_%s.pdf", x, y))
  }
}

plot_boxplot <- function(df, aes_selection, x_label, y_label, log) {
  setup_pdf_storage(aes_selection)
  plot <- ggplot(df, aes_selection) +
    base_outliars +
    base_theme +
    labs(x = x_label, y = y_label) +
    scale_fill_grey()
  if (log) {
    plot <- plot + scale_y_continuous(trans = "log2")
  }
  print(plot)
  dev.off()
}

main <- function() {
  df <- read_dataset()

  # Hypothesis H^pl
  plot_boxplot(
    df,
    aes(x = language, y = energy_usage, color = language),
    x_label = "programming language",
    y_label = "energy usage (Joules)",
    log = TRUE
  )
  plot_boxplot(
    df,
    aes(x = language, y = execution_time, color = language),
    x_label = "programming language",
    y_label = "execution time (s)",
    log = TRUE
  )
  plot_boxplot(
    df,
    aes(x = language, y = memory_usage, color = language),
    x_label = "programming language",
    y_label = "memory usage (%)",
    log = TRUE
  )

  # Hypothesis H^re
  plot_boxplot(
    df,
    aes(x = runtime, y = energy_usage, color = runtime),
    x_label = "runtime",
    y_label = "energy usage (Joules)",
    log = TRUE
  )
  plot_boxplot(
    df,
    aes(x = runtime, y = execution_time, color = runtime),
    x_label = "runtime",
    y_label = "execution time (s)",
    log = TRUE
  )
  plot_boxplot(
    df,
    aes(x = runtime, y = memory_usage, color = runtime),
    x_label = "runtime",
    y_label = "memory usage (%)",
    log = TRUE
  )

  # Hypothesis H^{pl, re}
  plot_boxplot(
    df,
    aes(x = language, y = energy_usage, color = language, fill = runtime),
    x_label = "programming language",
    y_label = "energy usage (Joules)",
    log = TRUE
  )
  plot_boxplot(
    df,
    aes(x = language, y = execution_time, color = language, fill = runtime),
    x_label = "programming language",
    y_label = "execution time (s)",
    log = TRUE
  )
  plot_boxplot(
    df,
    aes(x = language, y = memory_usage, color = language, fill = runtime),
    x_label = "programming language",
    y_label = "memory usage (%)",
    log = TRUE
  )
}

if (!interactive()) {
  main()
}

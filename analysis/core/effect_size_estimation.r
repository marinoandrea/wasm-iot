if (!require("effsize")) install.packages("effsize")
if (!require("readxl")) install.packages("readxl")
if (!require("ARTool")) install.packages("ARTool")

library(effsize)
library(readxl)
library(ARTool)

source("utils.r")

main <- function() {
    df <- read_dataset()

    # Hypothesis H^pl
    for (treatment1 in c("c", "rust", "go", "javascript")) {
        for (treatment2 in c("c", "rust", "go", "javascript")) {
            cat(treatment1, treatment2, "energy usage, execution time, memory usage")
            print(cliff.delta(df[df$language == treatment1, ]$energy_usage, df[df$language == treatment2, ]$energy_usage))
            print(cliff.delta(df[df$language == treatment1, ]$execution_time, df[df$language == treatment2, ]$execution_time))
            print(cliff.delta(df[df$language == treatment1, ]$memory_usage, df[df$language == treatment2, ]$memory_usage))
        }
    }

    # Hypothesis H^re
    for (treatment1 in c("wasmer", "wasmtime")) {
        for (treatment2 in c("wasmer", "wasmtime")) {
            cat(treatment1, treatment2, "energy usage, execution time, memory usage")
            print(cliff.delta(df[df$runtime == treatment1, ]$energy_usage, df[df$runtime == treatment2, ]$energy_usage))
            print(cliff.delta(df[df$runtime == treatment1, ]$execution_time, df[df$runtime == treatment2, ]$execution_time))
            print(cliff.delta(df[df$runtime == treatment1, ]$memory_usage, df[df$runtime == treatment2, ]$memory_usage))
        }
    }

    # Hypothesis H^{pl, re}
    for (treatment0 in c("wasmtime", "wasmer")) {
        for (treatment1 in c("wasmer", "wasmtime")) {
            for (treatment2 in c("c", "rust", "go", "javascript")) {
                for (treatment3 in c("javascript", "go", "rust", "c")) {
                    cat("runtime:", treatment0, "language:", treatment2, "vs", "runtime:", treatment1, "language:", treatment3, "energy usage, execution time, memory usage")
                    print(cliff.delta(
                        df[df$runtime == treatment0 & df$language == treatment2, ]$energy_usage,
                        df[df$runtime == treatment1 & df$language == treatment3, ]$energy_usage
                    ))
                    print(cliff.delta(
                        df[df$runtime == treatment0 & df$language == treatment2, ]$execution_time,
                        df[df$runtime == treatment1 & df$language == treatment3, ]$execution_time
                    ))
                    print(cliff.delta(
                        df[df$runtime == treatment0 & df$language == treatment2, ]$memory_usage,
                        df[df$runtime == treatment1 & df$language == variable3, ]$memory_usage
                    ))
                }
            }
        }
    }
}


if (!interactive()) {
    main()
}

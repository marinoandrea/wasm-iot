if (!require("effsize")) install.packages("effsize")
if (!require("readxl")) install.packages("readxl")
if (!require("ARTool")) install.packages("ARTool")
if (!require("caret")) install.packages("caret")

library(effsize)
library(readxl)
library(ARTool)
library(caret)

source("utils.r")

main <- function() {
    df <- read_dataset()

    # Hypothesis H^pl (Shapiro test + data transformation)
    for (treatment1 in c("c", "go", "rust", "javascript")) {
        # energy usage
        print(shapiro.test(df$energy_usage[df$language == treatment1])) # orginal data
        print(shapiro.test(sqrt(df$energy_usage[df$language == treatment1]))) # sqrt Transformation
        print(shapiro.test(log10(df$energy_usage[df$language == treatment1]))) # log Transformation
        print(shapiro.test(1 / (df$energy_usage[df$language == treatment1]))) # 1/x Transformation
        ## standardize Sepal.Width
        x <- df$energy_usage[df$language == treatment1]
        print(shapiro.test((x - mean(x)) / sd(x)))
        ## Data with Standard Scaling
        print(shapiro.test(scale(x)))
        # execution time
        print(shapiro.test(df$execution_time[df$language == treatment1])) # orginal data
        print(shapiro.test(sqrt(df$execution_time[df$language == treatment1]))) # sqrt Transformation
        print(shapiro.test(log10(df$execution_time[df$language == treatment1]))) # log Transformation
        print(shapiro.test(1 / (df$execution_time[df$language == treatment1]))) # 1/x Transformation
        ## standardize Sepal.Width
        x <- df$execution_time[df$language == treatment1]
        print(shapiro.test((x - mean(x)) / sd(x)))
        ## Data with Standard Scaling
        print(shapiro.test(scale(x)))
        # memory_usage
        print(shapiro.test(df$memory_usage[df$language == treatment1])) # orginal data
        print(shapiro.test(sqrt(df$memory_usage[df$language == treatment1]))) # sqrt Transformation
        print(shapiro.test(log10(df$memory_usage[df$language == treatment1]))) # log Transformation
        print(shapiro.test(1 / (df$memory_usage[df$language == treatment1]))) # 1/x Transformation
        ## standardize Sepal.Width
        x <- df$memory_usage[df$language == treatment1]
        print(shapiro.test((x - mean(x)) / sd(x)))
        ## Data with Standard Scaling
        print(shapiro.test(scale(x)))
    }

    # Hypothesis H^re (Shapiro test + data transformation)
    for (treatment1 in c("wasmer", "wasmtime")) {
        # energy usage
        print(shapiro.test(df$energy_usage[df$runtime == treatment1])) # orginal data
        print(shapiro.test(sqrt(df$energy_usage[df$runtime == treatment1]))) # sqrt Transformation
        print(shapiro.test(log10(df$energy_usage[df$runtime == treatment1]))) # log Transformation
        print(shapiro.test(1 / (df$energy_usage[df$runtime == treatment1]))) # 1/x Transformation
        ## standardize Sepal.Width
        x <- df$energy_usage[df$runtime == treatment1]
        print(shapiro.test((x - mean(x)) / sd(x)))
        ## Data with Standard Scaling
        print(shapiro.test(scale(x)))
        # execution_time
        print(shapiro.test(df$execution_time[df$runtime == treatment1])) # orginal data
        print(shapiro.test(sqrt(df$execution_time[df$runtime == treatment1]))) # sqrt Transformation
        print(shapiro.test(log10(df$execution_time[df$runtime == treatment1]))) # log Transformation
        print(shapiro.test(1 / (df$execution_time[df$runtime == treatment1]))) # 1/x Transformation
        ## standardize Sepal.Width
        x <- df$execution_time[df$runtime == treatment1]
        print(shapiro.test((x - mean(x)) / sd(x)))
        ## Data with Standard Scaling
        print(shapiro.test(scale(x)))
        # memory_usage
        print(shapiro.test(df$memory_usage[df$runtime == treatment1])) # orginal data
        print(shapiro.test(sqrt(df$memory_usage[df$runtime == treatment1]))) # sqrt Transformation
        print(shapiro.test(log10(df$memory_usage[df$runtime == treatment1]))) # log Transformation
        print(shapiro.test(1 / (df$memory_usage[df$runtime == treatment1]))) # 1/x Transformation
        ## standardize Sepal.Width
        x <- df$memory_usage[df$runtime == treatment1]
        print(shapiro.test((x - mean(x)) / sd(x)))
        ## Data with Standard Scaling
        print(shapiro.test(scale(x)))
    }

    # Hypothesis H^{pl, re} (Shapiro test + data transformation)
    for (treatment1 in c("wasmer", "wasmtime")) {
        for (treatment2 in c("c", "go", "rust", "javascript")) {
            # energy usage
            print(shapiro.test(df$energy_usage[df$runtime == treatment1 & df$language == treatment2])) # orginal data
            print(shapiro.test(sqrt(df$energy_usage[df$runtime == treatment1 & df$language == treatment2]))) # sqrt Transformation
            print(shapiro.test(log10(df$energy_usage[df$runtime == treatment1 & df$language == treatment2]))) # log Transformation
            print(shapiro.test(1 / (df$energy_usage[df$runtime == treatment1 & df$language == treatment2]))) # 1/x Transformation
            ## standardize Sepal.Width
            x <- df$energy_usage[df$runtime == treatment1 & df$language == treatment2]
            print(shapiro.test((x - mean(x)) / sd(x)))
            ## Data with Standard Scaling
            print(shapiro.test(scale(x)))
            # execution_time
            print(shapiro.test(df$execution_time[df$runtime == treatment1 & df$language == treatment2])) # orginal data
            print(shapiro.test(sqrt(df$execution_time[df$runtime == treatment1 & df$language == treatment2]))) # sqrt Transformation
            print(shapiro.test(log10(df$execution_time[df$runtime == treatment1 & df$language == treatment2]))) # log Transformation
            print(shapiro.test(1 / (df$execution_time[df$runtime == treatment1 & df$language == treatment2]))) # 1/x Transformation
            ## standardize Sepal.Width
            x <- df$execution_time[df$runtime == treatment1 & df$language == treatment2]
            print(shapiro.test((x - mean(x)) / sd(x)))
            ## Data with Standard Scaling
            print(shapiro.test(scale(x)))
            # memory_usage
            print(shapiro.test(df$memory_usage[df$runtime == treatment1 & df$language == treatment2])) # orginal data
            print(shapiro.test(sqrt(df$memory_usage[df$runtime == treatment1 & df$language == treatment2]))) # sqrt Transformation
            print(shapiro.test(log10(df$memory_usage[df$runtime == treatment1 & df$language == treatment2]))) # log Transformation
            print(shapiro.test(1 / (df$memory_usage[df$runtime == treatment1 & df$language == treatment2]))) # 1/x Transformation
            ## standardize Sepal.Width
            x <- df$memory_usage[df$runtime == treatment1 & df$language == treatment2]
            print(shapiro.test((x - mean(x)) / sd(x)))
            ## Data with Standard Scaling
            print(shapiro.test(scale(x)))
        }
    }
}

if (!interactive()) {
    main()
}

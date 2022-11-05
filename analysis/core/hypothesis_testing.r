if (!require("effsize")) install.packages("effsize")
if (!require("readxl")) install.packages("readxl")
if (!require("ARTool")) install.packages("ARTool")

library(effsize)
library(readxl)
library(ARTool)

source("utils.r")

main <- function() {
    df <- read_dataset()

    # Hypothesis H^pl (kruskal test)
    KT_Result_energy_usage <- kruskal.test(energy_usage ~ language, data = df)
    KT_Result_execution_time <- kruskal.test(execution_time ~ language, data = df)
    KT_Result_memory_usage <- kruskal.test(memory_usage ~ language, data = df)

    # Hypothesis H^re (wilcoxon test)
    wilcox_test_energy_usage <- wilcox.test(energy_usage ~ runtime, data = df)
    wilcox_test_execution_time <- wilcox.test(execution_time ~ runtime, data = df)
    wilcox_test_memory_usage <- wilcox.test(memory_usage ~ runtime, data = df)

    # Hypothesis H^{pl, re} (ART transformation + ANOVA)
    # energy usage
    model_energy_usage <- art(energy_usage ~ language * runtime, data = df)
    Analysis_Variance_ART_energy_usage <- anova(art(energy_usage ~ language * runtime, data = df))
    marginal_language_energy_usage <- art.con(model_energy_usage, "language")
    marginal_runtime_energy_usage <- art.con(model_energy_usage, "runtime")
    marginal_language_runtime_energy_usage <- art.con(model_energy_usage, "language:runtime", adjust = "none")
    # execution time
    model_execution_time <- art(execution_time ~ language * runtime, data = df)
    Analysis_Variance_ART_execution_time <- anova(model_execution_time)
    marginal_language_execution_time <- art.con(model_execution_time, "language")
    marginal_runtime_execution_time <- art.con(model_execution_time, "runtime")
    marginal_language_runtime_execution_time <- art.con(model_execution_time, "language:runtime", adjust = "none")
    # memory usage
    memory_usage_time <- art(memory_usage ~ language * runtime, data = df)
    Analysis_Variance_ART_memory_usage <- anova(memory_usage_time)
    marginal_language_memory_usage <- art.con(memory_usage_time, "language")
    marginal_runtime_memory_usage <- art.con(memory_usage_time, "runtime")
    marginal_language_runtime_memory_usage <- art.con(memory_usage_time, "language:runtime", adjust = "none")
}

if (!interactive()) {
    main()
}

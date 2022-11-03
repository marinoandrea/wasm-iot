
#' Read the Experimental Dataset
#' 
#' This function prompts the user to select
#' a CSV file in the required format and returns
#' a dataframe that can be used in our analysis
#' scripts.
read_dataset <- function() {
  df <- read.csv(file.choose(), sep='\t')
  return(data.frame(
    language = as.factor(c(df$language)),
    runtime = as.factor(c(df$runtime)),
    energy_usage = as.numeric(df$energy_usage),
    execution_time = as.numeric(df$execution_time) / 1000, # in seconds
    memory_usage = as.numeric(df$memory_usage),
    cpu_usage = as.numeric(df$cpu_usage)))
}
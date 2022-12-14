#Importing required packages 
install.packages("readxl"); library("readxl") #

#defining data set#
dataset <- read_excel(file.choose())

#defining dataset data frmae#
dataset_frame <- data.frame(language = factor(c(dataset$language)),               #add programming language to data frame as level factor
                            runtime = factor(c(dataset$runtime)),                 #add run time environment to data frame as level factor
                            energy_usage = as.numeric(dataset$energy_usage),      #add energy usage to data frame as number
                            execution_time = as.numeric(dataset$execution_time),  #add execution time to data frame as number
                            memory_usage = as.numeric(dataset$memory_usage),      #add memory usage to data frame as number
                            cpu_usage = as.numeric(dataset$cpu_usage))            #add cpu usage to data frame as number

#outlier_remover function receive a variable as a column of data set to find and remove outliers
outlier_remover <- function(variable) {
  Q <- quantile(variable, probs=c(.25, .75), na.rm = FALSE)
  iqr <- IQR(variable)
  eliminated<- subset(dataset_frame, variable > (Q[1] - 1.5*iqr) & variable < (Q[2]+1.5*iqr))
  outliers <- boxplot(variable, plot=FALSE)$out
  dataset_frame <- dataset_frame[-which(variable %in% outliers),]
  return(dataset_frame)
}
#loop to execute the function for all dependent variable 
for (dependent_variable in c(dataset_frame$energy_usage, dataset_frame$execution_time, dataset_frame$memory_usage, dataset_frame$cpu_usage)) {
  dataset_frame <- outlier_remover(dependent_variable)
}

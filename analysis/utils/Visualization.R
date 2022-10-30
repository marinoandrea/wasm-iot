# In this file all Visualization which are not depend on data distribution 

# Loading


#Installing and importing the required libraries
install.packages("VIM"); library(VIM) #Visualization of the missing values
install.packages("ggpubr"); library(ggpubr) #Visualization
install.packages("ggplot2"); library(ggplot2) #Visualization
install.packages("plyr"); library(plyr) #Mean by group for the dentistry plot
install.packages("bestNormalize"); library(bestNormalize) #Find the best transformation to make data Normal  
install.packages("readxl"); library("readxl")

#Importing Data Sets
data_set <- read.csv(file.choose())
data_set <- read_excel(file.choose())

#Showing the patter of miss values and their distribution by the plot
Missing_data_Pattern <- function(input_data_set) {
  
  #Preparing data frame for showing missing values visually
  df_data_set_eight_columns <- data.frame(
    consumed_Energy_c_wasmer = c(input_data_set[1:30]),
    consumed_Energy_c_wasmtime = c(input_data_set[31:60]),
    consumed_Energy_go_wasmer = c(input_data_set[61:90]),
    consumed_Energy_go_wasmtime = c(input_data_set[91:120]),
    consumed_Energy_rust_wasmer = c(input_data_set[121:150]),
    consumed_Energy_rust_wasmtime = c(input_data_set[151:180])
    #consumed_Energy_JS_wasmer = c(input_data_set[181:210]),
    #consumed_Energy_JS_wasmtime = c(input_data_set[211:240])
  )
 
   colnames(df_data_set_eight_columns) <- c("c_wasmer","c_wasmtime",
                                           "go_wasmer","go_wasmtime",
                                           "rust_wasme","rust_wasmtime"
                                           #"JS_wasmer", "rust_wasmtime"
                                           )
  #Visualization of the missing values with NA label
  #source of used code: https://www.analyticsvidhya.com/blog/2016/03/tutorial-powerful-packages-imputing-missing-values/
  
  mice_plot <- aggr(df_data_set_eight_columns, col=c('navyblue','yellow'),
                    numbers=TRUE, sortVars=TRUE,
                    labels=names(df_data_set_eight_columns$Programming_Language), cex.axis=.7,
                    gap=3, ylab=c("Missing Data Proportion","Pattern of Miss value in storage"))
  
  #returning the Missing_data_Pattern plot
  return(mice_plot)
}
Missing_data_Pattern(input_data_set = data_set$storage)


#Imputing missing values
#This function put the average of above and below value as miss data
imputing_above_below_method <- function(data_set) {
  NA_Index <- which(is.na(data_set))
  for (val in NA_Index) {
    if(is.na(data_set$Consumed_Energy[val+1])){
       data_set$Consumed_Energy[val] = (data_set$Consumed_Energy[val-1]+data_set$Consumed_Energy[val+2])/2
    }
    else if(is.na(data_set$Consumed_Energy[val-1])){
      data_set$Consumed_Energy[val] = (data_set$Consumed_Energy[val-2]+data_set$Consumed_Energy[val+1])/2
    }
    else if(is.na(data_set$Consumed_Energy[val-1])  && is.na(data_set$Consumed_Energy[val+1])){
      data_set$Consumed_Energy[val] = (data_set$Consumed_Energy[val-2]+data_set$Consumed_Energy[val+2])/2
    }
    else{
      data_set$Consumed_Energy[val] = (data_set$Consumed_Energy[val-1]+data_set$Consumed_Energy[val+1])/2
    }
   }
  return(data_set)
}
data_set <- imputing_above_below_method(data_set)

# Data frame for four PL in four columns
df_data_set_four_columns <- data.frame(
  consumed_Energy_P1 = c(data_set$Consumed_Energy[1:200]),
  consumed_Energy_P2 = c(data_set$Consumed_Energy[201:400]),
  consumed_Energy_P3 = c(data_set$Consumed_Energy[401:600]),
  consumed_Energy_P4 = c(data_set$Consumed_Energy[601:800])
)
colnames(df_data_set_four_columns) <- c("PL-1","PL-2","PL-3","PL-4")

# Data frame for four PL in one columns

df_data_set_one_column <- data.frame(language = factor(c(data_set$language)),
                                     runtime = factor(c(data_set$runtime)),
                                     benchmark_algorithm = factor(c(data_set$algorithm)),
                                     energy_usage = as.numeric(data_set$energy_usage),
                                     execution_time = as.numeric(data_set$execution_time),
                                     memory_usage = as.numeric(data_set$memory_usage),
                                     cpu_usage = as.numeric(data_set$cpu_usage),
                                     storage = as.numeric(data_set$storage))




###############Checking Normality###############

####Visual Methods####

##density plot##

#Mean for each PL for the mean line
mu <- ddply(df_data_set_one_column, "runtime", summarise, grp.mean=mean(storage))

# Change density plot fill colors by groups

energy_usage_data <- df_data_set_one_column$energy_usage
execution_time_data <- df_data_set_one_column$execution_time
memory_usage_data <- df_data_set_one_column$memory_usage
cpu_usage_data <- df_data_set_one_column$cpu_usage
storage_data <- df_data_set_one_column$storage

ggplot(df_data_set_one_column, aes(x=storage_data, fill=runtime)) +
  geom_density()
# Use semi-transparent fill
p<-ggplot(df_data_set_one_column, aes(x=storage_data, fill=runtime)) +
  geom_density(alpha=0.3)
p
# Add mean lines
p+geom_vline(data=mu, aes(xintercept=grp.mean, color=runtime),
             linetype="dashed")


##Q-Q plot##
ggqqplot(df_data_set_one_column, x = "storage",
         color = "benchmark_algorithm")

require(gridExtra)



plot1 <- ggqqplot(df_data_set_one_column[df_data_set_one_column$language == 'c' & df_data_set_one_column$runtime == "wasmer", ]$storage, title = "C & wasmer")

plot2 <- ggqqplot(df_data_set_one_column[df_data_set_one_column$language == 'go' & df_data_set_one_column$runtime == "wasmer", ]$storage, title = "GO & wasmer")

plot3 <- ggqqplot(df_data_set_one_column[df_data_set_one_column$language == 'rust' & df_data_set_one_column$runtime == "wasmer", ]$storage, title = "RUST & wasmer")

#plot4 <- ggqqplot(df_data_set_one_column[df_data_set_one_column$language == 'js' & df_data_set_one_column$runtime == "wasmer", ]$storage, title = "JS & wasmer")

plot5 <- ggqqplot(df_data_set_one_column[df_data_set_one_column$language == 'c' & df_data_set_one_column$runtime == "wasmtime", ]$storage, title = "C & wasmtime")

plot6 <- ggqqplot(df_data_set_one_column[df_data_set_one_column$language == 'go' & df_data_set_one_column$runtime == "wasmtime", ]$storage, title = "GO & wasmtime")

plot7 <- ggqqplot(df_data_set_one_column[df_data_set_one_column$language == 'rust' & df_data_set_one_column$runtime == "wasmtime", ]$storage, title = "RUST & wasmtime")

#plot8 <- ggqqplot(df_data_set_one_column[df_data_set_one_column$language == 'js' & df_data_set_one_column$runtime == "wasmtime", ]$storage, title = "JS & wasmtime")

grid.arrange(plot1, plot2, plot3,plot5, plot6, plot7, ncol = 3)


##Histogram##
#all in one
ggplot(df_data_set_one_column, aes(energy_usage, color = language)) +
  geom_histogram(binwidth = 100)

# Histogram for each runtime
energy_usage_Histogram_wasmer <- ggplot(data = df_data_set_one_column[df_data_set_one_column$runtime == 'wasmer',], aes(x = energy_usage)) +
  geom_histogram(color = 'turquoise4', binwidth = 200) + labs(title = "wasmer & energy_usage")

energy_usage_Histogram_wasmtime <- ggplot(data = df_data_set_one_column[df_data_set_one_column$runtime == 'wasmtime',], aes(x = energy_usage)) +
  geom_histogram(color = 'turquoise4', binwidth = 200) + labs(title = "wasmtime & energy_usage")

execution_time_Histogram_wasmer <- ggplot(data = df_data_set_one_column[df_data_set_one_column$runtime == 'wasmer',], aes(x = execution_time)) +
  geom_histogram(color = 'turquoise4', binwidth = 70000) + labs(title = "wasmer & execution_time")

execution_time_Histogram_wasmtime <- ggplot(data = df_data_set_one_column[df_data_set_one_column$runtime == 'wasmtime',], aes(x = execution_time)) +
  geom_histogram(color = 'turquoise4', binwidth = 70000) + labs(title = "wasmtime & execution_time")

memory_usage_Histogram_wasmer <- ggplot(data = df_data_set_one_column[df_data_set_one_column$runtime == 'wasmer',], aes(x = memory_usage)) +
  geom_histogram(color = 'turquoise4', binwidth = 0.3) + labs(title = "wasmer & memory_usage")

memory_usage_Histogram_wasmtime <- ggplot(data = df_data_set_one_column[df_data_set_one_column$runtime == 'wasmtime',], aes(x = memory_usage)) +
  geom_histogram(color = 'turquoise4', binwidth = 0.3) + labs(title = "wasmtime & memory_usage")

cpu_usage_Histogram_wasmer <- ggplot(data = df_data_set_one_column[df_data_set_one_column$runtime == 'wasmer',], aes(x = cpu_usage)) +
  geom_histogram(color = 'turquoise4', binwidth = 1.5) + labs(title = "wasmer & cpu_usage")

cpu_usage_Histogram_wasmtime <- ggplot(data = df_data_set_one_column[df_data_set_one_column$runtime == 'wasmtime',], aes(x = cpu_usage)) +
  geom_histogram(color = 'turquoise4', binwidth = 1.5) + labs(title = "wasmtime & cpu_usage")

storage_Histogram_wasmer <- ggplot(data = df_data_set_one_column[df_data_set_one_column$runtime == 'wasmer',], aes(x = storage)) +
  geom_histogram(color = 'turquoise4', binwidth = 90000) + labs(title = "wasmer & storage")

storage_Histogram_wasmtime <- ggplot(data = df_data_set_one_column[df_data_set_one_column$runtime == 'wasmtime',], aes(x = storage)) +
  geom_histogram(color = 'turquoise4', binwidth = 90000) + labs(title = "wasmtime & storage")

grid.arrange(energy_usage_Histogram_wasmer,
             energy_usage_Histogram_wasmtime,
             execution_time_Histogram_wasmer,
             execution_time_Histogram_wasmtime,
             memory_usage_Histogram_wasmer,
             memory_usage_Histogram_wasmtime,
             cpu_usage_Histogram_wasmer,
             cpu_usage_Histogram_wasmtime,
             storage_Histogram_wasmer,
             storage_Histogram_wasmtime,
             ncol = 2)


# Histogram for each programming languages
energy_usage_Histogram_C <- ggplot(data = df_data_set_one_column[df_data_set_one_column$language == 'c',], aes(x = energy_usage)) +
  geom_histogram(color = 'turquoise4', binwidth = 20) + labs(title = "C & energy_usage")

execution_time_Histogram_C  <- ggplot(data = df_data_set_one_column[df_data_set_one_column$language == 'c',], aes(x = execution_time)) +
  geom_histogram(color = 'turquoise4', binwidth = 10000) + labs(title = "C & execution_time")

memory_usage_Histogram_C  <- ggplot(data = df_data_set_one_column[df_data_set_one_column$language == 'c',], aes(x = memory_usage)) +
  geom_histogram(color = 'turquoise4', binwidth = 0.09) + labs(title = "C & memory_usage")

cpu_usage_Histogram_C  <- ggplot(data = df_data_set_one_column[df_data_set_one_column$language == 'c',], aes(x = cpu_usage)) +
  geom_histogram(color = 'turquoise4', binwidth = 0.07) + labs(title = "C & cpu_usage")

storage_Histogram_C  <- ggplot(data = df_data_set_one_column[df_data_set_one_column$language == 'c',], aes(x = storage)) +
  geom_histogram(color = 'turquoise4', binwidth = 700) + labs(title = "C & storage")


energy_usage_Histogram_go <- ggplot(data = df_data_set_one_column[df_data_set_one_column$language == 'go',], aes(x = energy_usage)) +
  geom_histogram(color = 'turquoise4', binwidth = 200) + labs(title = "GO & energy_usage")

execution_time_Histogram_go  <- ggplot(data = df_data_set_one_column[df_data_set_one_column$language == 'go',], aes(x = execution_time)) +
  geom_histogram(color = 'turquoise4', binwidth = 90000) + labs(title = "GO & execution_time")

memory_usage_Histogram_go  <- ggplot(data = df_data_set_one_column[df_data_set_one_column$language == 'go',], aes(x = memory_usage)) +
  geom_histogram(color = 'turquoise4', binwidth = 0.7) + labs(title = "GO & memory_usage")

cpu_usage_Histogram_go  <- ggplot(data = df_data_set_one_column[df_data_set_one_column$language == 'go',], aes(x = cpu_usage)) +
  geom_histogram(color = 'turquoise4', binwidth = 1.5) + labs(title = "GO & cpu_usage")

storage_Histogram_go  <- ggplot(data = df_data_set_one_column[df_data_set_one_column$language == 'go',], aes(x = storage)) +
  geom_histogram(color = 'turquoise4', binwidth = 900) + labs(title = "GO & storage")



energy_usage_Histogram_RUST <- ggplot(data = df_data_set_one_column[df_data_set_one_column$language == 'rust',], aes(x = energy_usage)) +
  geom_histogram(color = 'turquoise4', binwidth = 20) + labs(title = "RUST & energy_usage")

execution_time_Histogram_RUST  <- ggplot(data = df_data_set_one_column[df_data_set_one_column$language == 'rust',], aes(x = execution_time)) +
  geom_histogram(color = 'turquoise4', binwidth = 10000) + labs(title = "RUST & execution_time")

memory_usage_Histogram_RUST  <- ggplot(data = df_data_set_one_column[df_data_set_one_column$language == 'rust',], aes(x = memory_usage)) +
  geom_histogram(color = 'turquoise4', binwidth = 0.07) + labs(title = "RUST & memory_usage")

cpu_usage_Histogram_RUST  <- ggplot(data = df_data_set_one_column[df_data_set_one_column$language == 'rust',], aes(x = cpu_usage)) +
  geom_histogram(color = 'turquoise4', binwidth = 0.6) + labs(title = "RUST & cpu_usage")

storage_Histogram_RUST  <- ggplot(data = df_data_set_one_column[df_data_set_one_column$language == 'rust',], aes(x = storage)) +
  geom_histogram(color = 'turquoise4', binwidth = 900) + labs(title = "RUST & storage")



grid.arrange(energy_usage_Histogram_C,
             execution_time_Histogram_C,
             memory_usage_Histogram_C,
             cpu_usage_Histogram_C,
             storage_Histogram_C,
             energy_usage_Histogram_go,
             execution_time_Histogram_go,
             memory_usage_Histogram_go,
             cpu_usage_Histogram_go,
             storage_Histogram_RUST,
             energy_usage_Histogram_RUST,
             execution_time_Histogram_RUST,
             memory_usage_Histogram_RUST,
             cpu_usage_Histogram_RUST,
             storage_Histogram_RUST,
             ncol = 5)

# Histogram with density plot for each programming language
a <- ggplot(data = 8*df_data_set_four_columns, aes(x = `PL-2`))
a + geom_histogram(aes(y = stat(density)), 
                   colour="black", fill="white") +
  labs(title="Rust & WASMTime",x="Energy usage", y = "Density") +
  geom_density(alpha = 0.2, fill = "#FF6666") 


######Normality Statistics Test######

##Shapiro-Wilk’s test##
#From the output, the p-value > 0.05 implying that data are not significantly different from normal distribution. 

#Shapiro-Wilk’s test  for C
shapiro.test(df_data_set_one_column[df_data_set_one_column$language == 'c',]$energy_usage)
shapiro.test(df_data_set_one_column[df_data_set_one_column$language == 'c',]$execution_time)
shapiro.test(df_data_set_one_column[df_data_set_one_column$language == 'c',]$memory_usage)
shapiro.test(df_data_set_one_column[df_data_set_one_column$language == 'c',]$cpu_usage)
shapiro.test(df_data_set_one_column[df_data_set_one_column$language == 'c',]$storage)
#Shapiro-Wilk’s test  for GO
shapiro.test(df_data_set_one_column[df_data_set_one_column$language == 'go',]$energy_usage)
shapiro.test(df_data_set_one_column[df_data_set_one_column$language == 'go',]$execution_time)
shapiro.test(df_data_set_one_column[df_data_set_one_column$language == 'go',]$memory_usage)
shapiro.test(df_data_set_one_column[df_data_set_one_column$language == 'go',]$cpu_usage)
shapiro.test(df_data_set_one_column[df_data_set_one_column$language == 'go',]$storage)
#Shapiro-Wilk’s test  for RUST
shapiro.test(df_data_set_one_column[df_data_set_one_column$language == 'rust',]$energy_usage)
shapiro.test(df_data_set_one_column[df_data_set_one_column$language == 'rust',]$execution_time)
shapiro.test(df_data_set_one_column[df_data_set_one_column$language == 'rust',]$memory_usage)
shapiro.test(df_data_set_one_column[df_data_set_one_column$language == 'rust',]$cpu_usage)
shapiro.test(df_data_set_one_column[df_data_set_one_column$language == 'rust',]$storage)
#Shapiro-Wilk’s test  for JS
shapiro.test(df_data_set_one_column[df_data_set_one_column$language == 'js',]$energy_usage)
shapiro.test(df_data_set_one_column[df_data_set_one_column$language == 'js',]$execution_time)
shapiro.test(df_data_set_one_column[df_data_set_one_column$language == 'js',]$memory_usage)
shapiro.test(df_data_set_one_column[df_data_set_one_column$language == 'js',]$cpu_usage)
shapiro.test(df_data_set_one_column[df_data_set_one_column$language == 'js',]$storage)

#Shapiro-Wilk’s test for wasmer
shapiro.test(df_data_set_one_column[df_data_set_one_column$runtime == 'wasmer',]$energy_usage)
shapiro.test(df_data_set_one_column[df_data_set_one_column$runtime == 'wasmer',]$execution_time)
shapiro.test(df_data_set_one_column[df_data_set_one_column$runtime == 'wasmer',]$memory_usage)
shapiro.test(df_data_set_one_column[df_data_set_one_column$runtime == 'wasmer',]$cpu_usage)
shapiro.test(df_data_set_one_column[df_data_set_one_column$runtime == 'wasmer',]$storage)

#Shapiro-Wilk’s test for wasmtime
shapiro.test(df_data_set_one_column[df_data_set_one_column$runtime == 'wasmtime',]$energy_usage)
shapiro.test(df_data_set_one_column[df_data_set_one_column$runtime == 'wasmtime',]$execution_time)
shapiro.test(df_data_set_one_column[df_data_set_one_column$runtime == 'wasmtime',]$memory_usage)
shapiro.test(df_data_set_one_column[df_data_set_one_column$runtime == 'wasmtime',]$cpu_usage)
shapiro.test(df_data_set_one_column[df_data_set_one_column$runtime == 'wasmtime',]$storage)

#######Boxplot#######
# Box Plot based on both runtime and programming language
BoxPlot_runtime_programming_language_energy_usage<- ggplot(df_data_set_one_column, aes(x=language, y=energy_usage, color=language, fill = runtime)) +
  geom_boxplot(outlier.colour="red", outlier.shape=8, outlier.size=1)+
  labs(title="Plot of energy usage per Programming Languages and Runtimes",x="programming languages", y = "energy usage")+
  scale_fill_grey() + theme_classic()

BoxPlot_runtime_programming_language_execution_time<- ggplot(df_data_set_one_column, aes(x=language, y=execution_time, color=language, fill = runtime)) +
  geom_boxplot(outlier.colour="red", outlier.shape=8, outlier.size=1)+
  labs(title="Plot of execution time per Programming Languages and Runtimes",x="programming languages", y = "execution time")+
  scale_fill_grey() + theme_classic()

BoxPlot_runtime_programming_language_memory_usage<- ggplot(df_data_set_one_column, aes(x=language, y=memory_usage, color=language, fill = runtime)) +
  geom_boxplot(outlier.colour="red", outlier.shape=8, outlier.size=1)+
  labs(title="Plot of memory usage per Programming Languages and Runtimes",x="programming languages", y = "memory usage")+
  scale_fill_grey() + theme_classic()

BoxPlot_runtime_programming_language_cpu_usage<- ggplot(df_data_set_one_column, aes(x=language, y=cpu_usage, color=language, fill = runtime)) +
  geom_boxplot(outlier.colour="red", outlier.shape=8, outlier.size=1)+
  labs(title="Plot of CPU usage per Programming Languages and Runtimes",x="programming languages", y = "cpu usage")+
  scale_fill_grey() + theme_classic()

BoxPlot_runtime_programming_language_storage<- ggplot(df_data_set_one_column, aes(x=language, y=storage, color=language, fill = runtime)) +
  geom_boxplot(outlier.colour="red", outlier.shape=8, outlier.size=1)+
  labs(title="Plot of storage per Programming Languages and Runtimes",x="programming languages", y = "storage")+
  scale_fill_grey() + theme_classic()

##########################################################
# Box Plot based on programming language
BoxPlot_programming_language_energy_usage<- ggplot(df_data_set_one_column, aes(x=language, y=energy_usage, fill=language)) +
  geom_boxplot(outlier.colour="red", outlier.shape=8, outlier.size=1)+
  labs(title="Plot of energy usage per programming languages",x="programming languages", y = "energy usage")

BoxPlot_programming_language_execution_time<- ggplot(df_data_set_one_column, aes(x=language, y=execution_time, fill = language)) +
  geom_boxplot(outlier.colour="red", outlier.shape=8, outlier.size=1)+
  labs(title="Plot of execution time per programming languages",x="programming languages", y = "execution time")


BoxPlot_programming_language_memory_usage<- ggplot(df_data_set_one_column, aes(x=language, y=memory_usage, fill = language)) +
  geom_boxplot(outlier.colour="red", outlier.shape=8, outlier.size=1)+
  labs(title="Plot of memory usage per programming languages",x="programming languages", y = "memory usage")


BoxPlot_programming_language_cpu_usage<- ggplot(df_data_set_one_column, aes(x=language, y=cpu_usage, fill = language)) +
  geom_boxplot(outlier.colour="red", outlier.shape=8, outlier.size=1)+
  labs(title="Plot of CPU usage per programming languages",x="programming languages", y = "cpu usage")


BoxPlot_programming_language_storage<- ggplot(df_data_set_one_column, aes(x=language, y=storage, fill = language)) +
  geom_boxplot(outlier.colour="red", outlier.shape=8, outlier.size=1)+
  labs(title="Plot of storage per programming languages",x="programming languages", y = "storage")





#########################################################
# Box Plot based on Runtimes
BoxPlot_runtime_energy_usage<- ggplot(df_data_set_one_column, aes(x=runtime, y=energy_usage, fill=runtime)) +
  geom_boxplot(outlier.colour="red", outlier.shape=8, outlier.size=1)+
  labs(title="Plot of energy usage per  runtimes",x="Runtimes", y = "energy usage")

BoxPlot_runtime_execution_time<- ggplot(df_data_set_one_column, aes(x=runtime, y=execution_time, fill = runtime)) +
  geom_boxplot(outlier.colour="red", outlier.shape=8, outlier.size=1)+
  labs(title="Plot of execution time per runtime",x="runtime", y = "execution time")


BoxPlot_runtime_memory_usage<- ggplot(df_data_set_one_column, aes(x=runtime, y=memory_usage, fill = runtime)) +
  geom_boxplot(outlier.colour="red", outlier.shape=8, outlier.size=1)+
  labs(title="Plot of memory usage per runtime",x="runtime", y = "memory usage")


BoxPlot_runtime_cpu_usage<- ggplot(df_data_set_one_column, aes(x=runtime, y=cpu_usage, fill = runtime)) +
  geom_boxplot(outlier.colour="red", outlier.shape=8, outlier.size=1)+
  labs(title="Plot of CPU usage per runtime",x="runtime", y = "cpu usage")


BoxPlot_runtime_storage<- ggplot(df_data_set_one_column, aes(x=runtime, y=storage, fill = runtime)) +
  geom_boxplot(outlier.colour="red", outlier.shape=8, outlier.size=1)+
  labs(title="Plot of storage per runtime",x="runtime", y = "storage")

grid.arrange(BoxPlot_runtime_programming_language_energy_usage,
             BoxPlot_runtime_programming_language_execution_time,
             BoxPlot_runtime_programming_language_memory_usage,
             BoxPlot_runtime_programming_language_cpu_usage,
             BoxPlot_runtime_programming_language_storage,
             BoxPlot_programming_language_energy_usage,
             BoxPlot_programming_language_execution_time,
             BoxPlot_programming_language_memory_usage,
             BoxPlot_programming_language_cpu_usage,
             BoxPlot_programming_language_storage,
             BoxPlot_runtime_energy_usage,
             BoxPlot_runtime_execution_time,
             BoxPlot_runtime_memory_usage,
             BoxPlot_runtime_cpu_usage,
             BoxPlot_runtime_storage,
             ncol = 2)
#Normalization using the bestNormalize Package as transformation-estimating functions

# Data frame for four PL in four columns


bestNormalize(x = df_data_set_four_columns$`PL-1`)










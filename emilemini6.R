# Mini-Project 6 Validation

# clear workspace
rm(list = ls())

# load packages
library(tidyverse)
library(magrittr)

# load data
data <- read.csv('"C:\Users\emile\Downloads\rrData (1).csv"') # adjust path to where your .csv file is, data should be 250 obs. x 4 variables
data$participant <- factor(data$participant) # make participant variable a factor
table(data$participant) # should be 10 repeats per participant


# LINE PLOT ----
# reshape the data into long format so that there are 4 columns: participant, time, feature (rr or rr_fft), and value
#data_long <- data %>% gather() # fill gather() to create data_long which should be 500 obs. x 4 variables
# reshape to long format
data_long <- data %>% gather(key = "feature", value = "value", rr, rr_fft)

# line plot
ggplot(data_long, aes(x = time, y = value, color = feature, group = feature)) +
  geom_line() +
  facet_wrap(~participant) +
  xlab("Time") +
  ylab("Respiration Rate") +
  ggtitle("Figure 1: Line Plot")

# line plot
#ggplot(data_long, aes()) +
 # ggtitle("Figure 1: Line Plot") 

# BAR PLOT ----
# find the mean and standard deviation within each participant-feature
summary_data <- data_long %>% group_by(participant, feature) %>% summarize(mean = mean(value), sd = sd(value), .groups = "drop") # fill in group_by() and summarize() functions, should be 50 obs. x 4 variables

# bar plot
ggplot(summary_data, aes(x = participant, y = mean, fill = feature)) + geom_bar(stat = "identity", position = position_dodge()) + geom_errorbar(aes(ymin = mean - sd, ymax = mean + sd), position = position_dodge(0.9), width = 0.2) + xlab("participant")+ylab("mean rr") + ggtitle("figure 2: bar plot")
) 
  ggtitle("Figure 2: Bar Plot")


# SCATTER PLOT ----
# fit linear model to data, y = rr_fft, x = rr)
fit <- lm(data$rr_fft ~ data$rr)

# combine text for equation
eq <- substitute(italic(y) == a + b %.% italic(x)*", "~~italic(r)^2~"="~r2, 
                 list(a = format(unname(coef(fit)[1]), digits = 2),
                      b = format(unname(coef(fit)[2]), digits = 2),
                      r2 = format(summary(fit)$r.squared, digits = 2)))
text <- as.character(as.expression(eq));

# scatter plot
ggplot(data, aes(x = rr, y = rr_fft)) + geom_point(alpha = 0.5) + geom_smooth(method = "lm", se = FALSE) + xlab("rr(peak detection)") + ylab("rr fft (freq analysis)")
  ggtitle("Figure 3: Scatter Plot") +
  annotate("text", x = 30, y = 30, label = text, parse = TRUE) 


# BLAND-ALTMAN PLOT ----
# calculate and save the differences between the two measures and the averages of the two measures
data %<>% mutate(diff = rr-rr_fft, avg = (rr + rr_fft)/2)

#compute the mean and limits of agreement (LoA)
mean_bias <- mean(data$diff)
sd_diff <- sd(data$diff)
LoA_upper <- mean_bias + 1.96 * sd_diff
LoA_lower <-  mean_bias - 1.96*sd_diff

# Bland-Altman plot
ggplot(data, aes(x = avg, y = diff)) + geom_point(alpha = 0.5) + geom_hline(yintercept = mean_bias, color ="blue") + geom_hline(yintercept = LoA_upper, linetype = "dashed", color = "red" ) + geom_hline(yintercept = LoA_lower, linetype = "dashed", color = "red" ) +
  xlab("avg rr") + ylab("difference(rr - rr fft)") + 
  ggtitle("Figure 4: Bland-Altman Plot") 


# BOX PLOT ----
# box plot
ggplot(data, aes(x = participant, y = diff, fill = participant)) + geom_boxplot() + xlab("Participant") + ylab("difference(rr - rrfft)") +
  ggtitle("Figure 5: Box Plot") 
theme(legend.position = "none")

library(tidyverse)
library(lubridate)

tidy_tbl <- selftracking %>%
  mutate(Date = as.POSIXct(paste0("2026-", Date), format = "%Y-%d-%b"),Reading = as.integer(Reading),StressScore = as.numeric(`Stress Score`),Workload = as.numeric(Workload),Heartrate = as.numeric(Heartrate),SleepScore = as.numeric(`Sleep Score`)) %>%
  select(Reading, Date, StressScore, Workload, Heartrate, SleepScore) %>%
  pivot_longer( cols= c(StressScore, Workload, Heartrate, SleepScore),names_to  = "feature", values_to = "value") %>%
  rename(id = Reading, time = Date) %>%
  as_tibble()

print(tidy_tbl)

summary_table <- tidy_tbl %>%
  group_by(feature) %>%
  summarise(Mean = mean(value, na.rm = TRUE),`Standard Deviation` = sd(value, na.rm = TRUE)) %>%
  mutate(Units = case_when(feature == "Heartrate" ~ "bpm",TRUE ~ "-")) %>%
  select(Feature = feature, Units, Mean, `Standard Deviation`)

print(summary_table)


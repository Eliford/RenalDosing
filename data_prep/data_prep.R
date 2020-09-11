library(readr)
patients <- read_csv("data_prep/patients.csv")

saveRDS(patients, file = 'data_prep/patients.RDS')
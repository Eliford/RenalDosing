library(RSQLite)
library(DBI)
library(dplyr)

# Create a connection object with SQLite
conn <- dbConnect(
  RSQLite::SQLite(),
  'data/patients.sqlite'
)

create_patients_query = "CREATE TABLE patients (
  uid                             TEXT PRIMARY KEY,
  patient_id                     TEXT,
  age                             REAL,
  weight                          REAL,
  serum_creatinine                REAL,
  sex                             TEXT,
  gfr                             REAL,
  created_at                      TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
)"

dbExecute(conn, "DROP TABLE IF EXISTS patients")
dbExecute(conn, create_patients_query)

dat <- readRDS("data_prep/patients.RDS")

dat$uid <- uuid::UUIDgenerate(n = nrow(dat))

DBI::dbWriteTable(
  conn,
  name = "patients",
  value = dat,
  overwrite = FALSE,
  append = TRUE
)

dbListTables(conn)

dbDisconnect(conn)

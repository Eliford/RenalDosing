#UI and server packages
library(shiny)
library(shinyMobile)
library(DT)
#database
library(RSQLite)
#other R packages
library(tidyverse)

## Drug look-up tables with dose recommendations 
drugs<-read_csv("data/drugs.csv")
antiglycemics <- read_csv("data/antiglycemics.csv")
statins <- read_csv("data/statins.csv")

#Patient variables for RenFunDB
patientFields <- c("patientID","age","weight", "creatinine","sex")

#Path to database
sqlitepath <- paste0(getwd(), "/data/RenFunDB")

#A function to create SQlite database
#' @param ... = names of full directory paths to database
#' @param table name of a table to create within the database
#' @param fields a vector of field names
#' 
create_database<-function(path, table, fields = c("patientID", "age", "weight", "creatinine", "sex")){
  #check if the database exists
  exist<-file.exists(path = path)
  createQuery <- paste("CREATE TABLE", table, "(", paste0(fields, collapse = ","), ")")
  #Create database and tables if does not exist
  if(!exist){
    db <- dbConnect(SQLite(),path)
    dbSendQuery(conn=db, createQuery)
  }
  #return the path for use in saving and loading files
  return(NULL)
}
#Use the function
create_database(path = sqlitepath, table = "Patients")

#A function to save user inputs
#' @param data a reactive() output containing UI input variables
#' @param table a name of database table
#' @param path full path to database
saveData <- function(data, table, path) {
  if(length(data)== 5){
    query <- sprintf(
        "INSERT INTO %s ('%s') VALUES ('%s')",
        table,
        paste(names(data), collapse ="','" ),
        paste(data, collapse="','")
      )
    #browser()
    db <- dbConnect(SQLite(),path)
    dbSendQuery(conn= db, query)
    recordStat <- "saved"
    } else {
      recordStat <- "failed to save!! All 5 inputs are required"
      }
  return(recordStat)
}


#A function to fetch data from the database
#' @param table a name of a database table
#' @param path a full path to database
#' 
fetch_data <- function(table, path){
  db <- dbConnect(SQLite(), path)
  data<-dbSendQuery(conn=db, paste0("SELECT*FROM ", table))
  data<-fetch(data)
  return(data)
}

#Test the fetch_data function 
#appDBpath <- "C:/Users/Samsung/Documents/RenalDosing/dose_adjustment/data/RenFunDB"
#renfundata <- fetch_data(table = "Patients", path = appDBpath)

#A function for dose recommendation in patient with renal impairment
#' @param drug a generic name of a drug to search for dose recommendations
#' 
search_dose <- function(drugname){
  drug_dosing <- drugs %>% filter(drug==drugname) %>% select(3:7)
  names(drug_dosing) <- c("Name", "Usual dosing", "GFR >= 50", "GFR>=10&GFR<50", "GFR < 10")
  return(drug_dosing)
}

library(shiny)
#library(DT)
library(tidyverse)


#drugs<-read_csv("data/drugs.csv")
#antiglycemics <- read_csv("data/antiglycemics.csv")
#statins <- read_csv("data/statins.csv")

# Define server logic required to calculate GFR
server =  function(input, output, session){
    
    ###Start of calculate CRCL event
    observeEvent(input$calculate,{
        data <- data.frame(
            PatientAge = as.numeric(input$age),
            PatientWeight = as.numeric(input$weight),
            SerumCreatinine = as.numeric(input$creatinine),
            PatientSex = input$sex
        )
        
        # Determine the gfr by "sex","age"
        if (data$PatientSex == "Male") {
            gfr = ((140 - data$PatientAge) * data$PatientWeight)/(0.81 * data$SerumCreatinine)
        } else {
            gfr = ((140 - data$PatientAge) * data$PatientWeight * 0.85)/(0.81 * data$SerumCreatinine)
        }
        # create a dataframe for output 
        resultTable = data.frame(
            Result = "The estimated GFR is",
            GFR = gfr
        )
        
        resultTable
        
        comment_on_dose <- "No comment!"
        if(gfr > 60){
            comment_on_dose <- paste0("Hello Doctor. Your patient has a GFR of : ", round(gfr,2) ," ml/min which is sufficient to handle most renal drugs. Continue prescribing for your patient with care")
        }else if(gfr >30){
            comment_on_dose <- paste0("Hello Doctor. Your patient has a GFR of : ", round(gfr,2) ," ml/min which indicates CKD stage 3. Some drugs may require dose adjustment for this patient. Please check before prescribing.")
        }else if(gfr > 15){
            comment_on_dose <- paste0("Hello Doctor. Your patient has a GFR of : ", round(gfr,2) ," ml/min which indicates CKD stage 4. Some drugs may require dose adjustment for this patient. Please check below before prescribing.")
        }else{
            comment_on_dose <- paste0("Hello Doctor. Your patient has a GFR of : ", round(gfr,2) ," ml/min which indicates End Stage Renal Disease(CKD stage 5). Some drugs may require dose adjustment for this patient. Please check below before prescribing.")
        } 
        f7Notif(
            text = comment_on_dose,
            title = "Calculated CRCL (ml/min)",
            subtitle = "Comment of dose",
            closeTimeout = 60000,
            closeButton = TRUE,
            closeOnClick = FALSE,
            swipeToClose = TRUE,
            session = session
        )
    }
    ) ###End of observeEvent for CRCL calculation
    
    ###START OF A REACTIVE TO COLLECT DATA
    formData <- reactive({
        data <- sapply(patientFields,function(x) input[[x]])
        data <- Filter(function(x) !(all(x == ""|x=="0")),data)
        data
    }) ### End of data collection reactive
    
    observeEvent(input$Submit,{
        recordStat <-saveData(data = formData(), table = "Patients", path=sqlitepath)
        
        f7Notif(
            text = paste0("Record ", recordStat),
            title = "Data save status",
            closeTimeout = 10000,
            closeButton = TRUE,
            closeOnClick = FALSE,
            swipeToClose = TRUE,
            session = session
        )
    }) 
}


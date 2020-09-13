library(shiny)
library(DT)
library(tidyverse)


drugs<-read_csv("data/drugs.csv")
antiglycemics <- read_csv("data/antiglycemics.csv")
statins <- read_csv("data/statins.csv")

# Define server logic required to calculate GFR
shinyServer(function(input, output, session) {

    inputdata <- eventReactive(input$calculate,{
        data <- data.frame(
            PatientAge = as.numeric(input$age),
            PatientWeight = as.numeric(input$weight),
            SerumCreatinine = as.numeric(input$creatinine),
            PatientSex = input$sex
        )
        data })
    
    output$message <-  renderText({

        data = inputdata()
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
        
        if(gfr > 60){
            paste0("Hello Doctor.
                     Your patient has a GFR of : ", round(gfr,2) ," ml/min which is sufficient to handle most renal drugs.
                     Continue prescribing for your patient with care")
        }else if(gfr >30){
            paste0("Hello Doctor. 
              Your patient has a GFR of : ", round(gfr,2) ," ml/min which indicates CKD stage 3.
              Some drugs may require dose adjustment for this patient. Please check before prescribing.")
        }else if(gfr > 15){
            paste0("Hello Doctor. 
              Your patient has a GFR of : ", round(gfr,2) ," ml/min which indicates CKD stage 4.
              Some drugs may require dose adjustment for this patient. Please check below before prescribing.")
        }else{
            paste0("Hello Doctor. 
              Your patient has a GFR of : ", round(gfr,2) ," ml/min which indicates End Stage Renal Disease(CKD stage 5).
              Some drugs may require dose adjustment for this patient. Please check below before prescribing.")
        }                            
})
    

    output$drug_list = renderDT(drugs, caption = "Table Showing Drugs and Recommended Doses in Renal Impairment",
                                    colnames = c('ID' = 1,
                                    'Parent Category'= 2,
                                    'Sub Category' = 3,
                                    'Drug' = 4,
                                    'Usual Dosage' = 5
                                    ))
    
    output$antiglycemics = renderDT(antiglycemics, caption = "Table Showing Antiglycemics and Recommended Doses in Renal Impairment",
                                    colnames = c('ID' = 1,
                                                 'Drug' = 2,
                                                 'Usual Dosage' = 3,
                                                 'Specific Considerations' = 4))
    
    output$statins = renderDT(statins, caption = "Table Showing Antiglycemics and Recommended Doses in Renal Impairment",
                                    colnames = c('ID' = 1,
                                                 'Drug' = 2,
                                                 'Usual Dosage' = 3,
                                                 'Dosage Adjustment' = 4))
    

    formData <- reactive({
        data <- sapply(patientFields,function(x) input[[x]])
        data <- Filter(function(x) !(all(x == ""|x=="0")),data)
        data
    })
    
    observeEvent(input$Submit,{
        recordStat <-saveData(data = formData(), table = "Patients", path=sqlitepath)
        #ListData <- LoadData("patient_id","age","weight","serum_creatinine","sex","created_at")
        #ListData <- rbind(data.frame("patient_id"='None',"age"=0),ListData)
        
        showModal(
            modalDialog(
            title = "Save status",
            paste("Record ", recordStat),
            easyClose = TRUE
            ))
    })
    }
)


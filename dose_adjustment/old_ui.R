# remember to check and write in the software log

library(shiny)
library(DT)
library(shinydashboard)

# Define UI for application that calculates GFR
sidebar <- dashboardSidebar(
  sidebarMenu(
    menuItem("Dashboard", tabName = "dashboard", icon = icon("dashboard")),
    menuItem("Analysis", tabName = "analysis", icon = icon("chart-line")),
    menuItem("Info", icon = icon("info"), tabName = "info",
             badgeLabel = "Read Me", badgeColor = "green")
  )
)

body <- dashboardBody(
  tabItems(
    tabItem(tabName = "dashboard",
            fluidRow(
              box( title = "Patient Parameters", background = "black", collapsible = TRUE,
                   fluidRow(
                     column(6,style=list("padding-right: 5px;"),
                            textInput("patientID",
                                         label="Enter Patient ID",value="M-00-00-00")
                     ),
                     column(6,style=list("padding-left: 5px;"),
                            numericInput(
                              inputId = "age",
                              label = "Age of Patient",
                              min = 18,
                              max = 100,
                              value = 18,
                              step = 0.1
                            )
                     )
                   ),
                   fluidRow(
                     column(6,style=list("padding-right: 5px;"),
                            numericInput(
                              inputId = "weight",
                              label = "Weight of Patient(Kg)",
                              min = 30,
                              max = 200,
                              value = 70
                            )
                     ),
                     column(6,style=list("padding-left: 5px;"),
                            numericInput(
                              inputId = "creatinine",
                              label = "Serum Creatinine (umol/l)",
                              min = 110,
                              max = 3000,
                              value = 115,
                              step = 0.1
                            )
                     )
                   ),
                   fluidRow(
                     column(5,style=list("padding-right: 5px;"),
                            selectInput(
                              inputId = "sex",
                              label = "Sex",
                              c("Male", "Female")
                            )
                     )),
                   actionButton(
                     inputId = "calculate",
                     label = "Calculate"
                   ),
                   actionButton(
                     inputId ="Submit",
                     label = "Save"
                   ),
                   textOutput(outputId = "savemsg"),
                   height = 320),
              fluidRow( style= "font-size:120%;",
                column(width = 5,
                       box(
                         title = "Comment on Dose", width = NULL, 
                         status = "primary", solidHeader = TRUE,
                         collapsible = TRUE,
                         tableOutput("message"), height = 180
                       ),
                ),
                fluidRow(
                  tags$br(),
                ),
                fluidRow(style = "margin: 2%;",
                  tabsetPanel(
                    id = "datasets",
                    tabPanel("Most Drugs",DTOutput("drug_list")),
                    tabPanel("Antidiabetics",DTOutput("antiglycemics")),
                    tabPanel("Statins",DTOutput("statins"))
                  )),
          )
          )
    ),

    tabItem(tabName = "analysis",
            h2("Analysis of Patient Data"),
            fluidRow(),
            fluidRow(
              DTOutput("patients")
            )
    ),
    
    tabItem(tabName = "info",
            h2("About Adjust Dose Web Application"),
            h3("Introduction"),
            p("Adjust Dose is a shiny dose adjustment web application for adjusting doses in patients with renal impairment as recommended by international guidelines.
              This app has been developed as a followup study after evaluation of dose adjustment at Muhimbili National Hospital by Castory et al.
              In the study it was found out there is a gap on how patients with renal impairment are dosed and hence something should be done to
              improve the practice and hence enhance better treatment outcomes"),
            h3("Theory"),
            p("Most drugs are eliminated through the kidney either directly or their metabolites and hence this depends on how effective is the kidney in eliminationg wastes.
              For patients with renal impairment the ability of their kidneys to eliminate wastes is reduced and hence their doses needs to be adjusted by either
              changing the dose interval or reducing the dose amount. The dose adjustment is guided by glomerular filtration rate(GFR) which can be calculatd by using this app."),
            h3("How to Use"),
            tags$ol("1. Enter patient particulars in the data form"),
            tags$ol("2. Press calculate to calculate patient's GFR"),
            tags$ol("3. Read Comment on the comment on dose box"),
            tags$ol("4. If your patient has medications that require dose adjustment,
                    search for the drug you want to give in the search box to see dose recommendation"),
            tags$ol("5. Adjust the dose accordingly as you prescribe"),
            tags$ol("6. Press save to save the entry for analysis and record keeping"),
            h3("References")
    )
    
  )
)

# Put them together into a dashboardPage
dashboardPage(
  dashboardHeader(title = "Adjust Dose"),
  sidebar,
  body
)
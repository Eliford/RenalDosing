# remember to check and write in the software log
library(shiny)
library(shinyMobile)

f7Page(
  title = "DoseAdjust",
  dark_mode = FALSE,
  init = f7Init(skin = "ios", theme = "light"),
  f7SingleLayout(
    navbar = f7Navbar(
      title = "Dosing in Renal Impaired",
      hairline = TRUE,
      shadow = TRUE
    ),
    toolbar = f7Toolbar(
      position = "bottom",
      f7Link(label = "Link 1", src = "https://www.google.com"),
      f7Link(label = "Link 2", src = "https://www.google.com", external = TRUE)
    ),
    # main content
    f7Card(
      title = "Data",
      f7Col(
        f7Align(
          f7Block(
            f7Row(
              f7Col(f7Text(inputId = "patientID", label = "Enter Patient ID", value="M-00-00-00")),
              f7Col(f7Select(inputId = "sex", label = "Sex", choices = c("Male", "Female"), selected = "Male")) 
            )
          ),
          side = "left"
        ),
        f7Align(
          f7Block(
            f7Row(
              f7Col(f7Stepper(inputId = "age", label = "Age of Patient", min = 18, max = 100, value = 18, 
                              step = 0.1, manual = TRUE, buttonsEndInputMode = FALSE)),
              f7Col(f7Stepper(inputId = "weight", label = "Weight of Patient(Kg)", min = 30, max = 200, value = 70, 
                              step = 0.1, manual = TRUE, buttonsEndInputMode = FALSE)),
              f7Col(f7Stepper(inputId = "creatinine", label = "Serum Creatinine (umol/l)", min = 110, max = 3000, value = 115,
                              step = 0.1, manual = TRUE, buttonsEndInputMode = FALSE))
            )
          ),
          side = "right"
        )
      ),
      footer = f7Block(
        f7Row(
          f7Col(f7Button(inputId = "calculate", label = "Calculate", size = "small")),
          f7Col(f7Button(inputId = "Submit", label = "Save", size = "small"))
        )
      )
    )
  )
)
# ui.R
library(shiny)

ui <- fluidPage(
  titlePanel("Political Terror Score Trend by Country (1976-2023)"),
  
  sidebarLayout(
    sidebarPanel(
      selectInput("country", "Select Country:", choices = NULL), # Choices will be set dynamically
      actionButton("goButton", "Go")
    ),
    
    mainPanel(
      plotOutput("trendPlot")
    )
  )
)

library(shinycssloaders)
library(shiny)
library(dplyr)
library(plotly)
library(ggplot2)

# Define UI for the Shiny app
ui <- fluidPage(
  titlePanel(div(class = "fade-in-text", "Trends in Political Terror (1976-2023)")),
  
  tags$head(
    tags$style(HTML("
      .fade-in-text {
        opacity: 0;
        animation: fadeIn 5s forwards;
        font-size: 16px;
      }
      @keyframes fadeIn {
        0% { opacity: 0; }
        100% { opacity: 1; }
      }
      .footer {
        margin-top: 16px;
        color: gray;
        font-size: 16px;
        text-align: center;
      }
    "))
  ),
  
  fluidRow(
    column(12, 
           div(class = "fade-in-text",
               HTML("<p>
          The Political Terror Scale (PTS) measures violations of physical integrity rights carried out by states or their agents. 
          The scale ranges from 1 to 5, with higher scores indicating more severe violations. 
          Reports are based on annual assessments from Amnesty International, Human Rights Watch, and the US Department of State. 
          The PTS dataset covers over 200 countries or territories and 7 regions from 1976 to 2023. 
          For more information, see: 
          <a href='http://www.politicalterrorscale.org/' target='_blank'>Political Terror Scale</a>.
        </p>
        <p><strong>Interactive Dashboard created by Mohsen Monji</strong></p>")
           )
    )
  ),
  
  sidebarLayout(
    sidebarPanel(
      selectInput("trend_type", "Select Trend Type:", choices = c("Country", "Region", "Global")),
      
      conditionalPanel(
        condition = "input.trend_type == 'Country'",
        selectInput("country", "Select Country:", choices = NULL)  # Will be populated dynamically
      ),
      
      conditionalPanel(
        condition = "input.trend_type == 'Region'",
        selectInput("region", "Select Region:", choices = NULL)  # Will be populated dynamically
      ),
      
      selectInput("pts_type", "Select PTS Type:", 
                  choices = c("PTS: Amnesty International" = "PTS_A", 
                              "PTS: Human Rights Watch" = "PTS_H", 
                              "PTS: US Department of State" = "PTS_S"), 
                  selected = "PTS_A"),
      
      sliderInput("year_range", "Select Year Range:",
                  min = 1976,
                  max = 2023,
                  value = c(1976, 2023),
                  step = 1, sep = "")
    ),
    
    mainPanel(
      plotlyOutput("trendPlot", height = "600px") %>% withSpinner(),  # Main Plot
      plotOutput("topCountriesPlot")  # Top 20 Countries Plot
    )
  )
)

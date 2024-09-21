# ui.R
library(shiny)

# Define the UI for the Shiny app
fluidPage(
  titlePanel("Trends in Political Terror Scale (1976-2023)"),
  
  # Add description of the dashboard with fading effect
  tags$head(
    tags$style(HTML("
      .fade-in-text {
        opacity: 0;
        animation: fadeIn 5s forwards;
      }
      @keyframes fadeIn {
        0% { opacity: 0; }
        100% { opacity: 1; }
      }
      .footer {
        margin-top: 20px;
        color: gray;
        font-size: 14px;
        text-align: center;
      }
    "))
  ),
  
  fluidRow(
    column(12, 
           div(class = "fade-in-text",
               HTML("<p>
          The Political Terror Scale (PTS) measures violations of physical integrity rights carried out by states or their agents. 
          The scale ranges from 0 to 5, with higher scores indicating more severe violations. 
          Reports are based on annual assessments from Amnesty International, Human Rights Watch, and the US Department of State. 
          The PTS dataset covers over 200 countries or territories from 1976 to 2023. 
          For more information, see: 
          <a href='http://www.politicalterrorscale.org/' target='_blank'>Political Terror Scale</a>.
        </p>
        <p><strong>Interactive Trend Dashboard created by Mohsen Monji</strong></p>")
           )
    )
  ),
  
  # Sidebar and main panel layout
  sidebarLayout(
    sidebarPanel(
      selectInput("trend_type", "Select Trend Type:", choices = c("Country", "Region", "Global")),
      
      # Conditional panel for country-specific selection
      conditionalPanel(
        condition = "input.trend_type == 'Country'",
        selectInput("country", "Select Country:", choices = NULL)  # Populated in server.R
      ),
      
      # Conditional panel for region-specific selection
      conditionalPanel(
        condition = "input.trend_type == 'Region'",
        selectInput("region", "Select Region:", choices = NULL)  # Populated in server.R
      ),
      
      # Dropdown to select the type of Political Terror Score with descriptive labels
      selectInput("pts_type", "Select PTS Type:", 
                  choices = c("Average" = "Average_PTS", 
                              "PTS_A: Amnesty International" = "PTS_A", 
                              "PTS_H: Human Rights Watch" = "PTS_H", 
                              "PTS_S: US Department of State" = "PTS_S"), 
                  selected = "Average_PTS"),
      
      actionButton("goButton", "Go")
    ),
    
    mainPanel(
      plotOutput("trendPlot"),
      plotOutput("topCountriesPlot")  # Space for Top 20 Countries plot
    )
  )
)

library(shinycssloaders)
library(shiny)
library(dplyr)
library(plotly)
library(ggplot2)

# Load  the dataset
pts_data <- read.csv("PTS-2024.csv",fileEncoding = "UTF-8-BOM", encoding = "UTF-8")

# Clean the data
pts_data_clean <- pts_data %>%
  mutate(Year = as.numeric(as.character(Year))) %>%
  filter(!is.na(Year)) %>%
  mutate(
    PTS_A = ifelse(PTS_A >= 1 & PTS_A <= 5, PTS_A, NA),  # Amnesty International PTS values 1-5, others NA
    PTS_H = ifelse(PTS_H >= 1 & PTS_H <= 5, PTS_H, NA),  # Human Rights Watch PTS values 1-5, others NA
    PTS_S = ifelse(PTS_S >= 1 & PTS_S <= 5, PTS_S, NA)   # US Department of State PTS values 1-5, others NA
  )

# Define region labels
region_labels <- c(
  "eap" = "East Asia and Pacific",
  "eca" = "Europe and Central Asia",
  "lac" = "Latin America and the Caribbean",
  "mena" = "Middle East and North Africa",
  "na" = "North America",
  "sa" = "South Asia",
  "ssa" = "Sub-Saharan Africa"
)

# Define UI and server logic
ui <- fluidPage(
  titlePanel(div(class = "fade-in-text", "Political Terror Dashboard")),
  
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
      plotOutput("topCountriesPlot"),  # Top 20 Countries Plot
      h4(textOutput("tableTitle")),  # Dynamic Title for the Table
      tableOutput("statsTable")  # Dynamic table to display detailed statistics
    )
  )
)

server <- function(input, output, session) {
  
  # Populate country and region selection
  updateSelectInput(session, "country", choices = sort(unique(pts_data_clean$Country)))
  updateSelectInput(session, "region", choices = setNames(names(region_labels), region_labels))
  
  # Dynamic title generation for the second plot (Top 20 Countries plot) and the table
  dynamic_top_20_title <- reactive({
    paste("Countries with Highest Average Political Terror Score (", input$year_range[1], "-", input$year_range[2], ")", sep = "")
  })
  
  # Shared reactive dataset for the Top 20 Countries, used for both the plot and table
  top_20_countries_data <- reactive({
    selected_year_range <- input$year_range
    
    # Filter the data based on the user-defined year range
    pts_data_clean %>%
      filter(Year >= selected_year_range[1] & Year <= selected_year_range[2]) %>%
      group_by(Country) %>%
      summarise(
        Average_PTS = mean(PTS_A, na.rm = TRUE),  # Calculate the average PTS
        Median_PTS = median(PTS_A, na.rm = TRUE),  # Calculate the median PTS
        SD_PTS = sd(PTS_A, na.rm = TRUE)  # Calculate the standard deviation of PTS
      ) %>%
      top_n(20, wt = Average_PTS) %>%
      arrange(desc(Average_PTS))  # Sort by Average PTS in descending order
  })
  
  # Render the Top 20 Countries plot using the shared reactive dataset
  output$topCountriesPlot <- renderPlot({
    top_20_countries <- top_20_countries_data()
    
    # Plot with Average PTS-A
    ggplot(top_20_countries, aes(x = reorder(Country, Average_PTS), y = Average_PTS)) +
      geom_bar(stat = "identity", fill = "darkgreen", alpha = 0.8) +
      
      coord_flip() +  # Flip coordinates to make countries on the Y axis
      
      labs(
        title = dynamic_top_20_title(),  # Use the same title for the plot and the table
        x = "Country", y = "Average Political Terror Score-PTS-A"
      ) +
      
      theme_minimal() +
      theme(
        plot.title = element_text(face = "bold", size = 14),  # Bigger title for professionalism
        axis.title.y = element_text(face = "bold", size = 12),  # Bold y-axis label
        axis.title.x = element_text(face = "bold", size = 12),  # Bold x-axis label
        axis.text.y = element_text(face = "bold", size = 10),   # Smaller, clearer country names
        plot.margin = margin(20, 40, 20, 20)  # Increase margins for better spacing
      )
  })
  
  # Render the dynamic title for the table (same as the second plot)
  output$tableTitle <- renderText({
    dynamic_top_20_title()  # Same dynamic title used for the table and the Top 20 Countries plot
  })
  
  # Render the Dynamic Table using the shared reactive dataset
  output$statsTable <- renderTable({
    # Use the same dataset for the table as used for the plot
    top_20_countries <- top_20_countries_data() %>%
      # Rename the columns for clarity in the table
      rename(
        `Average Political Terror Score (Amnesty International)` = Average_PTS,
        `Median PTS-A` = Median_PTS,
        `Standard Deviation` = SD_PTS
      )
    
    # Return the resulting table in the same order as the plot
    top_20_countries
  })
}

# Run the application 
shinyApp(ui = ui, server = server)

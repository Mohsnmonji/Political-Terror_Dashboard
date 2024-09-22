library(shinycssloaders)
library(shiny)
library(dplyr)
library(plotly)
library(ggplot2)

# Load the dataset (ensure it's in the correct directory as your Shiny app)

pts_data <- read.csv("PTS-2024.csv", 
                     fileEncoding = "UTF-8-BOM", encoding = "UTF-8")

# Clean and preprocess data
pts_data_clean <- pts_data %>%
  mutate(Year = as.numeric(as.character(Year))) %>%
  filter(!is.na(Year))

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

# Calculate average PTS dynamically based on available PTS_A and PTS_S values
pts_data_clean <- pts_data_clean %>%
  rowwise() %>%
  mutate(Average_PTS = case_when(
    !is.na(PTS_A) & !is.na(PTS_S) ~ mean(c(PTS_A, PTS_S), na.rm = TRUE),
    !is.na(PTS_A) ~ PTS_A,
    !is.na(PTS_S) ~ PTS_S,
    TRUE ~ NA_real_
  )) %>%
  ungroup()

# Calculate the average PTS for each country over the available years
average_pts_over_time <- pts_data_clean %>%
  group_by(Country) %>%
  summarise(Average_PTS = mean(Average_PTS, na.rm = TRUE)) %>%
  arrange(desc(Average_PTS))

# Get the top 20 countries by average PTS over time
top_20_countries <- average_pts_over_time %>%
  top_n(20, wt = Average_PTS)

# Get unique lists of countries and regions
country_list <- unique(pts_data_clean$Country)
region_list <- unique(pts_data_clean$Region)

# Define UI for the Shiny app
ui <- fluidPage(
  titlePanel(div(class = "fade-in-text", "Trend in Political Terror")),
  
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
        selectInput("country", "Select Country:", choices = sort(unique(pts_data_clean$Country)))  # Populate with countries
      ),
      
      conditionalPanel(
        condition = "input.trend_type == 'Region'",
        selectInput("region", "Select Region:", choices = setNames(names(region_labels), region_labels))  # Display region labels
      ),
      
      selectInput("pts_type", "Select PTS Type:", 
                  choices = c("Average" = "Average_PTS", 
                              "PTS_A: Amnesty International" = "PTS_A", 
                              "PTS_H: Human Rights Watch" = "PTS_H", 
                              "PTS_S: US Department of State" = "PTS_S"), 
                  selected = "Average_PTS"),
      
      sliderInput("year_range", "Select Year Range:",
                  min = min(pts_data_clean$Year, na.rm = TRUE),
                  max = max(pts_data_clean$Year, na.rm = TRUE),
                  value = c(min(pts_data_clean$Year), max(pts_data_clean$Year)),
                  step = 1, sep = "")
    ),
    
    mainPanel(
      plotlyOutput("trendPlot", height = "600px") %>% withSpinner(),  # Main Plot
      plotOutput("topCountriesPlot")  # Top 20 Countries Plot
    )
  )
)

# Define server logic
server <- function(input, output, session) {
  
  # Filter data based on trend type (Global, Region, Country), PTS type, and year range
  filtered_data <- reactive({
    selected_column <- input$pts_type
    
    if (input$trend_type == "Country") {
      pts_data_clean %>%
        filter(Country == input$country) %>%
        filter(Year >= input$year_range[1], Year <= input$year_range[2]) %>%
        select(Country, Year, !!selected_column) %>%
        rename(PTS = !!selected_column)
      
    } else if (input$trend_type == "Region") {
      pts_data_clean %>%
        filter(Region == input$region) %>%
        filter(Year >= input$year_range[1], Year <= input$year_range[2]) %>%
        group_by(Year) %>%
        summarise(PTS = mean(.data[[selected_column]], na.rm = TRUE))
      
    } else {
      pts_data_clean %>%
        filter(Year >= input$year_range[1], Year <= input$year_range[2]) %>%
        group_by(Year) %>%
        summarise(PTS = mean(.data[[selected_column]], na.rm = TRUE))
    }
  })
  
  # Render the interactive trend plot using plotly
  output$trendPlot <- renderPlotly({
    trend_data <- filtered_data()
    
    if (nrow(trend_data) > 0) {
      # Create the plotly interactive line plot with two decimal points for PTS scores and red color
      p <- plot_ly(trend_data, 
                   x = ~Year, 
                   y = ~round(PTS, 2),  # Keep real values with two decimals
                   type = 'scatter', 
                   mode = 'lines+markers',
                   hoverinfo = 'text',
                   text = ~paste('Year:', Year, '<br>PTS:', round(PTS, 2)),
                   line = list(color = 'red'),  # Set line color to red
                   marker = list(color = 'red')  # Set marker color to red
      ) %>%
        layout(
          title = list(text = "Trend in Political Terror", font = list(size = 12, bold = TRUE, color = 'darkgreen')),  # Set title bold, blue, and size 12
          xaxis = list(title = "Year"),
          yaxis = list(
            title = "PTS Score"
          ),
          hovermode = "x unified",  # Unified hover mode
          margin = list(l = 50, r = 50, t = 100, b = 100),  # Add margins for better layout
          showlegend = FALSE
        )
      
      return(p)
    } else {
      ggplotly(ggplot() + 
                 annotate("text", x = 1, y = 1, label = "No data available for this selection", size = 5, color = "red") +
                 theme_void())
    }
  })
  
  
  
  # Render the Top 20 Countries plot based on Average PTS
  output$topCountriesPlot <- renderPlot({
    ggplot(top_20_countries, aes(x = reorder(Country, Average_PTS), y = Average_PTS)) +
      geom_bar(stat = "identity", fill = "darkgreen") +
      coord_flip() +
      labs(title = "Countries with Highest Average PTS (1976-2023)",
           x = "Country", y = "Average PTS Score") +
      theme_minimal()
  })
}

# Run the application 
shinyApp(ui = ui, server = server)

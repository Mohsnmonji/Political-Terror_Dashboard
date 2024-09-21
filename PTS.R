# Load necessary libraries
library(shiny)
library(dplyr)
library(ggplot2)

# Load the dataset (ensure it's in the same directory as your Shiny app)
pts_data <- read.csv("PTS-2024.csv", fileEncoding = "UTF-8-BOM", encoding = "UTF-8")

# Clean the data
pts_data_clean <- pts_data %>%
  mutate(Year = as.numeric(as.character(Year))) %>% 
  filter(!is.na(Year))

# Calculate average PTS using PTS_A, PTS_H, and PTS_S
pts_data_clean <- pts_data_clean %>%
  mutate(Average_PTS = rowMeans(cbind(PTS_A, PTS_H, PTS_S), na.rm = TRUE))

# Calculate year-over-year changes in average PTS score
pts_data_clean <- pts_data_clean %>%
  arrange(Country, Year) %>%
  group_by(Country) %>%
  mutate(PTS_Change = Average_PTS - lag(Average_PTS))

# Calculate the average year-over-year change for each country
average_changes <- pts_data_clean %>%
  group_by(Country) %>%
  summarise(Average_Change = mean(PTS_Change, na.rm = TRUE)) %>%
  arrange(desc(Average_Change))

# Get the top 20 countries by average year-over-year change
top_20_countries <- average_changes %>%
  top_n(20, wt = Average_Change)

# Get unique lists of countries and regions
country_list <- unique(pts_data_clean$Country)
region_list <- unique(pts_data_clean$Region)

# Mapping of region codes to region names
region_labels <- c(
  "eap" = "East Asia and Pacific",
  "eca" = "Europe and Central Asia",
  "lac" = "Latin America and the Caribbean",
  "mena" = "Middle East and North Africa",
  "na" = "North America",
  "sa" = "South Asia",
  "ssa" = "Sub-Saharan Africa"
)

# Define the UI for the Shiny app
ui <- fluidPage(
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
        selectInput("country", "Select Country:", choices = sort(country_list))  # Populated here
      ),
      
      # Conditional panel for region-specific selection
      conditionalPanel(
        condition = "input.trend_type == 'Region'",
        selectInput("region", "Select Region:", choices = setNames(names(region_labels), region_labels))  # Populated here
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

# Define the server logic for the Shiny app
server <- function(input, output, session) {
  
  # Filter the dataset based on the selected trend type and PTS type
  filtered_data <- eventReactive(input$goButton, {
    
    selected_column <- input$pts_type
    
    if (input$trend_type == "Country") {
      # Filter by country and selected PTS type
      pts_data_clean %>%
        filter(Country == input$country) %>%
        filter(!is.na(.data[[selected_column]])) %>%
        select(Year, !!selected_column) %>%
        rename(PTS = !!selected_column)
      
    } else if (input$trend_type == "Region") {
      # Filter by region and selected PTS type
      pts_data_clean %>%
        filter(Region == input$region) %>%
        filter(!is.na(.data[[selected_column]])) %>%
        group_by(Year) %>%
        summarise(PTS = mean(.data[[selected_column]], na.rm = TRUE))
      
    } else {
      # Global trend: average across all countries and selected PTS type
      pts_data_clean %>%
        group_by(Year) %>%
        summarise(PTS = mean(.data[[selected_column]], na.rm = TRUE))
    }
  })
  
  # Render the trend plot
  output$trendPlot <- renderPlot({
    trend_data <- filtered_data()
    
    if (nrow(trend_data) > 0) {
      ggplot(trend_data, aes(x = Year, y = PTS)) +
        geom_line(color = "red", size = 1.2) +
        geom_point(color = "red", size = 3) +
        labs(
          title = ifelse(input$trend_type == "Country", 
                         paste("Trend of", input$pts_type, "Political Terror Scale for", input$country, "(1976-2023)"),
                         ifelse(input$trend_type == "Region", 
                                paste("Trend of", input$pts_type, "Political Terror Scale in", region_labels[input$region], "Region (1976-2023)"),
                                paste("Global Trend of", input$pts_type, "Political Terror Scale (1976-2023)"))),
          x = "Year", y = paste(input$pts_type, "PTS Score")
        ) +
        theme_minimal()
    } else {
      ggplot() + 
        annotate("text", x = 1, y = 1, label = "No data available for this selection", size = 5, color = "red") +
        theme_void()
    }
  })
  
  # Render the Top 20 Countries plot
  output$topCountriesPlot <- renderPlot({
    ggplot(top_20_countries, aes(x = reorder(Country, Average_Change), y = Average_Change)) +
      geom_bar(stat = "identity", fill = "darkgreen") +  # Change bar color to dark green
      coord_flip() +
      labs(title = "Countries with Highest Year-over-Year Change in Average PTS",
           x = "Country", y = "Year-over-Year Change in Average PTS") +
      theme_minimal()
  })
}

# Run the application 
shinyApp(ui = ui, server = server)

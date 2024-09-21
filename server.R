# server.R
library(shiny)
library(ggplot2)
library(dplyr)

# Load the dataset
pts_data <- read.csv("PTS-2024.csv", fileEncoding = "UTF-8-BOM", encoding = "UTF-8")

# Clean the data
pts_data_clean <- pts_data %>%
  mutate(Year = as.numeric(as.character(Year))) %>% 
  filter(!is.na(Year))

# Calculate the average Political Terror Score (PTS) using PTS_A, PTS_H, and PTS_S
pts_data_clean <- pts_data_clean %>%
  mutate(Average_PTS = rowMeans(cbind(PTS_A, PTS_H, PTS_S), na.rm = TRUE))

# Get a unique list of countries
country_list <- sort(unique(pts_data_clean$Country), na.last = NA)

# Define server logic
server <- function(input, output, session) {
  
  # Populate country dropdown dynamically
  updateSelectInput(session, "country", choices = country_list, selected = "Iran")
  
  # Filter the dataset based on user input for the country and generate a reactive event
  filtered_data <- eventReactive(input$goButton, {
    pts_data_clean %>%
      filter(Country == input$country) %>%
      filter(!is.na(Average_PTS))
  })
  
  # Render the trend plot for the selected country
  output$trendPlot <- renderPlot({
    country_data <- filtered_data()
    
    if (nrow(country_data) > 0) {
      ggplot(country_data, aes(x = Year, y = Average_PTS)) +
        geom_line(color = "red", size = 1.2) +  # Change line color to red
        geom_point(color = "red", size = 3) +  # Change point color to red
        labs(title = paste("Trend of Average Political Terror Score for", input$country, "(1976-2023)"),
             x = "Year", y = "Average PTS Score") +
        theme_minimal()
    } else {
      ggplot() + 
        annotate("text", x = 1, y = 1, label = "No data available for this country", size = 5, color = "red") +
        theme_void()
    }
  })
}

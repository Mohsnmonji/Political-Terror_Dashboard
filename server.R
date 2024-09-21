# server.R

library(shiny)
library(dplyr)
library(ggplot2)

# Load the dataset (ensure it's in the correct directory as your Shiny app)
pts_data <- read.csv("PTS-2024.csv", 
                     fileEncoding = "UTF-8-BOM", encoding = "UTF-8")

# Clean the data
pts_data_clean <- pts_data %>%
  mutate(Year = as.numeric(as.character(Year))) %>%
  filter(!is.na(Year))

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

# Define server logic
server <- function(input, output, session) {
  
  # Populate country and region dropdowns
  updateSelectInput(session, "country", choices = sort(country_list))
  updateSelectInput(session, "region", choices = setNames(names(region_labels), region_labels))
  
  # Filter the dataset based on the selected trend type and PTS type
  filtered_data <- eventReactive(input$goButton, {
    
    selected_column <- input$pts_type
    
    if (input$trend_type == "Country") {
      pts_data_clean %>%
        filter(Country == input$country) %>%
        filter(!is.na(.data[[selected_column]])) %>%
        select(Year, !!selected_column) %>%
        rename(PTS = !!selected_column)
      
    } else if (input$trend_type == "Region") {
      pts_data_clean %>%
        filter(Region == input$region) %>%
        filter(!is.na(.data[[selected_column]])) %>%
        group_by(Year) %>%
        summarise(PTS = mean(.data[[selected_column]], na.rm = TRUE))
      
    } else {
      if (input$pts_type == "PTS_H") {
        # Filter global PTS-H data to start from 2000 onwards
        pts_data_clean %>%
          filter(Year >= 2000) %>%
          group_by(Year) %>%
          summarise(PTS = mean(.data[[selected_column]], na.rm = TRUE))
      } else {
        pts_data_clean %>%
          group_by(Year) %>%
          summarise(PTS = mean(.data[[selected_column]], na.rm = TRUE))
      }
    }
  })
  
  # Render the trend plot
  output$trendPlot <- renderPlot({
    trend_data <- filtered_data()
    
    if (nrow(trend_data) > 0) {
      pts_label <- switch(input$pts_type,
                          "Average_PTS" = "Average PTS",
                          "PTS_A" = "PTS-A",
                          "PTS_H" = "PTS-H",
                          "PTS_S" = "PTS-S")
      
      p <- ggplot(trend_data, aes(x = Year, y = PTS)) +
        geom_line(color = "red", size = 1.2) +
        geom_point(color = "red", size = 3) +
        labs(
          title = ifelse(input$trend_type == "Country", 
                         paste("Trend in", pts_label, "for", input$country, "(1976-2023)"),
                         ifelse(input$trend_type == "Region", 
                                paste("Trend in", pts_label, "in", region_labels[input$region], "Region (1976-2023)"),
                                paste("Global Trend in", pts_label, "(1976-2023)"))),
          x = "Year", 
          y = paste(pts_label, "Score")
        ) +
        theme_minimal()
      
      # Customize the x-axis scaling
      if (input$pts_type == "PTS_H") {
        # For PTS_H, display only from 2000 onwards
        p <- p + scale_x_continuous(
          breaks = seq(2000, max(trend_data$Year, na.rm = TRUE), by = 1)
        )
      } else {
        # Display every 10 years for PTS_A, PTS_S, and Average_PTS
        p <- p + scale_x_continuous(breaks = seq(min(trend_data$Year, na.rm = TRUE), max(trend_data$Year, na.rm = TRUE), by = 10))
      }
      
      print(p)
      
    } else {
      ggplot() + 
        annotate("text", x = 1, y = 1, label = "No data available for this selection", size = 5, color = "red") +
        theme_void()
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


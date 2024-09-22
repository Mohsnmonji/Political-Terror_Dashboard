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

# Define server logic
server <- function(input, output, session) {
  
  # Populate country and region selection
  updateSelectInput(session, "country", choices = sort(unique(pts_data_clean$Country)))
  updateSelectInput(session, "region", choices = setNames(names(region_labels), region_labels))
  
  # Dynamic title generation based on the trend type and selected country/region
  dynamic_trend_title <- reactive({
    trend_type <- input$trend_type
    
    if (trend_type == "Country") {
      paste("Trend in Political Terror for", input$country, "(", input$year_range[1], "-", input$year_range[2], ")")
    } else if (trend_type == "Region") {
      paste("Trend in Political Terror for", region_labels[[input$region]], "(", input$year_range[1], "-", input$year_range[2], ")")
    } else {
      paste("Global Trend in Political Terror", "(", input$year_range[1], "-", input$year_range[2], ")")
    }
  })
  
  # Dynamic y-axis label based on selected PTS type
  dynamic_yaxis_label <- reactive({
    pts_label <- input$pts_type
    if (pts_label == "PTS_A") {
      return("Political Terror Score (Amnesty International)")
    } else if (pts_label == "PTS_H") {
      return("Political Terror Score (Human Rights Watch)")
    } else {
      return("Political Terror Score (US Department of State)")
    }
  })
  
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
          title = list(text = paste("<b>", dynamic_trend_title(), "</b>"), font = list(size = 14, color = 'darkgreen')),  # Dynamic title with bold and darkgreen
          xaxis = list(title = "Year"),
          yaxis = list(
            title = dynamic_yaxis_label()  # Dynamic y-axis label based on PTS type
          ),
          hovermode = "x unified",  # Unified hover mode
          margin = list(l = 50, r = 50, t = 100, b = 100),  # Add margins for better layout
          showlegend = FALSE
        ) %>%
        config(displayModeBar = FALSE)  # Disable plot zooming options
      
      return(p)
    } else {
      ggplotly(ggplot() + 
                 annotate("text", x = 1, y = 1, label = "No data available for this selection", size = 5, color = "red") +
                 theme_void())
    }
  })
  
  # Render the Top 20 Countries plot based on available PTS types
  output$topCountriesPlot <- renderPlot({
    top_20_countries <- pts_data_clean %>%
      group_by(Country) %>%
      summarise(Average_PTS = mean(PTS_A, na.rm = TRUE)) %>%  # Example: using Amnesty International PTS for top 20
      top_n(20, wt = Average_PTS) %>%
      arrange(desc(Average_PTS))
    
    ggplot(top_20_countries, aes(x = reorder(Country, Average_PTS), y = Average_PTS)) +
      geom_bar(stat = "identity", fill = "darkgreen") +
      coord_flip() +
      labs(title = "Countries with Highest Political Terror Score (1976-2023)",
           x = "Country", y = "Political Terror Score") +
      theme_minimal() +
      theme(
        plot.title = element_text(face = "bold"),  # Bold title
        axis.title.y = element_text(face = "bold"),  # Bold y-axis label
        axis.title.x = element_text(face = "bold"),  # Bold x-axis label
        axis.text.y = element_text(face = "bold")   # Bold country names
      )
  })
}

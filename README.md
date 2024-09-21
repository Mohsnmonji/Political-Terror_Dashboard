
# Political Terror Scale (PTS) Trend Dashboard

This repository contains the code and data for the **Political Terror Scale** Interactive Dashboard. The dashboard allows users to explore trends in Political Terror Scores (PTS) for various countries and regions from 1976 to 2023. The app provides an interactive interface to visualize these trends based on reports from Amnesty International, Human Rights Watch, and the U.S. Department of State.

## Features

- **Dynamic Country, Region, and Global Selection**: Users can choose to view trends for specific countries, regions, or global averages.
- **PTS Source Selection**: Users can select from multiple PTS sources (Amnesty International, Human Rights Watch, U.S. Department of State) or view the average score across these sources.
- **Top 20 Countries**: The app also displays the countries with the highest year-over-year percentage change in average PTS.

## Access the App

You can access the live version of the app here: [Political Terror Scale App](https://mohsnmonji.shinyapps.io/PTS_Trend/)

### Files Included

| Filename         | Description                                 |
|------------------|---------------------------------------------|
| `PTS_Trend_Code.R`| Combined R script for the Shiny app, including both UI and server logic. |
| `PTS-2024.csv`   | The dataset containing Political Terror Scores from 1976-2023. |
| `PTS-Codebook-V220.pdf` | Codebook providing details on the variables, coding, and methodology used in the Political Terror Scale dataset. It can be downloaded from this repository or from the [Political Terror Scale website](http://www.politicalterrorscale.org/). |
| `README.md`      | This README file, containing project details.  |
| `server.R`       | The server logic file for the Shiny app, handling reactive programming, data filtering, and plotting. |
| `ui.R`           | The user interface (UI) script for the Shiny app, defining layout and controls for user interaction. |

## Dataset

The dataset (`PTS-2024.csv`) contains Political Terror Scores for over 200 countries from 1976 to 2023. The scores are based on reports by three primary sources:

- **PTS_A**: Amnesty International
- **PTS_H**: Human Rights Watch
- **PTS_S**: U.S. Department of State

Each source assigns a score ranging from 0 (no violations) to 5 (severe violations), and the average score across sources is used to provide a general measure of political terror in each country.

The dataset used in this app is available for download from the [Political Terror Scale website](http://www.politicalterrorscale.org/). Users can download the latest version of the dataset directly from the website.
Here is the updated section with the addition of a "Codebook" section:

## Codebook

The codebook, titled `PTS-Codebook-V220`, provides detailed explanations of the variables, coding procedures, and the methodology used in the Political Terror Scale dataset. 

Users can download the codebook from this repository or from the [Political Terror Scale website](http://www.politicalterrorscale.org/). 
### Calculation of Average PTS

The average Political Terror Score (PTS) for each country-year is calculated using the following methodology:

```r
# Calculate the average PTS score dynamically based on available values
pts_data_clean <- pts_data_clean %>%
  rowwise() %>%
  mutate(Average_PTS = case_when(
    !is.na(PTS_A) & !is.na(PTS_H) & !is.na(PTS_S) ~ mean(c(PTS_A, PTS_H, PTS_S), na.rm = TRUE),
    !is.na(PTS_A) & !is.na(PTS_H) ~ mean(c(PTS_A, PTS_H), na.rm = TRUE),
    !is.na(PTS_A) & !is.na(PTS_S) ~ mean(c(PTS_A, PTS_S), na.rm = TRUE),
    !is.na(PTS_H) & !is.na(PTS_S) ~ mean(c(PTS_H, PTS_S), na.rm = TRUE),
    !is.na(PTS_A) ~ PTS_A,
    !is.na(PTS_H) ~ PTS_H,
    !is.na(PTS_S) ~ PTS_S,
    TRUE ~ NA_real_
  ))
```

This calculation ensures that the average score is computed dynamically, depending on the availability of data from different sources, and handles missing values (`NA`) appropriately.

## Shiny App Features

The Shiny app allows users to explore trends in Political Terror Scores using the following features:

- **Country and Region Selection**: Users can select a country or a region to view the trend in PTS over time (from 1976 to 2023).
- **Global Trend View**: A global average trend can be displayed, aggregating scores from all countries.
- **Interactive Plots**: The app displays line plots for selected countries or regions, with the ability to choose from different PTS sources (Amnesty International, Human Rights Watch, U.S. Department of State).
- **Top 20 Countries**: The app also highlights the top 20 countries with the highest year-over-year percentage change in PTS, providing insights into rapid changes in political terror.

### Plot Customization

- **Trend Plot**: The trend plot visualizes the selected PTS data with a red line and red points to emphasize data points. It updates dynamically based on the user's selection of country, region, or global scope.
  
- **Top 20 Countries Plot**: A bar chart shows the top 20 countries with the highest year-over-year percentage change in average PTS. The countries are ranked and displayed with green bars.

## Installation and Running the App

To run the Shiny app locally, follow these steps:

1. Clone the repository:
   ```bash
   git clone https://github.com/your_username/PoliticalTerrorScale.git
   ```

2. Install necessary packages in R:
   ```r
   install.packages(c("shiny", "ggplot2", "dplyr"))
   ```

3. Set your working directory to the project folder:
   ```r
   setwd("/path/to/PoliticalTerrorScale")
   ```

4. Run the app using the following R command:
   ```r
   shiny::runApp('PTS_Trend_Code.R')
   ```

## Deployment

The Shiny app can be deployed on [ShinyApps.io](https://mohsnmonji.shinyapps.io/PTS_Trend/). To deploy the app yourself, use the following steps:

1. Set up your ShinyApps.io account with the following R code:
   ```r
   rsconnect::setAccountInfo(name = 'your_username', token = 'YOUR_TOKEN', secret = 'YOUR_SECRET')
   ```

2. Deploy the app:
   ```r
   rsconnect::deployApp(appDir = getwd())
   ```

## Contributing

Contributions are welcome! If you have suggestions or improvements, feel free to open an issue or create a pull request.

## License

This project is open-source and available under the MIT License. Please see the [LICENSE](LICENSE) file for details.

--- 

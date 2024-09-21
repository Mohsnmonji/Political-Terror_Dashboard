
# Political Terror Scale (PTS) Dashboard

# Political Terror Scale - Shiny App

This repository contains the code and data for the **Political Terror Scale** Shiny application. The app allows users to explore trends in Political Terror Scores (PTS) for various countries from 1976 to 2023. 

## Features

- **Dynamic Country Selection**: Choose any country to visualize the trend of its average Political Terror Score over time.
- **Interactive Plot**: Displays the average score trend for the selected country from 1976 to 2023.

## Access the App

You can access the live version of the app here: [Political Terror Scale App](https://mohsnmonji.shinyapps.io/Political_Terror_Scale/)

## Running Locally

If you prefer to run the app locally, follow these steps:

1. Clone the repository to your local machine:

    ```bash
    git clone https://github.com/YOUR_USERNAME/PoliticalTerrorScale.git
    ```

2. Open the project in RStudio.
3. Install the required R packages:

    ```r
    install.packages(c("shiny", "ggplot2", "dplyr"))
    ```

4. Run the app:

    ```r
    shiny::runApp("app.R")
    ```

## Dataset

The dataset (`PTS-2024.csv`) contains Political Terror Scores for countries from 1976 to 2023. The scores are based on three primary indicators:

- **PTS_A**: Amnesty International reports
- **PTS_H**: U.S. State Department reports on human rights
- **PTS_S**: State-level terror reports

The app calculates the average PTS score using these three indicators, excluding missing values.

## Methodology

- The average Political Terror Score (PTS) for each year and country is calculated as:

    ```r
    Average_PTS = rowMeans(cbind(PTS_A, PTS_H, PTS_S), na.rm = TRUE)
    ```

## License

This project is open-source and available under the [MIT License](LICENSE).



## Overview

This project is a Shiny app that allows users to explore the trend of the **Political Terror Scale (PTS)** for various countries from 1976 to 2023. The app enables users to select a country from a dropdown menu and view the trend of the average Political Terror Score over time.

### Political Terror Scale (PTS)

The Political Terror Scale (PTS) measures the levels of physical integrity rights violations across countries. The scores are based on annual reports from **Amnesty International** and the **U.S. State Department**, providing a numerical measure of state-sponsored terror and human rights violations.

### Features

- Select a country from a dropdown menu.
- View the trend of average Political Terror Score (PTS) for the selected country from 1976 to 2023.
- The PTS is calculated as the average of three separate measures:
  - PTS_A: Amnesty International's report score.
  - PTS_H: Human Rights Watch score.
  - PTS_S: U.S. State Department score.

## Dataset

The dataset `PTS-2024.csv` includes PTS scores for multiple countries and regions. The dataset includes the following columns:

- **Country**: Name of the country.
- **Year**: The year for which the PTS score is recorded.
- **PTS_A**: Amnesty International score.
- **PTS_H**: Human Rights Watch score.
- **PTS_S**: U.S. State Department score.
- **Region**: The geographical region of the country.
- **Other metadata**: Metadata for regions, codes, and NA statuses.

### Calculation of Average PTS

The **average PTS score** is calculated by taking the mean of the available scores from the three sources (PTS_A, PTS_H, PTS_S) for each country-year:

```r
pts_data_clean <- pts_data_clean %>%
  mutate(Average_PTS = rowMeans(cbind(PTS_A, PTS_H, PTS_S), na.rm = TRUE))
```

Missing values are handled using `na.rm = TRUE`, ensuring that only available scores contribute to the average.

## Shiny App

The Shiny app allows users to interact with the dataset and visualize the trend of the average Political Terror Score over time. The app includes the following functionalities:

- A **dropdown menu** to select a country.
- A **plot** that displays the trend of the average PTS score over time for the selected country.
- The trend is displayed using a **red line** and **red points** to highlight the data points.

## Installation

To run the Shiny app locally, follow these steps:

1. Clone the repository:
   ```bash
   git clone https://github.com/your_username/PoliticalTerrorScale.git
   ```

2. Install necessary packages in R:
   ```r
   install.packages(c("shiny", "ggplot2", "dplyr", "rsconnect"))
   ```

3. Set your working directory to the project folder:
   ```r
   setwd("/path/to/PoliticalTerrorScale")
   ```

4. Run the app:
   ```r
   shiny::runApp()
   ```

## Deployment

The Shiny app is deployed at [ShinyApps.io](https://YOUR_APP_LINK). You can visit the live version of the app using the link provided.

To deploy the app yourself:
```r
rsconnect::setAccountInfo(name = 'your_username', token = 'YOUR_TOKEN', secret = 'YOUR_SECRET')
rsconnect::deployApp(appDir = getwd())
```

## Contributing

Contributions to the project are welcome. Please create a pull request or open an issue to discuss changes.

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

---

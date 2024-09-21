
# Political Terror Scale (PTS) Dashboard

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


# Political Terror Scale (PTS) Trend Dashboard

This repository contains the code for the **Political Terror Scale Dashboard**. The dashboard allows users to explore trends in Political Terror Scores (PTS) for various countries and regions from 1976 to 2023. The app provides an interactive interface to visualize these trends based on the PTS Dataset provided by the Political Terror Scale (PTS) project, a data collection project at
the Political Science Department at the University of North Carolina, Asheville.

## Features

- **Dynamic Country, Region, and Global Selection**: Users can choose to view trends for specific countries, regions, or global averages.
- **PTS Source Selection**: Users can select from three PTS indicator provided by Amnesty International, Human Rights Watch, U.S. Department of State or view the average PTS score across these sources.
- **Top 20 Countries**: The app also displays the countries with the highest year-over-year percentage change in average PTS.

## Access the App

You can access the live version of the app here: [Political Terror Scale App](https://mohsnmonji.shinyapps.io/PTS_Trend/)

### Files Included

| Filename         | Description                                 |
|------------------|---------------------------------------------|
| `PTS_Trend_Code.R`| R script for the Shiny app, including both UI and server logic. |
| `PTS-2024.csv`   | The PTS dataset containing Political Terror Scores from 1976-2023. |
| `PTS-Codebook-V220.pdf` | Codebook providing details on the variables, coding, and methodology used in the Political Terror Scale dataset. It can be downloaded from this repository or from the [Political Terror Scale website](http://www.politicalterrorscale.org/). |
| `README.md`      | README file, containing project details. |
| `server.R`       | The server logic file for the Shiny app, handling reactive programming, data filtering, and plotting. |
| `ui.R`           | The user interface (UI) script for the Shiny app, defining layout and controls for user interaction. |
| `Instructions.Rmd` | R Markdown file containing instructions on how to  run the code for the app. |
| `Instructions.pdf` | PDF version of the instructions for run the code for the app. |

## Dataset

The dataset (`PTS-2024.csv`) contains Political Terror Scores for over 200 countries from 1976 to 2023. The scores are based on reports by three primary sources and include three indicators of political terror:

- **PTS_A**: Amnesty International
- **PTS_H**: Human Rights Watch
- **PTS_S**: U.S. Department of State

Each source assigns a score ranging from 0 (no violations) to 5 (severe violations) to provide a general measure of political terror in each country.As the PTS project team reminds, it is important to understand political terror as:

Each source assigns a score ranging from 0 (no violations) to 5 (severe violations) to provide a general measure of political terror in each country. As the PTS project team reminds, it is important to understand the scores as:

> "... violations of basic human rights
to the physical integrity of the person by agents of the state within the territorial boundaries of the state
in question in a particular year. It is important to note that political terror as defined by the PTS is
not synonymous with terrorism or the use of violence and intimidation in pursuit of political aims. The
concept is also distinguishable from terrorism as a tactic or from criminal acts."(Gibney et al., 2024)

The PTS dataset is available for download from the [Political Terror Scale project website](http://www.politicalterrorscale.org/). Users can download the latest version of the PTS dataset directly from the website.

## Data Citation

Gibney, Mark, Peter Haschke, Daniel Arnon, Attilio Pisanò, Gray Barrett, Baekkwan Park, and Jennifer Barnes. 2024. *The Political Terror Scale 1976-2023*. Retrieved from the Political Terror Scale website: [http://www.politicalterrorscale.org](http://www.politicalterrorscale.org).

## Codebook

The codebook, titled `PTS-Codebook-V220`, provides detailed explanations of the variables, coding procedures, and the methodology used in the Political Terror Scale dataset. 

Users can download the codebook from this repository or from the [Political Terror Scale project website](http://www.politicalterrorscale.org/).

## Calculation of Average PTS

The average **Political Terror Score (PTS)** in this dashboard is calculated by averaging the available scores from three sources: **PTS_A** (Amnesty International), **PTS_H** (Human Rights Watch), and **PTS_S** (U.S. Department of State). The method used for calculating the average PTS is as follows:

1. If all three scores are available (PTS_A, PTS_H, PTS_S), the average is calculated using all three.
2. If only two scores are available, the average is calculated using the two available scores.
3. If only one score is available, that score is used as the PTS.
4. If none of the scores are available, the PTS is set to `NA`.

This logic ensures that the average is dynamically calculated depending on the availability of data from the different sources and handles missing values appropriately.

```r
# Logic for calculating average PTS
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

## Instructions

For detailed instructions on how to clone, install, run, and deploy the app, please refer to the `Instructions.Rmd` or `Instructions.pdf` file in this repository.

## License



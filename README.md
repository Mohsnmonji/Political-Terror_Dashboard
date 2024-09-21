
# Political Terror Scale (PTS) Trend Dashboard

This repository contains the R code and data for the **Political Terror Scale** Interactive Dashboard. The dashboard allows users to explore trends in Political Terror Scores (PTS) for various countries and regions from 1976 to 2023. The app provides an interactive interface to visualize these trends based on reports from Amnesty International, Human Rights Watch, and the U.S. Department of State.

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
| `Instructions.Rmd` | R Markdown file containing detailed instructions on how to install, run, and deploy the app. |
| `Instructions.pdf` | PDF version of the instructions for installation, running, and deploying the app. |

## Dataset

The dataset (`PTS-2024.csv`) contains Political Terror Scores for over 200 countries from 1976 to 2023. The scores are based on reports by three primary sources:

- **PTS_A**: Amnesty International
- **PTS_H**: Human Rights Watch
- **PTS_S**: U.S. Department of State

Each source assigns a score ranging from 0 (no violations) to 5 (severe violations), and the average score across sources is used to provide a general measure of political terror in each country.

The dataset used in this app is available for download from the [Political Terror Scale website](http://www.politicalterrorscale.org/). Users can download the latest version of the dataset directly from the website.

## Codebook

The codebook, titled `PTS-Codebook-V220`, provides detailed explanations of the variables, coding procedures, and the methodology used in the Political Terror Scale dataset. 

Users can download the codebook from this repository or from the [Political Terror Scale website](http://www.politicalterrorscale.org/).

## Instructions

For detailed instructions on how to clone, install, run, and deploy the app, please refer to the `Instructions.Rmd` or `Instructions.pdf` file in this repository.

## License



---

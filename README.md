
# Political Terror Scale (PTS) Dashboard

This repository contains the R code and data used to build the **Political Terror Dashboard**. The dashboard allows users to explore trends in political terror scores for various countries and regions from 1976 to 2023. The app provides an interactive interface to visualize these trends based on the PTS Dataset provided by the Political Terror Scale (PTS) project, a data collection project at the Political Science Department at the University of North Carolina, Asheville.

## Features

- **Dynamic Country, Region, and Global Selection**: Users can choose to view trends for specific countries, regions, or global averages.
- **PTS Source Selection**: Users can select from three different PTS indicators based on reports by Amnesty International, Human Rights Watch, U.S. Department of State or view the average PTS score across over the yers.

### Access the App

You can access the app here: [Political Terror Scale App](https://mohsnmonji.shinyapps.io/Trend_Political_Terror/)

### Files Included

| Filename         | Description                                 |
|------------------|---------------------------------------------|
| `PTS_Trend_Code.R`| R script for the Shiny app, including both UI and server logic. |
| `PTS-2024.csv`   | The PTS dataset containing Political Terror Scores from 1976-2023. |
| `PTS-Codebook-V220.pdf` | Codebook providing details on the variables, coding, and methodology used in the Political Terror Scale dataset. It can be downloaded from this repository or from the [Political Terror Scale website](http://www.politicalterrorscale.org/). |
| `README.md`      | README file, containing project details. |
| `server.R`       | The server logic file for the Shiny app, handling reactive programming, data filtering, and plotting. |
| `ui.R`           | The user interface (UI) script for the Shiny app, defining layout and controls for user interaction. |
| `Instructions.Rmd` | R Markdown file containing instructions on how to  run the R code for the app. |
| `Instructions.pdf` | PDF version of the instructions for running the R code for the app. |

### Dataset

The dataset (`PTS-2024.csv`) contains political terror scores for over 200 countries and 7 geographic regions from 1976 to 2023. The scores are based on reports by three primary sources and include three indicators of political terror:

- **PTS_A**: Amnesty International
    - [Amnesty International: The State of the World's Human Rights](https://amnesty.ca/reports/2024-annual-global-report/?gad_source=1&gclid=Cj0KCQjw3bm3BhDJARIsAKnHoVX7eatPE_Ipefq3HJ_Lg6RDd6AQm16fAs-oRFjs78dZlGzSltESmscaAuDaEALw_wcB)
- **PTS_H**: Human Rights Watch
    - [Human Rights Watch: World Report](https://www.hrw.org/world-report/2024)
- **PTS_S**: U.S. Department of State
    - [U.S. Department of State: Country Reports on Human Rights Practices](https://preview.state.gov/reports/2023-country-reports-on-human-rights-practices/)

The PTS team  assign a score ranging from 0 (no violations) to 5 (severe violations) to each country based on reports from the above-mentioned sources to provide a general measure of political terror in each country.As the PTS project team reminds, it is important to understand political terror as:

Each source assigns a score ranging from 0 to 5 to provide a general measure of political terror in each country. As the PTS project team reminds, it is important to understand political terror as:

> "... violations of basic human rights
to the physical integrity of the person by agents of the state within the territorial boundaries of the state
in question in a particular year. It is important to note that political terror as defined by the PTS is
not synonymous with terrorism or the use of violence and intimidation in pursuit of political aims. The
concept is also distinguishable from terrorism as a tactic or from criminal acts."(Gibney et al., 2024)

### Coding Scheme in the Political Terror Scale 

| Level | Description                                                                                                                                                                                |
|-------|--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| 1     | Countries under a secure rule of law, people are not imprisoned for their views, and torture is rare or exceptional. Political murders are extremely rare.                                   |
| 2     | There is a limited amount of imprisonment for nonviolent political activity. However, few persons are affected, torture and beatings are exceptional. Political murder is rare.              |
| 3     | There is extensive political imprisonment, or a recent history of such imprisonment. Execution or other political murders and brutality may be common. Unlimited detention, with or without a trial, for political views is accepted. |
| 4     | Civil and political rights violations have expanded to large numbers of the population. Murders, disappearances, and torture are a common part of life. Despite its generality, on this level, terror primarily affects those who engage in politics or ideas. |
| 5     | The terrors of Level 4 have been extended to the whole population. The leaders of these societies place no limits on the means or thoroughness with which they pursue personal or ideological goals. |

### Access to the PTS dataset 

The PTS dataset is available for download from the [Political Terror Scale project website](http://www.politicalterrorscale.org/). Users can download the latest version of the PTS dataset directly from the website.

### Data Citation

Gibney, Mark, Peter Haschke, Daniel Arnon, Attilio Pisanò, Gray Barrett, Baekkwan Park, and Jennifer Barnes. 2024. *The Political Terror Scale 1976-2023*. Retrieved from the Political Terror Scale website: [http://www.politicalterrorscale.org](http://www.politicalterrorscale.org).

### Codebook

The codebook, titled `PTS-Codebook-V220`, provides detailed explanations of the variables, coding procedures, and the methodology used in the Political Terror Scale dataset. 

The codebook can be downloaded from this repository or from the [Political Terror Scale project website](http://www.politicalterrorscale.org/).


### Calculation of Average PTS in this Dashboard

The **average political terror score** in this dashboard is calculated by averaging scores from two indicators: **PTS_A** (Amnesty International) and **PTS_S** (U.S. Department of State). The method used for calculating the average PTS is as follows:

1. If both scores (**PTS_A** and **PTS_S**) are available, the average is calculated using these two scores.
2. If only one score (**PTS_A** or **PTS_S**) is available, that score is used as the PTS.
3. If neither score is available, the PTS is set to `NA`.

This method ensures that the average is dynamically calculated based on the availability of data from **Amnesty International** and the **U.S. Department of State**, handling missing values appropriately.

### Instructions

For instructions on how to run the R code for the app, please refer to the `Instructions.Rmd` or `Instructions.pdf` file in this repository.

### License



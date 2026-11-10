# My Portfolio for EVR 628

## Author

Rileigh Gonzalez

## Description

This project analyzes personal Garmin dive activity data to explore diving patterns over time and across geographic regions. The project examines dive frequency, maximum dive depth, dive depth distributions, and the geographic distribution of recorded dive locations.

Using R and the tidyverse ecosystem, the project imports, cleans, transforms, summarizes, and visualizes Garmin activity data to identify trends in personal diving activity. Spatial analysis incorporates GPS coordinates extracted from Garmin Connect dive records to map dive locations in South Florida and Belize.

The workflow is organized to support reproducible data processing, exploratory data visualization, and spatial data visualization.

## Repository Contents

### Raw Data

- **`Activities (2).csv`**
  - Raw Garmin activity data exported from Garmin Connect.
  - **Location:** `scripts/01_processing/Activities (2).csv`
  - **Source:** Garmin Connect

### R Scripts

- **`data_processing.R`**
  - **Location:** `scripts/01_processing/data_processing.R`
  - Imports the raw Garmin activity data.
  - Standardizes column names using `janitor`.
  - Filters for dive-related activities.
  - Converts dates and maximum depth values into appropriate data types.
  - Removes duplicate records and empty rows or columns.
  - Exports the cleaned dataset as CSV and RDS files to the `clean/` directory.

- **`exploratory_data_visualization.R`**
  - **Location:** `scripts/03_content/exploratory_data_visualization.R`
  - Loads the cleaned Garmin dive dataset.
  - Creates exploratory visualizations of maximum dive depth, dive depth distribution, monthly dive frequency, and dive counts by depth range.
  - Saves the resulting figures to the `figures/` directory.

- **`spatial_data_visualization.R`**
  - **Location:** `scripts/03_content/spatial_data_visualization.R`
  - Loads Garmin dive GPS coordinates and maximum depth measurements.
  - Converts geographic coordinates into spatial features using the `sf` package.
  - Uses `geom_sf()` to map individual dive locations.
  - Incorporates Natural Earth geographic boundaries as an external base map.
  - Visualizes dive locations in South Florida and Belize.
  - Uses point colors to represent maximum recorded dive depth in meters.
  - Includes a north arrow, geographic coordinate labels, and a scale bar.
  - Exports the final spatial visualization as a high-resolution PNG to `results/img/`.

### Clean Data

- **`cleaned_garmin_dives.rds`**
  - Cleaned and processed Garmin dive activity dataset saved as an R object.
  - **Location:** `clean/cleaned_garmin_dives.rds`
  - **Purpose:** Preserves R data types for subsequent analysis.

- **`cleaned_garmin_dives.csv`**
  - Cleaned Garmin dive activity dataset saved as a CSV file.
  - **Location:** `clean/cleaned_garmin_dives.csv`
  - **Purpose:** Provides a portable version of the cleaned dataset for use in other software.

- **`garmin_dive_locations.csv`**
  - GPS coordinates extracted from the Garmin Connect dive activity export.
  - **Location:** `data/garmin_dive_locations.csv`
  - **Purpose:** Contains dive identification numbers, activity identifiers, dates, latitude, longitude, maximum depth measurements, and geographic region classifications.
  - Includes 131 GPS-bearing activity records representing 107 distinct dive numbers.
  - **Purpose:** Provides geographic coordinates for spatial mapping and analysis.

### Figures

All figures are exported as high-resolution PNG files.

**Exploratory Data Visualizations**

- **`dive_depth_over_time.png`**
  - Displays maximum dive depth over time.

- **`dive_depth_distribution.png`**
  - Shows the distribution of maximum dive depths across recorded dives.

- **`dives_by_month.png`**
  - Shows the number of recorded dives by month.

- **`dives_by_depth_range.png`**
  - Summarizes the number of dives within predefined maximum depth ranges.

**Spatial Data Visualization**

- **`spatial_data_visualization.png`**
  - **Location:** `results/img/spatial_data_visualization.png`
  - Maps recorded Garmin dive locations using GPS coordinates.
  - Displays dive locations across South Florida and Belize.
  - Represents maximum dive depth through a continuous color scale.
  - Includes geographic boundaries, a north arrow, and a scale bar.

### Project File

- **`my_portfolio_redo.Rproj`**
  - RStudio project file used to open the project from its root directory and maintain consistent relative file paths.

## Required R Packages

The project uses the following R packages:

- `tidyverse` – Data manipulation and visualization.
- `janitor` – Data cleaning and column standardization.
- `lubridate` – Date and time manipulation.
- `sf` – Spatial data processing and geographic features.
- `ggplot2` – Data visualization.
- `ggspatial` – Map scale bars and north arrows.
- `here` – Reproducible relative file paths.
- `rnaturalearth` – Geographic base map data.

## Reproducibility

To reproduce the analysis:

1. Clone or download the repository.
2. Open `my_portfolio_redo.Rproj` in RStudio.
3. Ensure all required R packages are installed.
4. Run `scripts/01_processing/data_processing.R` to import and clean the raw Garmin activity data.
5. Run `scripts/03_content/exploratory_data_visualization.R` to generate the exploratory visualizations.
6. Ensure `data/garmin_dive_locations.csv` is available in the project directory.
7. Run `scripts/03_content/spatial_data_visualization.R` to generate the spatial map.
8. Review the resulting cleaned datasets and exported figures in the `clean/`, `figures/`, and `results/img/` directories.

All scripts use relative file paths to support reproducibility within the RStudio project.

## Data Sources

- Garmin Connect: Personal dive activity records and GPS coordinates.
- Natural Earth: Geographic boundaries used as the external base layer for spatial visualization.


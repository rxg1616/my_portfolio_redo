################################################################################
# Garmin Dive Data - Spatial Data Visualization
################################################################################
# Author: Rileigh Gonzalez
# Course: EVR 628 - Fall 2026
# Purpose: Working with Spatial Data to produce a map of the dive data
################################################################################


# ============================================================
# Garmin Dive Data - Spatial Data Visualtion
# ============================================================

# SET UP #######################################################################

## Load packages ---------------------------------------------------------------
library(tidyverse)
library(lubridate)
library(sf)
library(ggspatial)
library(here)
library(rnaturalearth)
## Load data -------------------------------------------------------------------

# Read Garmin dive locations extracted from the Garmin export.
# Each row represents one dive activity. Entry coordinates are
# preferred; exit coordinates are used only when entry is absent.
dive_data <- read_csv(
  here("data", "garmin_dive_locations.csv"),
  show_col_types = FALSE
)
# Load Natural Earth country boundaries as an external base layer.
world_map <- ne_countries(
  scale = "medium",
  returnclass = "sf"
)
# 3. Prepare and inspect data ---------------------------------

# Remove records without valid coordinates.
dive_data <- dive_data %>%
  filter(
    !is.na(latitude),
    !is.na(longitude),
    between(latitude, -90, 90),
    between(longitude, -180, 180)
  )
# Report the number of mapped activities and distinct dive numbers.
message("Mapped Garmin activities: ", nrow(dive_data))
message("Distinct dive numbers: ", n_distinct(dive_data$dive_number))
message("Dives with depth data: ", sum(!is.na(dive_data$max_depth_m)))

# 4. Convert coordinates to spatial features ------------------

# Garmin latitude/longitude coordinates use WGS 84 (EPSG:4326).
dive_sf <- st_as_sf(
  dive_data,
  coords = c("longitude", "latitude"),
  crs = 4326,
  remove = FALSE
)

# 5. Prepare geographic base layer ----------------------------

# Crop Natural Earth boundaries to include Belize and South Florida.
map_bbox <- st_bbox(
  c(
    xmin = -90,
    ymin = 16,
    xmax = -78,
    ymax = 28
  ),
  crs = st_crs(4326)
)

map_context <- st_crop(
  world_map,
  map_bbox
)
# 6. Create spatial visualization -----------------------------

spatial_map <- ggplot() +

  # Add an external geographic base layer for regional context.
  geom_sf(
    data = map_context,
    fill = "gray93",
    color = "gray60",
    linewidth = 0.3
  ) +

  # Plot actual Garmin dive entry locations.
  # Point color represents maximum depth in meters.
  geom_sf(
    data = dive_sf %>% filter(!is.na(max_depth_m)),
    aes(color = max_depth_m),
    size = 2.8,
    alpha = 0.85
  ) +

  # Plot locations with missing depth data in neutral gray.
  geom_sf(
    data = dive_sf %>% filter(is.na(max_depth_m)),
    color = "gray30",
    size = 2.8,
    alpha = 0.85
  ) +

  # Use a continuous color scale for maximum depth.
  scale_color_viridis_c(
    option = "C",
    name = "Maximum Depth (m)",
    na.value = "gray30"
  ) +

  # Add north arrow.
  annotation_north_arrow(
    location = "tr",
    which_north = "true",
    style = north_arrow_fancy_orienteering
  ) +

  # Add scale bar.
  annotation_scale(
    location = "bl",
    width_hint = 0.25,
    text_cex = 0.8
  ) +

  # Set map extent and coordinate labels.
  coord_sf(
    xlim = c(-90, -78),
    ylim = c(16, 28),
    expand = FALSE
  ) +

  # Add title, axis labels, and data attribution.
  labs(
    title = "Geographic Distribution of Garmin Dive Locations",
    subtitle = "Dive locations colored by maximum recorded depth",
    x = "Longitude (decimal degrees)",
    y = "Latitude (decimal degrees)",
    caption = paste(
      "Source: Garmin Connect dive activity export;",
      "coordinates represent dive entry locations (exit used if entry unavailable);",
      "geographic boundaries: Natural Earth."
    )
  ) +

  # Apply a clean map theme.
  theme_minimal(base_size = 13) +
  theme(
    plot.title = element_text(
      size = 17,
      face = "bold"
    ),
    plot.subtitle = element_text(size = 11),
    axis.title = element_text(face = "bold"),
    legend.title = element_text(face = "bold"),
    legend.position = "right",
    panel.grid.major = element_line(
      color = "gray85",
      linewidth = 0.3
    ),
    plot.caption = element_text(
      hjust = 0,
      size = 8
    )
  )


# 7. Display map ------------------------------------------------

print(spatial_map)


# 8. Export map -------------------------------------------------

# Create the output directory if it does not already exist.
dir.create(
  here("results", "img"),
  recursive = TRUE,
  showWarnings = FALSE
)

# Export the map as a high-resolution PNG.
ggsave(
  filename = here(
    "results",
    "img",
    "spatial_data_visualization.png"
  ),
  plot = spatial_map,
  width = 12,
  height = 9,
  dpi = 300,
  bg = "white"
)

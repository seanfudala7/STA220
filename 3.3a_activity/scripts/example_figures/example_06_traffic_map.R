# scripts/example_figures/example_06_traffic_map.R
# Example 6: Which section carries the most cars? (The same numbers as Example 2, drawn on a map.)
#   New: left_join() a table onto the shapes (shapes go on the left, so it stays a map, as in 3.3),
#   and linewidth mapped to a number: the thicker the line, the more traffic.
#   Data: made up (see scripts/01_make_data.R)


# Packages and Load the Data ---------------------------------------------------------------------

library(tidyverse)
library(sf)

pine_towns <- read_sf("data/pine_towns.gpkg")

bike_corridors <- read_sf("data/bike_corridors.gpkg")

bike_yearly <- read_csv("data/bike_yearly.csv")

# One colour per section, the same in every example
section_colours <- c(
  "Dogwood Curve"      = "#2a78d6",
  "Elm Bridge"         = "#eb6834",
  "Cedar Interchange"  = "#1baf7a",
  "Birch Straightaway" = "#eda100"
)


# One Number for Each Line -----------------------------------------------------------------------

bike_2025 <- bike_yearly |>
  filter(year == 2025) |>
  select(corridor, bikes_per_day)

corridors_2025 <- bike_corridors |>
  left_join(bike_2025, by = "corridor")

# Expect 4 rows, with bikes_per_day filled in for every corridor
corridors_2025


# The Figure -------------------------------------------------------------------------------------

fig_06 <- ggplot() +
  geom_sf(data = pine_towns, fill = "grey95", colour = "white") +
  geom_sf_text(data = pine_towns, aes(label = town), colour = "grey50") +
  geom_sf(data = corridors_2025, aes(colour = corridor, linewidth = bikes_per_day)) +
  scale_colour_manual(values = corridor_colours) +
  labs(
    title = "College Avenues carries more bikes than any other section",
    subtitle = "Bike traffic per day in 2025. The thicker the line, the more traffic.",
    colour = "Corridor",
    linewidth = "Bikes per day",
    caption = "Made-up data for practice. Pine County does not exist."
  ) +
  theme_void()

fig_06

ggsave("output/figures/example_06_traffic_map.png", fig_06, width = 7.5, height = 5.5, bg = "white")

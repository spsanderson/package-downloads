
# Lib Load ----------------------------------------------------------------

pacman::p_load(
  "tidyverse"
  , "timetk"
  , "knitr"
  , "lubridate"
  , "countrycode"
  , "leaflet"
  , "tmaptools"
  , "htmltools"
)

# Data --------------------------------------------------------------------


df_tbl <- read_rds("old_downloads.RDS") %>%
  as_tibble()


# Geocode -----------------------------------------------------------------

country_vector <- df_tbl %>%
  mutate(country_name = countrycode(country, "iso2c", "country.name")) %>%
  select(country_name) %>%
  distinct() %>%
  filter(!is.na(country_name)) %>%
  pull()

# Map the geocode_OSM function to the vector
geocode_tbl <- country_vector %>%
  map(function(x) geocode_OSM(x, return.first.only = TRUE, as.data.frame = TRUE,
                              details = TRUE)) %>%
  map_dfr(~ as.data.frame(.))

# Coerce to a tibble and rename columns
geocode_map_tbl <- geocode_tbl %>%
  as_tibble() %>%
  select(query, lat, lon, display_name, icon) %>%
  set_names("country","latitude","longitude","display_name","icon")

# Write file to RDS for later use in mapping
write_rds(
  x = geocode_map_tbl
  , file = "mapping_dataset.rds"
)


# Manipulation ------------------------------------------------------------

geocode_map_tbl <- readRDS("mapping_dataset.rds")
df_tbl <- readRDS("old_downloads.RDS")

country_count_tbl <- df_tbl %>%
  mutate(
    date_time = str_c(date, time, sep = " ") %>%
      ymd_hms()
  ) %>%
  select(!starts_with("r_")) %>%
  mutate(country_name = countrycode(country, "iso2c", "country.name")) %>%
  filter(!is.na(country_name)) %>%
  count(country_name)

# Map ---------------------------------------------------------------------

map_data <- geocode_map_tbl %>%
  left_join(country_count_tbl, by = c("country" = "country_name"))

leaflet(data = map_data) %>%
  addTiles() %>%
  addMarkers(lng = ~longitude, lat = ~latitude, label = ~htmlEscape(country),
             popup = ~as.character(
               paste(
                 "<strong>Country: </strong>"
                 , country
                 , "<br><strong>Display Name: </strong>"
                 , display_name
                 , "<br><strong>Downloads: </strong>"
                 , n
               )
             )
          )

library(tidyverse)

pkg_tbl <- readRDS("pkg_release_tbl.rds")
df_tbl <- readRDS("old_downloads.RDS")

df_tbl %>%
  select(date) %>%
  timetk::summarise_by_time(.date_var = date, .by = "day", N = n()) %>%
  timetk::tk_augment_differences(.value = N, .differences = 1) %>%
  timetk::tk_augment_differences(.value = N, .differences = 2) %>%
  rename(velocity = contains("_diff1")) %>%
  rename(acceleration = contains("_diff2")) %>%
  pivot_longer(-date) %>%
  mutate(name = str_to_title(name)) %>%
  mutate(name = as_factor(name)) %>%
  ggplot(aes(x = date, y = value, group = name, color = name)) +
  #geom_line() +
  geom_point() +
  geom_vline(
    data = pkg_tbl
    , aes(xintercept = as.numeric(date))
    , color = "red"
    , lwd = 1
    , lty = "solid"
  ) +
  facet_wrap(name ~ ., ncol = 1, scale = "free") +
  theme_minimal() +
  labs(
    title = "Total Downloads: Trend, Velocity, and Accelertion",
    subtitle = "Vertical Lines Indicate a CRAN Release",
    x = "Date",
    y = "",
    color = ""
  ) +
  theme(legend.position = "bottom")

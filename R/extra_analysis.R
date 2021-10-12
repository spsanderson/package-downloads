
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

df_tbl %>%
  mutate(
    date_time = str_c(date, time, sep = " ") %>%
      ymd_hms()
  ) %>%
  select(!starts_with("r_")) %>%
  mutate(country_name = countrycode(country, "iso2c", "country.name")) %>%
  count(country_name)

# Map ---------------------------------------------------------------------

leaflet(data = geocode_map_tbl) %>%
  addTiles() %>%
  addMarkers(lng = ~longitude, lat = ~latitude, label = ~htmlEscape(country),
             icon = ~icon)

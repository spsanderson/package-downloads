
# Lib Load ----------------------------------------------------------------

pacman::p_load(
  "tidyverse"
  , "timetk"
  , "knitr"
  , "lubridate"
  , "countrycode"
  , "leaflet"
  , "tmaptools"
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
  select(query, lat, lon, display_name) %>%
  set_names("country","latitude","longitude","display_name")


# Manipulation ------------------------------------------------------------

df_tbl %>%
  mutate(
    date_time = str_c(date, time, sep = " ") %>%
      ymd_hms()
  ) %>%
  select(!starts_with("r_")) %>%
  mutate(country_name = countrycode(country, "iso2c", "country.name")) %>%
  filter(country != "US")  %>%
  count(country_name) %>%
  arrange(desc(n))

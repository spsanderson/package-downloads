
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


df <- read_rds("old_downloads.RDS")
df_tbl <- df %>%
  as_tibble()

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
  glimpse()

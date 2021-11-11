
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

pkg_tbl <- readRDS("pkg_release_tbl.rds")
dl_tbl <- df_tbl %>%
  group_by(package, version) %>%
  summarise_by_time(
    .date_var = date,
    .by = "day",
    N = n()
  ) %>%
  ungroup() %>%
  select(date, package, version, N) %>%
  left_join(pkg_tbl) %>%
  mutate(release_record = ifelse(is.na(release_record), 0, 1))

healthyR_vline <- subset(dl_tbl, (release_record == 1 & package == "healthyR"))$date
healthyR_vline <- which(dl_tbl$date %in% healthyR_vline)

dl_tbl %>%
  filter(package == "healthyR") %>%
  plot_time_series(
    .date_var = date,
    .value = N,
    .smooth = FALSE,
    .interactive = FALSE
  ) +
  geom_vline(xintercept = as.numeric(dl_tbl$date[healthyR_vline]), color = "red")

dl_tbl %>%
ggplot(aes(date, log1p(N))) +
  theme_bw() +
  geom_point(aes(group = package, color = package), size = 1) +
  geom_line() +
  ggtitle(paste("Package Downloads: {healthyverse}")) +
  ylab("Counts") +
  geom_smooth(method = "loess", color = "black",  se = FALSE) +
  geom_vline(
    data = pkg_tbl
    , aes(xintercept = as.numeric(date))
    , color = "red"
    , lwd = 1
    , lty = "solid"
  ) +
  facet_wrap(package~., ncol = 2) +
  tidyquant::theme_tq() +
  tidyquant::scale_color_tq() +
  labs(
    subtitle = "Dashed lines represent release dates",
    caption = "log1p scale",
    x = "Date",
    y = "log1p(Counts)",
    color = "Package"
  )

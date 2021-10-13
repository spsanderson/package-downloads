#' Mapping Data
#'
#' @return
#' A tibble
#'
#' @export
mapping_dataset <- function(){
  if(file.exists("mapping_dataset.rds")){
    map_data <- readRDS("mapping_dataset.rds") %>%
      dplyr::as_tibble()

    # make sure all countries are geocoded, if not then geocode them
    current_country_vector <- map_data %>%
      dplyr::pull(country)

    tmp                    <- readRDS("old_downloads.RDS")
    new_country_vector     <- tmp %>%
      dplyr::mutate(
        country_name = countrycode::countrycode(country, "iso2c", "country.name")
      ) %>%
      dplyr::select(country_name) %>%
      dplyr::distinct() %>%
      dplyr::filter(!is.na(country_name)) %>%
      dplyr::pull()

    countries_to_geocode <- setdiff(new_country_vector, current_country_vector)

    if(length(countries_to_geocode) != 0){
      new_geocode_tbl <- country_vector %>%
        purrr::map(
          function(x) tmaptools::geocode_OSM(
            x, return.first.only = TRUE, as.data.frame = TRUE, details = TRUE
          )
        ) %>%
        purrr::map_dfr(~ base::as.data.frame(.))

      # Coerce to a tibble and rename columns
      new_geocode_map_tbl <- geocode_tbl %>%
        dplyr::as_tibble() %>%
        dplyr::select(query, lat, lon, display_name, icon) %>%
        purrr::set_names("country","latitude","longitude","display_name","icon")

      map_data <- rbind(map_data, new_geocode_map_tbl)

      # Write file to RDS for later use in mapping
      saveRDS(
        object = map_data
        , file = "mapping_dataset.rds"
      )

      map_data <- readRDS("mapping_dataset.rds")

    }

  } else {
    message("There is no mapping data present. Will attempt to create.")

    if(!file.exists("old_downloads.RDS")){
      message("There is nothing to geocode.")
    } else {
      df_tbl <- readRDS("old_downloads.rds") %>%
        dplyr::as_tibble()

      # Get countries as a character vector
      country_vector <- df_tbl %>%
        dplyr::mutate(
          country_name = countrycode::countrycode(country, "iso2c", "country.name")
        ) %>%
        dplyr::select(country_name) %>%
        dplyr::distinct() %>%
        dplyr::filter(!is.na(country_name)) %>%
        dplyr::pull()

      # Map the geocode_OSM function to the vector
      geocode_tbl <- country_vector %>%
        purrr::map(
          function(x) tmaptools::geocode_OSM(
            x, return.first.only = TRUE, as.data.frame = TRUE, details = TRUE
          )
        ) %>%
        purrr::map_dfr(~ base::as.data.frame(.))

      # Coerce to a tibble and rename columns
      geocode_map_tbl <- geocode_tbl %>%
        dplyr::as_tibble() %>%
        dplyr::select(query, lat, lon, display_name, icon) %>%
        purrr::set_names("country","latitude","longitude","display_name","icon")

      # Write file to RDS for later use in mapping
      saveRDS(
        object = geocode_map_tbl
        , file = "mapping_dataset.rds"
      )

      map_data <- readRDS("mapping_dataset.rds")

    }
  }

  return(map_data)
}

#' Leaflet Map
#'
#' @return
#' A leaflet map
#'
#' @export
map_leaflet <- function(){

  df_tbl <- readRDS("old_downloads.rds")

  country_count_tbl <- df_tbl %>%
    dplyr::mutate(
      country_name = countrycode::countrycode(country, "iso2c", "country.name")
    ) %>%
    dplyr::filter(!is.na(country_name)) %>%
    dplyr::count(country_name)

  geocode_map_tbl <- mapping_dataset()

  # Map ---------------------------------------------------------------------
  map_data <- geocode_map_tbl %>%
    dplyr::left_join(country_count_tbl, by = c("country" = "country_name"))

  l <- leaflet::leaflet(data = map_data) %>%
    leaflet::addTiles() %>%
    leaflet::addMarkers(
      lng = ~longitude
      , lat = ~latitude
      , label = ~htmltools::htmlEscape(country)
      , popup = ~as.character(
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

  return(l)
}

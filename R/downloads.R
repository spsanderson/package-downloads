#' Download Logs
#'
#' @return
#' A data.table
#'
#' @export
download_logs <- function(from = Sys.Date() - 9,
                          to = Sys.Date() - 2,
                          cache = TRUE) {
  if (cache) {
    file <- paste0(".", "_cache.rds")
    if (file.exists(file)) {
      old_downloads <- readRDS(file)
    }
  }

  if(file.exists("old_downloads.RDS")){
    old_downloads <- readRDS("old_downloads.RDS")
  }

  dates <- as.Date(from:to, origin = "1970-01-01")
  if (exists("old_downloads")) {
    new_dates <- dates[!dates %in% old_downloads$date]
  } else {
    new_dates <- dates
  }

  if (length(new_dates)) {
    n_cores <- min(length(new_dates), parallel::detectCores() - 2)
    cl <- parallel::makeCluster(n_cores)
    downloads <- parallel::parLapply(cl, new_dates, function(date) {
      base_url <- "http://cran-logs.rstudio.com/"
      year     <- lubridate::year(date)
      file     <- paste0(as.character(date), ".csv.gz")
      url      <- paste0(base_url, year, "/", file)
      # Download the file
      utils::download.file(url, file)
      # Read the file int
      downloads <- data.table::fread(file)
      # Remove file after reading
      file.remove(file)
      # Get only the dates and packages we want
      downloads[, date := as.Date(date)]
      downloads[package %in% c("healthyR","healthyR.ts","healthyR.data","healthyverse")]
    })
    parallel::stopCluster(cl)

    downloads <- data.table::rbindlist(downloads)
    if (exists("old_downloads")) {
      downloads <- rbind(old_downloads, downloads)
    }
  } else {
    downloads <- old_downloads
  }

  if (cache) {
    saveRDS(downloads, file)
  }
  saveRDS(downloads, "old_downloads.RDS")
  data.table::setorder(downloads, date)
  #downloads[date %in% dates]
}

#' @export
compute_daily_downloads <- function(downloads, pkg = NULL) {

  if(is.null(pkg)){
    daily_downloads <- downloads[, .N, by = date]
    daily_downloads[, cumulative_N := cumsum(N)]
    daily_downloads
  } else {
    daily_downloads <- downloads %>%
      filter(package == pkg)
    daily_downloads <- daily_downloads[, .N, by = date]
    daily_downloads[, cumulative_N := cumsum(N)]
    daily_downloads
  }

}

#' @export
compute_downloads_by_country <- function(downloads, pkg = NULL) {

  if(is.null(pkg)){
    downloads_by_country <- downloads[, .N, by = country]
    data.table::setnames(downloads_by_country, "country", "code")
    downloads_by_country[, country := countrycode::countrycode(code, "iso2c", "country.name")]
    downloads_by_country
  } else {
    downloads <- downloads %>%
      filter(package == pkg)
    downloads_by_country <- downloads[, .N, by = country]
    data.table::setnames(downloads_by_country, "country", "code")
    downloads_by_country[, country := countrycode::countrycode(code, "iso2c", "country.name")]
    downloads_by_country
  }
  # downloads_by_country <- downloads[, .N, by = country]
  # data.table::setnames(downloads_by_country, "country", "code")
  # downloads_by_country[, country := countrycode::countrycode(code, "iso2c", "country.name")]
  # downloads_by_country
}

#' Top N Downloads
#'
#' @return
#' A tibble
#'
#' @export
top_n_downloads <- function(downloads, .n, ...) {
  loadNamespace("magrittr")
  top_n_tbl <- downloads %>%
    dplyr::count(...) %>%
    dplyr::slice_head(n = .n) %>%
    dplyr::arrange(dplyr::desc(n))

  top_n_tbl
}

CRAN Downloads
================
Steven P. Sanderson II, MPH - Date:
26 January, 2024

This repo contains the analysis of downloads of my `R` packages:

- [`healthyR`](https://www.spsanderson.com/healthyR/)
- [`healthyR.data`](https://www.spsanderson.com/healthyR.data/)
- [`healthyR.ts`](https://www.spsanderson.com/healthyR.ts/)
- [`healthyR.ai`](https://www.spsanderson.com/healthyR.ai/)
- [`healthyverse`](https://www.spsanderson.com/healthyverse/)
- [`TidyDensity`](https://www.spsanderson.com/TidyDensity/)
- [`tidyAML`](https://www.spsanderson.com/tidyAML/)

All of which follow the [“analyses as
package”](https://rmflight.github.io/posts/2014/07/analyses_as_packages.html)
philosophy this repo itself is an `R` package that can installed using
`remotes::install_github()`.

I have forked this project itself from
[`ggcharts-analysis`](https://github.com/thomas-neitmann/ggcharts-downloads).

While I analyze `healthyverse` packages here, the functions are written
in a way that you can analyze any CRAN package with a slight
modification to the `download_log` function.

This file was last updated on January 26, 2024.

``` r
library(packagedownloads)
library(tidyverse)
library(patchwork)
library(timetk)
library(knitr)
library(leaflet)
library(htmltools)
library(tmaptools)
library(mapview)
library(countrycode)
library(htmlwidgets)
library(webshot)
library(rmarkdown)
library(dtplyr)
```

``` r
start_date      <- Sys.Date() - 9 #as.Date("2020-11-15")
end_date        <- Sys.Date() - 2
total_downloads <- download_logs(start_date, end_date)
interactive     <- FALSE
pkg_release_date_tbl()
```

# Last Full Day Data

``` r
downloads            <- total_downloads |> filter(date == max(date))
daily_downloads      <- compute_daily_downloads(downloads)
downloads_by_country <- compute_downloads_by_country(downloads)

p1 <- plot_cumulative_downloads(daily_downloads)
p2 <- plot_downloads_by_country(downloads_by_country)

f <- function(date) format(date, "%b %d, %Y")
patchwork_theme <- theme_classic(base_size = 24) +
  theme(
    plot.title   = element_text(face = "bold"),
    plot.caption = element_text(size = 14)
  )
p1 + p2 +
  plot_annotation(
    title    = "healthyverse Packages - Last Full Day",
    subtitle = "A Summary of Downloads from the RStudio CRAN Mirror",
    caption  = glue::glue("Source: RStudio CRAN Logs for {f(end_date)}"),
    theme    = patchwork_theme
  )
```

![](man/figures/README-last_full_day-1.png)<!-- -->

``` r
downloads |>
  count(package, version) |> 
  tidyr::pivot_wider(
    id_cols       = version
    , names_from  = package
    , values_from = n
    , values_fill = 0
    ) |>
  arrange(version) |>
  kable()
```

| version | TidyDensity | healthyR | healthyR.ai | healthyR.data | healthyR.ts | healthyverse | tidyAML |
|:--------|------------:|---------:|------------:|--------------:|------------:|-------------:|--------:|
| 0.0.1   |           4 |        0 |           4 |             0 |           0 |            0 |       4 |
| 0.0.10  |           0 |        0 |           4 |             0 |           0 |            0 |       0 |
| 0.0.11  |           0 |        0 |           4 |             0 |           0 |            0 |       0 |
| 0.0.12  |           0 |        0 |           4 |             0 |           0 |            0 |       0 |
| 0.0.13  |           0 |        0 |          92 |             0 |           0 |            0 |       0 |
| 0.0.2   |           0 |        0 |           3 |             0 |           0 |            0 |      16 |
| 0.0.3   |           0 |        0 |           3 |             0 |           0 |            0 |       9 |
| 0.0.4   |           0 |        0 |           4 |             0 |           0 |            0 |      78 |
| 0.0.5   |           0 |        0 |           3 |             0 |           0 |            0 |       0 |
| 0.0.6   |           0 |        0 |          16 |             0 |           0 |            0 |       0 |
| 0.0.7   |           0 |        0 |           4 |             0 |           0 |            0 |       0 |
| 0.0.8   |           0 |        0 |           4 |             0 |           0 |            0 |       0 |
| 0.0.9   |           0 |        0 |           4 |             0 |           0 |            0 |       0 |
| 0.1.0   |           0 |        3 |           0 |             0 |           4 |            0 |       0 |
| 0.1.1   |           0 |        3 |           0 |             0 |           9 |            0 |       0 |
| 0.1.2   |           0 |       10 |           0 |             0 |           4 |            0 |       0 |
| 0.1.3   |           0 |        3 |           0 |             0 |           3 |            0 |       0 |
| 0.1.4   |           0 |        3 |           0 |             0 |           4 |            0 |       0 |
| 0.1.5   |           0 |        3 |           0 |             0 |           5 |            0 |       0 |
| 0.1.6   |           0 |        4 |           0 |             0 |           5 |            0 |       0 |
| 0.1.7   |           0 |        3 |           0 |             0 |           3 |            0 |       0 |
| 0.1.8   |           0 |       16 |           0 |             0 |          16 |            0 |       0 |
| 0.1.9   |           0 |        4 |           0 |             0 |           4 |            0 |       0 |
| 0.2.0   |           0 |        4 |           0 |             0 |           5 |            0 |       0 |
| 0.2.1   |           0 |       90 |           0 |             0 |           5 |            0 |       0 |
| 0.2.10  |           0 |        0 |           0 |             0 |           5 |            0 |       0 |
| 0.2.11  |           0 |        0 |           0 |             0 |           5 |            0 |       0 |
| 0.2.2   |           0 |        0 |           0 |             0 |           4 |            0 |       0 |
| 0.2.3   |           0 |        0 |           0 |             0 |           4 |            0 |       0 |
| 0.2.4   |           0 |        0 |           0 |             0 |           5 |            0 |       0 |
| 0.2.5   |           0 |        0 |           0 |             0 |           4 |            0 |       0 |
| 0.2.6   |           0 |        0 |           0 |             0 |           5 |            0 |       0 |
| 0.2.7   |           0 |        0 |           0 |             0 |           4 |            0 |       0 |
| 0.2.8   |           0 |        0 |           0 |             0 |          15 |            0 |       0 |
| 0.2.9   |           0 |        0 |           0 |             0 |           4 |            0 |       0 |
| 0.3.0   |           0 |        0 |           0 |             0 |          80 |            0 |       0 |
| 1.0.0   |           4 |        0 |           0 |             5 |           0 |            9 |       0 |
| 1.0.1   |          15 |        0 |           0 |            24 |           0 |            5 |       0 |
| 1.0.2   |           0 |        0 |           0 |            10 |           0 |           18 |       0 |
| 1.0.3   |           0 |        0 |           0 |            84 |           0 |            6 |       0 |
| 1.0.4   |           0 |        0 |           0 |             0 |           0 |           90 |       0 |
| 1.1.0   |           4 |        0 |           0 |             0 |           0 |            0 |       0 |
| 1.2.0   |           4 |        0 |           0 |             0 |           0 |            0 |       0 |
| 1.2.1   |           4 |        0 |           0 |             0 |           0 |            0 |       0 |
| 1.2.2   |           4 |        0 |           0 |             0 |           0 |            0 |       0 |
| 1.2.3   |           4 |        0 |           0 |             0 |           0 |            0 |       0 |
| 1.2.4   |          16 |        0 |           0 |             0 |           0 |            0 |       0 |
| 1.2.5   |           4 |        0 |           0 |             0 |           0 |            0 |       0 |
| 1.2.6   |           9 |        0 |           0 |             0 |           0 |            0 |       0 |
| 1.3.0   |          83 |        0 |           0 |             0 |           0 |            0 |       0 |

``` r
downloads |>
  count(package) |>
  tidyr::pivot_wider(
    names_from = package,
    values_from = n,
    values_fill = 0
  ) |>
  kable()
```

| TidyDensity | healthyR | healthyR.ai | healthyR.data | healthyR.ts | healthyverse | tidyAML |
|------------:|---------:|------------:|--------------:|------------:|-------------:|--------:|
|         155 |      146 |         149 |           123 |         202 |          128 |     107 |

# Current Trend

Here are the current 7 day trends for the `healthyverse` suite of
packages.

``` r
downloads            <- total_downloads[date >= start_date]
daily_downloads      <- compute_daily_downloads(downloads)
downloads_by_country <- compute_downloads_by_country(downloads)

p1 <- plot_daily_downloads(daily_downloads)
p2 <- plot_cumulative_downloads(daily_downloads)
p3 <- hist_daily_downloads(daily_downloads)
p4 <- plot_downloads_by_country(downloads_by_country)

f <- function(date) format(date, "%b %d, %Y")
patchwork_theme <- theme_classic(base_size = 24) +
  theme(
    plot.title   = element_text(face = "bold"),
    plot.caption = element_text(size = 14)
  )
p1 + p2 + p3 + p4 +
  plot_annotation(
    title    = "healthyverse Packages - 7 Day Trend",
    subtitle = "A Summary of Downloads from the RStudio CRAN Mirror",
    caption  = glue::glue("Source: RStudio CRAN Logs ({f(start_date)} to {f(end_date)})"),
    theme    = patchwork_theme
  )
```

![](man/figures/README-analysis_7_day-1.png)<!-- -->

# Since Inception

``` r
start_date <- as.Date("2020-11-15")

daily_downloads <- compute_daily_downloads(downloads = total_downloads)
downloads_by_country <- compute_downloads_by_country(downloads = total_downloads)

p1 <- plot_daily_downloads(daily_downloads)
p2 <- plot_cumulative_downloads(daily_downloads)
p3 <- hist_daily_downloads(daily_downloads)
p4 <- plot_downloads_by_country(downloads_by_country)

f <- function(date) format(date, "%b %d, %Y")
patchwork_theme <- theme_classic(base_size = 24) +
  theme(
    plot.title   = element_text(face = "bold"),
    plot.caption = element_text(size = 14)
  )
p1 + p2 + p3 + p4 +
  plot_annotation(
    title    = "healthyR packages are on the Rise",
    subtitle = "A Summary of Downloads from the RStudio CRAN Mirror - Since Inception",
    caption  = glue::glue("Source: RStudio CRAN Logs ({f(start_date)} to {f(end_date)})"),
    theme    = patchwork_theme
  )
```

![](man/figures/README-total_data-1.png)<!-- -->

# By Release Date

``` r
pkg_tbl <- readRDS("pkg_release_tbl.rds")
dl_tbl <- total_downloads %>%
  group_by(package) %>%
  summarise_by_time(
    .date_var = date,
    .by = "week",
    N = n()
  ) %>%
  ungroup() %>%
  select(date, package, N)

dl_tbl %>%
ggplot(aes(date, log1p(N))) +
  theme_bw() +
  geom_point(aes(group = package, color = package), size = 1) +
  geom_line(aes(group = package, color = package)) +
  ggtitle(paste("Package Downloads: {healthyverse}")) +
  geom_smooth(method = "loess", color = "black",  se = FALSE) +
  geom_vline(
    data = pkg_tbl
    , aes(xintercept = as.numeric(date))
    , color = "red"
    , lwd = 1
    , lty = "solid"
  ) +
  facet_wrap(package ~., ncol = 2, scales = "free_x") +
  theme_minimal() +
  labs(
    subtitle = "Vertical lines represent release dates",
    x = "Date",
    y = "log1p(Counts)",
    color = "Package"
  ) +
  theme(legend.position = "bottom")
```

![](man/figures/README-release_date_plt-1.png)<!-- -->

``` r
dl_tbl %>%
  select(date, N) %>%
  summarise_by_time(
    .date_var = date,
    .by = "week",
    Actual = sum(N, na.rm = TRUE)
  ) %>%
  tk_augment_differences(.value = Actual, .differences = 1) %>%
  tk_augment_differences(.value = Actual, .differences = 2) %>%
  rename(velocity = contains("_diff1")) %>%
  rename(acceleration = contains("_diff2")) %>%
  pivot_longer(-date) %>%
  mutate(name = str_to_title(name)) %>%
  mutate(name = as_factor(name)) %>%
  ggplot(aes(x = date, y = log1p(value), group = name)) +
  geom_point(alpha = .2) +
  geom_vline(
    data = pkg_tbl
    , aes(xintercept = as.numeric(date), color = package)
    , lwd = 1
    , lty = "solid"
  ) +
  facet_wrap(name ~ ., ncol = 1, scale = "free") +
  theme_minimal() +
  labs(
    title = "Total Downloads: Trend, Velocity, and Accelertion",
    subtitle = "Vertical Lines Indicate a CRAN Release date for a package.",
    x = "Date",
    y = "",
    color = ""
  ) +
  theme(legend.position = "bottom")
```

![](man/figures/README-release_date_plt-2.png)<!-- -->

# Map of Downloads

A `leaflet` map of countries where a package has been downloaded.

``` r
mapping_dataset() %>%
  head() %>%
  knitr::kable()

l <- map_leaflet()
saveWidget(l, "downloads_map.html")
webshot("downloads_map.html", file = "map.png",
        cliprect = "viewport")
```

To date there has been downloads in a total of 145 different countries.

# Analysis by Package

## healthyR

``` r
start_date <- as.Date("2020-11-15")
pkg <- "healthyR"

daily_downloads <- compute_daily_downloads(
  downloads = total_downloads
  , pkg = pkg)
downloads_by_country <- compute_downloads_by_country(
  downloads = total_downloads
  , pkg = pkg)

p1 <- plot_daily_downloads(daily_downloads)
p2 <- plot_cumulative_downloads(daily_downloads)
p3 <- hist_daily_downloads(daily_downloads)
p4 <- plot_downloads_by_country(downloads_by_country)

f <- function(date) format(date, "%b %d, %Y")
patchwork_theme <- theme_classic(base_size = 24) +
  theme(
    plot.title   = element_text(face = "bold"),
    plot.caption = element_text(size = 14)
  )
p1 + p2 + p3 + p4 +
  plot_annotation(
    title    = glue::glue("Package: {pkg}"),
    subtitle = "A Summary of Downloads from the RStudio CRAN Mirror - Since Inception",
    caption  = glue::glue("Source: RStudio CRAN Logs ({f(start_date)} to {f(end_date)})"),
    theme    = patchwork_theme
  )
```

![](man/figures/README-healthyR_analysis-1.png)<!-- -->

## healthyR.ts

``` r
start_date <- as.Date("2020-11-15")
pkg <- "healthyR.ts"

daily_downloads <- compute_daily_downloads(
  downloads = total_downloads
  , pkg = pkg)
downloads_by_country <- compute_downloads_by_country(
  downloads = total_downloads
  , pkg = pkg)

p1 <- plot_daily_downloads(daily_downloads)
p2 <- plot_cumulative_downloads(daily_downloads)
p3 <- hist_daily_downloads(daily_downloads)
p4 <- plot_downloads_by_country(downloads_by_country)

f <- function(date) format(date, "%b %d, %Y")
patchwork_theme <- theme_classic(base_size = 24) +
  theme(
    plot.title   = element_text(face = "bold"),
    plot.caption = element_text(size = 14)
  )
p1 + p2 + p3 + p4 +
  plot_annotation(
    title    = glue::glue("Package: {pkg}"),
    subtitle = "A Summary of Downloads from the RStudio CRAN Mirror - Since Inception",
    caption  = glue::glue("Source: RStudio CRAN Logs ({f(start_date)} to {f(end_date)})"),
    theme    = patchwork_theme
  )
```

![](man/figures/README-healthyRts_analysis-1.png)<!-- -->

## healthyR.data

``` r
start_date <- as.Date("2020-11-15")
pkg <- "healthyR.data"

daily_downloads <- compute_daily_downloads(
  downloads = total_downloads
  , pkg = pkg)
downloads_by_country <- compute_downloads_by_country(
  downloads = total_downloads
  , pkg = pkg)

p1 <- plot_daily_downloads(daily_downloads)
p2 <- plot_cumulative_downloads(daily_downloads)
p3 <- hist_daily_downloads(daily_downloads)
p4 <- plot_downloads_by_country(downloads_by_country)

f <- function(date) format(date, "%b %d, %Y")
patchwork_theme <- theme_classic(base_size = 24) +
  theme(
    plot.title   = element_text(face = "bold"),
    plot.caption = element_text(size = 14)
  )
p1 + p2 + p3 + p4 +
  plot_annotation(
    title    = glue::glue("Package: {pkg}"),
    subtitle = "A Summary of Downloads from the RStudio CRAN Mirror - Since Inception",
    caption  = glue::glue("Source: RStudio CRAN Logs ({f(start_date)} to {f(end_date)})"),
    theme    = patchwork_theme
  )
```

![](man/figures/README-healthyRdata_analysis-1.png)<!-- -->

## healthyR.ai

``` r
start_date <- as.Date("2020-11-15")
pkg <- "healthyR.ai"

daily_downloads <- compute_daily_downloads(
  downloads = total_downloads
  , pkg = pkg)
downloads_by_country <- compute_downloads_by_country(
  downloads = total_downloads
  , pkg = pkg)

p1 <- plot_daily_downloads(daily_downloads)
p2 <- plot_cumulative_downloads(daily_downloads)
p3 <- hist_daily_downloads(daily_downloads)
p4 <- plot_downloads_by_country(downloads_by_country)

f <- function(date) format(date, "%b %d, %Y")
patchwork_theme <- theme_classic(base_size = 24) +
  theme(
    plot.title   = element_text(face = "bold"),
    plot.caption = element_text(size = 14)
  )
p1 + p2 + p3 + p4 +
  plot_annotation(
    title    = glue::glue("Package: {pkg}"),
    subtitle = "A Summary of Downloads from the RStudio CRAN Mirror - Since Inception",
    caption  = glue::glue("Source: RStudio CRAN Logs ({f(start_date)} to {f(end_date)})"),
    theme    = patchwork_theme
  )
```

![](man/figures/README-healthyRai_analysis-1.png)<!-- -->

## healthyverse

``` r
start_date <- as.Date("2020-11-15")
pkg <- "healthyverse"

daily_downloads <- compute_daily_downloads(
  downloads = total_downloads
  , pkg = pkg)
downloads_by_country <- compute_downloads_by_country(
  downloads = total_downloads
  , pkg = pkg)

p1 <- plot_daily_downloads(daily_downloads)
p2 <- plot_cumulative_downloads(daily_downloads)
p3 <- hist_daily_downloads(daily_downloads)
p4 <- plot_downloads_by_country(downloads_by_country)

f <- function(date) format(date, "%b %d, %Y")
patchwork_theme <- theme_classic(base_size = 24) +
  theme(
    plot.title   = element_text(face = "bold"),
    plot.caption = element_text(size = 14)
  )
p1 + p2 + p3 + p4 +
  plot_annotation(
    title    = glue::glue("Package: {pkg}"),
    subtitle = "A Summary of Downloads from the RStudio CRAN Mirror - Since Inception",
    caption  = glue::glue("Source: RStudio CRAN Logs ({f(start_date)} to {f(end_date)})"),
    theme    = patchwork_theme
  )
```

![](man/figures/README-healthyverse_analysis-1.png)<!-- -->

## TidyDensity

``` r
start_date <- as.Date("2020-11-15")
pkg <- "TidyDensity"

daily_downloads <- compute_daily_downloads(
  downloads = total_downloads
  , pkg = pkg)
downloads_by_country <- compute_downloads_by_country(
  downloads = total_downloads
  , pkg = pkg)

p1 <- plot_daily_downloads(daily_downloads)
p2 <- plot_cumulative_downloads(daily_downloads)
p3 <- hist_daily_downloads(daily_downloads)
p4 <- plot_downloads_by_country(downloads_by_country)

f <- function(date) format(date, "%b %d, %Y")
patchwork_theme <- theme_classic(base_size = 24) +
  theme(
    plot.title   = element_text(face = "bold"),
    plot.caption = element_text(size = 14)
  )
p1 + p2 + p3 + p4 +
  plot_annotation(
    title    = glue::glue("Package: {pkg}"),
    subtitle = "A Summary of Downloads from the RStudio CRAN Mirror - Since Inception",
    caption  = glue::glue("Source: RStudio CRAN Logs ({f(start_date)} to {f(end_date)})"),
    theme    = patchwork_theme
  )
```

![](man/figures/README-tidydensity_analysis-1.png)<!-- -->

## tidyAML

``` r
start_date <- as.Date("2023-02-13")
pkg <- "tidyAML"

daily_downloads <- compute_daily_downloads(
  downloads = total_downloads
  , pkg = pkg)
downloads_by_country <- compute_downloads_by_country(
  downloads = total_downloads
  , pkg = pkg)

p1 <- plot_daily_downloads(daily_downloads)
p2 <- plot_cumulative_downloads(daily_downloads)
p3 <- hist_daily_downloads(daily_downloads)
p4 <- plot_downloads_by_country(downloads_by_country)

f <- function(date) format(date, "%b %d, %Y")
patchwork_theme <- theme_classic(base_size = 24) +
  theme(
    plot.title   = element_text(face = "bold"),
    plot.caption = element_text(size = 14)
  )
p1 + p2 + p3 + p4 +
  plot_annotation(
    title    = glue::glue("Package: {pkg}"),
    subtitle = "A Summary of Downloads from the RStudio CRAN Mirror - Since Inception",
    caption  = glue::glue("Source: RStudio CRAN Logs ({f(start_date)} to {f(end_date)})"),
    theme    = patchwork_theme
  )
```

![](man/figures/README-tidyaml_analysis-1.png)<!-- -->

# Table Data

### Downloads by Package and Version

``` r
total_downloads %>% 
  count(package, version) %>% 
  tidyr::pivot_wider(
    id_cols       = version
    , names_from  = package
    , values_from = n
    , values_fill = 0
    ) %>%
  arrange(version) %>%
  kable()
```

| version | TidyDensity | healthyR | healthyR.ai | healthyR.data | healthyR.ts | healthyverse | tidyAML |
|:--------|------------:|---------:|------------:|--------------:|------------:|-------------:|--------:|
| 0.0.1   |        1158 |        0 |         474 |             0 |           0 |            0 |     798 |
| 0.0.10  |           0 |        0 |         603 |             0 |           0 |            0 |       0 |
| 0.0.11  |           0 |        0 |         440 |             0 |           0 |            0 |       0 |
| 0.0.12  |           0 |        0 |         693 |             0 |           0 |            0 |       0 |
| 0.0.13  |           0 |        0 |        2224 |             0 |           0 |            0 |       0 |
| 0.0.2   |           0 |        0 |        1725 |             0 |           0 |            0 |    1825 |
| 0.0.3   |           0 |        0 |         486 |             0 |           0 |            0 |     540 |
| 0.0.4   |           0 |        0 |         581 |             0 |           0 |            0 |     422 |
| 0.0.5   |           0 |        0 |        1151 |             0 |           0 |            0 |       0 |
| 0.0.6   |           0 |        0 |        1564 |             0 |           0 |            0 |       0 |
| 0.0.7   |           0 |        0 |         822 |             0 |           0 |            0 |       0 |
| 0.0.8   |           0 |        0 |         949 |             0 |           0 |            0 |       0 |
| 0.0.9   |           0 |        0 |         726 |             0 |           0 |            0 |       0 |
| 0.1.0   |           0 |      365 |           0 |             0 |         594 |            0 |       0 |
| 0.1.1   |           0 |     1414 |           0 |             0 |        2103 |            0 |       0 |
| 0.1.2   |           0 |     1628 |           0 |             0 |        1108 |            0 |       0 |
| 0.1.3   |           0 |      438 |           0 |             0 |        1226 |            0 |       0 |
| 0.1.4   |           0 |      487 |           0 |             0 |         791 |            0 |       0 |
| 0.1.5   |           0 |     1137 |           0 |             0 |         633 |            0 |       0 |
| 0.1.6   |           0 |     2338 |           0 |             0 |         376 |            0 |       0 |
| 0.1.7   |           0 |     1135 |           0 |             0 |        1361 |            0 |       0 |
| 0.1.8   |           0 |     1565 |           0 |             0 |        1539 |            0 |       0 |
| 0.1.9   |           0 |      994 |           0 |             0 |         601 |            0 |       0 |
| 0.2.0   |           0 |     2231 |           0 |             0 |         604 |            0 |       0 |
| 0.2.1   |           0 |     2658 |           0 |             0 |         421 |            0 |       0 |
| 0.2.10  |           0 |        0 |           0 |             0 |         513 |            0 |       0 |
| 0.2.11  |           0 |        0 |           0 |             0 |         537 |            0 |       0 |
| 0.2.2   |           0 |        0 |           0 |             0 |         658 |            0 |       0 |
| 0.2.3   |           0 |        0 |           0 |             0 |         655 |            0 |       0 |
| 0.2.4   |           0 |        0 |           0 |             0 |         276 |            0 |       0 |
| 0.2.5   |           0 |        0 |           0 |             0 |         574 |            0 |       0 |
| 0.2.6   |           0 |        0 |           0 |             0 |         434 |            0 |       0 |
| 0.2.7   |           0 |        0 |           0 |             0 |         825 |            0 |       0 |
| 0.2.8   |           0 |        0 |           0 |             0 |        1324 |            0 |       0 |
| 0.2.9   |           0 |        0 |           0 |             0 |         709 |            0 |       0 |
| 0.3.0   |           0 |        0 |           0 |             0 |         797 |            0 |       0 |
| 1.0.0   |         522 |        0 |           0 |          2991 |           0 |         2462 |       0 |
| 1.0.1   |        1380 |        0 |           0 |          9488 |           0 |         2278 |       0 |
| 1.0.2   |           0 |        0 |           0 |          1417 |           0 |         3592 |       0 |
| 1.0.3   |           0 |        0 |           0 |          2063 |           0 |          462 |       0 |
| 1.0.4   |           0 |        0 |           0 |             0 |           0 |         1786 |       0 |
| 1.1.0   |         558 |        0 |           0 |             0 |           0 |            0 |       0 |
| 1.2.0   |         644 |        0 |           0 |             0 |           0 |            0 |       0 |
| 1.2.1   |         460 |        0 |           0 |             0 |           0 |            0 |       0 |
| 1.2.2   |         685 |        0 |           0 |             0 |           0 |            0 |       0 |
| 1.2.3   |         707 |        0 |           0 |             0 |           0 |            0 |       0 |
| 1.2.4   |        2520 |        0 |           0 |             0 |           0 |            0 |       0 |
| 1.2.5   |        1898 |        0 |           0 |             0 |           0 |            0 |       0 |
| 1.2.6   |        1076 |        0 |           0 |             0 |           0 |            0 |       0 |
| 1.3.0   |         539 |        0 |           0 |             0 |           0 |            0 |       0 |

``` r
total_downloads %>%
  count(package) %>%
  tidyr::pivot_wider(
    names_from = package,
    values_from = n
  ) |>
  kable()
```

| TidyDensity | healthyR | healthyR.ai | healthyR.data | healthyR.ts | healthyverse | tidyAML |
|------------:|---------:|------------:|--------------:|------------:|-------------:|--------:|
|       12147 |    16390 |       12438 |         15959 |       18659 |        10580 |    3585 |

# Cumulative Downloads by Package

``` r
p1 <- plot_cumulative_downloads_pkg(total_downloads, pkg = "healthyR")
p2 <- plot_cumulative_downloads_pkg(total_downloads, pkg = "healthyR.ts")
p3 <- plot_cumulative_downloads_pkg(total_downloads, pkg = "healthyR.data")
p4 <- plot_cumulative_downloads_pkg(total_downloads, pkg = "healthyverse")
p5 <- plot_cumulative_downloads_pkg(total_downloads, pkg = "healthyR.ai")
p6 <- plot_cumulative_downloads_pkg(total_downloads, pkg = "TidyDensity")
p7 <- plot_cumulative_downloads_pkg(total_downloads, pkg = "tidyAML")

f <- function(date) format(date, "%b %d, %Y")
patchwork_theme <- theme_classic(base_size = 24) +
  theme(
    plot.title   = element_text(face = "bold"),
    plot.caption = element_text(size = 14)
  )
p1 + p2 + p3 + p4 + p5 + p6 + p7 +
  plot_annotation(
    title    = "healthyR packages are on the Rise",
    subtitle = "A Summary of Downloads from the RStudio CRAN Mirror - Since Inception",
    caption  = glue::glue("Source: RStudio CRAN Logs ({f(start_date)} to {f(end_date)})"),
    theme    = patchwork_theme
  )
```

![](man/figures/README-cum_pkg_dl-1.png)<!-- -->

# Thirty Day Run Post Release

``` r
pkg_rel <- readRDS("pkg_release_tbl.rds") |>
  arrange(date) |>
  group_by(package) |>
  mutate(rel_no = row_number()) |>
  ungroup()

thirty_day_runup_tbl <- total_downloads |>
  lazy_dt() |>
  select(date, package, version) |>
  group_by(date, package, version) |>
  summarise(dl_count = n()) |>
  ungroup() |>
  arrange(date) |>
  group_by(package, version) |>
  mutate(rec_no = row_number()) |>
  mutate(cum_dl = cumsum(dl_count)) |>
  filter(rec_no < 31) |>
  ungroup() |>
  mutate(pkg_ver = paste0(package, "-", version)) |>
  collect()

release_tbl <- left_join(
  x = thirty_day_runup_tbl,
  y = pkg_rel
) |>
  group_by(package) |>
  fill(release_record, .direction = "down") |>
  fill(rel_no, .direction = "down") |>
  mutate(
    release_record = as.factor(release_record),
    rel_no = as.factor(rel_no)
  ) |>
  ungroup()

latest_group_tbl <- release_tbl |>
  group_by(package) |> 
  arrange(date, rec_no) |>
  mutate(group_no = as.numeric(rel_no)) |> 
  filter(group_no == max(group_no)) |>
  ungroup()

joined_tbl <- left_join(
  x = thirty_day_runup_tbl,
  y = latest_group_tbl
) |>
  mutate(group_no = ifelse(is.na(group_no), FALSE, TRUE))

joined_tbl |>
  ggplot(aes(x = rec_no, y = dl_count, group = as.factor(pkg_ver))) +
  facet_wrap(~ package, scales = "free", ncol = 3) +
  geom_line(aes(col = group_no)) +
  scale_color_manual(values = c("FALSE" = "grey", "TRUE" = "red")) +
  theme_minimal() +
  labs(
    y = "Downloads",
    x = "Day After Version Release",
    col = "Latest Release"
  )
```

![](man/figures/README-thirty_day_post_release-1.png)<!-- -->

``` r
joined_tbl |>
  ggplot(aes(x = rec_no, y = cum_dl, group = as.factor(pkg_ver))) +
  facet_wrap(~ package, scales = "free", ncol = 3) +
  geom_line(aes(col = group_no)) +
  scale_color_manual(values = c("FALSE" = "grey", "TRUE" = "red")) +
  theme_minimal() +
  labs(
    y = "Downloads",
    x = "Day After Version Release",
    col = "Latest Release"
  )
```

![](man/figures/README-thirty_day_post_release-2.png)<!-- -->

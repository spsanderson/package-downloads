CRAN Downloads
================
Steven P. Sanderson II, MPH - Data Scientist/IT Manager
13 October, 2021

This repo contains the analysis of downloads of my `R` packages:

-   [`healthyR`](https://www.spsanderson.com/healthyR/)
-   [`healthyR.data`](https://www.spsanderson.com/healthyR.data/)
-   [`healthyR.ts`](https://www.spsanderson.com/healthyR.ts/)
-   [`healthyR.ai`](https://www.spsanderson.com/healthyR.ai/)
-   [`healthyverse`](https://www.spsanderson.com/healthyverse/)

All of which follow the [“analyses as
package”](https://rmflight.github.io/posts/2014/07/analyses_as_packages.html)
philosophy this repo itself is an `R` package that can installed using
`remotes::install_github()`.

I have forked this project itself from
[`ggcharts-analysis`](https://github.com/thomas-neitmann/ggcharts-downloads).

While I analyze `healthyverse` packages here, the functions are written
in a way that you can analyze any CRAN package with a slight
modification to the `download_log` function.

This file was last updated on October 13, 2021.

``` r
library(packagedownloads)
library(ggplot2)
library(patchwork)
library(dplyr)
library(timetk)
library(purrr)
library(knitr)
library(leaflet)
library(htmltools)
library(tmaptools)
library(mapview)
```

``` r
start_date      <- Sys.Date() - 9
end_date        <- Sys.Date() - 2
total_downloads <- download_logs(start_date, end_date)
interactive     <- FALSE
```

# Last Full Day Data

``` r
downloads            <- total_downloads %>% filter(date == max(date))
daily_downloads      <- compute_daily_downloads(downloads)
downloads_by_country <- compute_downloads_by_country(downloads)

p2 <- plot_cumulative_downloads(daily_downloads)
p4 <- plot_downloads_by_country(downloads_by_country)

f <- function(date) format(date, "%b %d, %Y")
patchwork_theme <- theme_classic(base_size = 24) +
  theme(
    plot.title = element_text(face = "bold"),
    plot.caption = element_text(size = 14)
  )
p2 + p4 +
  plot_annotation(
    title    = "healthyverse Packages - Last Full Day",
    subtitle = "A Summary of Downloads from the RStudio CRAN Mirror",
    caption  = glue::glue("Source: RStudio CRAN Logs for {f(end_date)}"),
    theme    = patchwork_theme
  )
```

![](man/figures/README-last_full_day-1.png)<!-- -->

``` r
downloads %>% 
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

| version | healthyR | healthyR.ai | healthyR.data | healthyR.ts | healthyverse |
|:--------|---------:|------------:|--------------:|------------:|-------------:|
| 0.0.2   |        0 |          16 |             0 |           0 |            0 |
| 0.1.3   |        0 |           0 |             0 |          17 |            0 |
| 0.1.6   |       16 |           0 |             0 |           0 |            0 |
| 1.0.1   |        0 |           0 |            24 |           0 |           17 |

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
    plot.title = element_text(face = "bold"),
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
    plot.title = element_text(face = "bold"),
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

# Map of Downloads

A `leaflet` map of countries where a package has been downloaded. The
markers will give the country name, display name and the download count.

``` r
mapping_dataset() %>%
  knitr::kable()
```

| country                 |    latitude |   longitude | display\_name                                                                                                                                                                                                                                                                                                                                                                                                                                     | icon                                                                                    |
|:------------------------|------------:|------------:|:--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|:----------------------------------------------------------------------------------------|
| United States           |  39.7837304 | -100.445882 | United States                                                                                                                                                                                                                                                                                                                                                                                                                                     | <https://nominatim.openstreetmap.org/ui/mapicons//poi_boundary_administrative.p.20.png> |
| United Kingdom          |  54.7023545 |   -3.276575 | United Kingdom                                                                                                                                                                                                                                                                                                                                                                                                                                    | <https://nominatim.openstreetmap.org/ui/mapicons//poi_boundary_administrative.p.20.png> |
| Germany                 |  51.0834196 |   10.423447 | Deutschland                                                                                                                                                                                                                                                                                                                                                                                                                                       | <https://nominatim.openstreetmap.org/ui/mapicons//poi_boundary_administrative.p.20.png> |
| Hong Kong SAR China     |  22.3506270 |  114.184916 | &lt;U+9999&gt;&lt;U+6E2F&gt; Hong Kong, &lt;U+4E2D&gt;&lt;U+56FD&gt;                                                                                                                                                                                                                                                                                                                                                                              | <https://nominatim.openstreetmap.org/ui/mapicons//poi_boundary_administrative.p.20.png> |
| Japan                   |  36.5748441 |  139.239418 | &lt;U+65E5&gt;&lt;U+672C&gt;                                                                                                                                                                                                                                                                                                                                                                                                                      | <https://nominatim.openstreetmap.org/ui/mapicons//poi_boundary_administrative.p.20.png> |
| Chile                   | -31.7613365 |  -71.318770 | Chile                                                                                                                                                                                                                                                                                                                                                                                                                                             | <https://nominatim.openstreetmap.org/ui/mapicons//poi_boundary_administrative.p.20.png> |
| Indonesia               |  -2.4833826 |  117.890285 | Indonesia                                                                                                                                                                                                                                                                                                                                                                                                                                         | <https://nominatim.openstreetmap.org/ui/mapicons//poi_boundary_administrative.p.20.png> |
| Canada                  |  61.0666922 | -107.991707 | Canada                                                                                                                                                                                                                                                                                                                                                                                                                                            | <https://nominatim.openstreetmap.org/ui/mapicons//poi_boundary_administrative.p.20.png> |
| Belarus                 |  53.4250605 |   27.697136 | &lt;U+0411&gt;&lt;U+0435&gt;&lt;U+043B&gt;&lt;U+0430&gt;&lt;U+0440&gt;&lt;U+0443&gt;&lt;U+0441&gt;&lt;U+044C&gt;                                                                                                                                                                                                                                                                                                                                  | <https://nominatim.openstreetmap.org/ui/mapicons//poi_boundary_administrative.p.20.png> |
| South Korea             |  36.6383920 |  127.696119 | &lt;U+B300&gt;&lt;U+D55C&gt;&lt;U+BBFC&gt;&lt;U+AD6D&gt;                                                                                                                                                                                                                                                                                                                                                                                          | <https://nominatim.openstreetmap.org/ui/mapicons//poi_boundary_administrative.p.20.png> |
| Iran                    |  32.6475314 |   54.564352 | &lt;U+0627&gt;&lt;U+06CC&gt;&lt;U+0631&gt;&lt;U+0627&gt;&lt;U+0646&gt;                                                                                                                                                                                                                                                                                                                                                                            | <https://nominatim.openstreetmap.org/ui/mapicons//poi_boundary_administrative.p.20.png> |
| Colombia                |   4.0999170 |  -72.908813 | Colombia                                                                                                                                                                                                                                                                                                                                                                                                                                          | <https://nominatim.openstreetmap.org/ui/mapicons//poi_boundary_administrative.p.20.png> |
| China                   |  35.0000740 |  104.999927 | &lt;U+4E2D&gt;&lt;U+56FD&gt;                                                                                                                                                                                                                                                                                                                                                                                                                      | <https://nominatim.openstreetmap.org/ui/mapicons//poi_boundary_administrative.p.20.png> |
| Brazil                  | -10.3333333 |  -53.200000 | Brasil                                                                                                                                                                                                                                                                                                                                                                                                                                            | <https://nominatim.openstreetmap.org/ui/mapicons//poi_boundary_administrative.p.20.png> |
| Italy                   |  42.6384261 |   12.674297 | Italia                                                                                                                                                                                                                                                                                                                                                                                                                                            | <https://nominatim.openstreetmap.org/ui/mapicons//poi_boundary_administrative.p.20.png> |
| Turkey                  |  38.9597594 |   34.924965 | Türkiye                                                                                                                                                                                                                                                                                                                                                                                                                                           | <https://nominatim.openstreetmap.org/ui/mapicons//poi_boundary_administrative.p.20.png> |
| Spain                   |  39.3260685 |   -4.837979 | España                                                                                                                                                                                                                                                                                                                                                                                                                                            | <https://nominatim.openstreetmap.org/ui/mapicons//poi_boundary_administrative.p.20.png> |
| Switzerland             |  46.7985624 |    8.231974 | Schweiz/Suisse/Svizzera/Svizra                                                                                                                                                                                                                                                                                                                                                                                                                    | <https://nominatim.openstreetmap.org/ui/mapicons//poi_boundary_administrative.p.20.png> |
| France                  |  46.6033540 |    1.888334 | France                                                                                                                                                                                                                                                                                                                                                                                                                                            | <https://nominatim.openstreetmap.org/ui/mapicons//poi_boundary_administrative.p.20.png> |
| Pakistan                |  30.3308401 |   71.247499 | &lt;U+067E&gt;&lt;U+0627&gt;&lt;U+06A9&gt;&lt;U+0633&gt;&lt;U+062A&gt;&lt;U+0627&gt;&lt;U+0646&gt;                                                                                                                                                                                                                                                                                                                                                | <https://nominatim.openstreetmap.org/ui/mapicons//poi_boundary_administrative.p.20.png> |
| United Arab Emirates    |  24.0002488 |   53.999483 | &lt;U+0627&gt;&lt;U+0644&gt;&lt;U+0625&gt;&lt;U+0645&gt;&lt;U+0627&gt;&lt;U+0631&gt;&lt;U+0627&gt;&lt;U+062A&gt; &lt;U+0627&gt;&lt;U+0644&gt;&lt;U+0639&gt;&lt;U+0631&gt;&lt;U+0628&gt;&lt;U+064A&gt;&lt;U+0629&gt; &lt;U+0627&gt;&lt;U+0644&gt;&lt;U+0645&gt;&lt;U+062A&gt;&lt;U+062D&gt;&lt;U+062F&gt;&lt;U+0629&gt;                                                                                                                            | <https://nominatim.openstreetmap.org/ui/mapicons//poi_boundary_administrative.p.20.png> |
| Kenya                   |   1.4419683 |   38.431398 | Kenya                                                                                                                                                                                                                                                                                                                                                                                                                                             | <https://nominatim.openstreetmap.org/ui/mapicons//poi_boundary_administrative.p.20.png> |
| Iraq                    |  33.0955793 |   44.174977 | &lt;U+0627&gt;&lt;U+0644&gt;&lt;U+0639&gt;&lt;U+0631&gt;&lt;U+0627&gt;&lt;U+0642&gt;                                                                                                                                                                                                                                                                                                                                                              | <https://nominatim.openstreetmap.org/ui/mapicons//poi_boundary_administrative.p.20.png> |
| Hungary                 |  47.1817585 |   19.506094 | Magyarország                                                                                                                                                                                                                                                                                                                                                                                                                                      | <https://nominatim.openstreetmap.org/ui/mapicons//poi_boundary_administrative.p.20.png> |
| Romania                 |  45.9852129 |   24.685923 | România                                                                                                                                                                                                                                                                                                                                                                                                                                           | <https://nominatim.openstreetmap.org/ui/mapicons//poi_boundary_administrative.p.20.png> |
| Honduras                |  15.2572432 |  -86.075514 | Honduras                                                                                                                                                                                                                                                                                                                                                                                                                                          | <https://nominatim.openstreetmap.org/ui/mapicons//poi_boundary_administrative.p.20.png> |
| Belgium                 |  50.6402809 |    4.666715 | België / Belgique / Belgien                                                                                                                                                                                                                                                                                                                                                                                                                       | <https://nominatim.openstreetmap.org/ui/mapicons//poi_boundary_administrative.p.20.png> |
| India                   |  22.3511148 |   78.667743 | India                                                                                                                                                                                                                                                                                                                                                                                                                                             | <https://nominatim.openstreetmap.org/ui/mapicons//poi_boundary_administrative.p.20.png> |
| Russia                  |  64.6863136 |   97.745306 | &lt;U+0420&gt;&lt;U+043E&gt;&lt;U+0441&gt;&lt;U+0441&gt;&lt;U+0438&gt;&lt;U+044F&gt;                                                                                                                                                                                                                                                                                                                                                              | <https://nominatim.openstreetmap.org/ui/mapicons//poi_boundary_administrative.p.20.png> |
| Netherlands             |  52.5001698 |    5.748082 | Nederland                                                                                                                                                                                                                                                                                                                                                                                                                                         | <https://nominatim.openstreetmap.org/ui/mapicons//poi_boundary_administrative.p.20.png> |
| Taiwan                  |  23.9739374 |  120.982018 | &lt;U+81FA&gt;&lt;U+7063&gt;                                                                                                                                                                                                                                                                                                                                                                                                                      | <https://nominatim.openstreetmap.org/ui/mapicons//poi_boundary_administrative.p.20.png> |
| South Africa            | -28.8166236 |   24.991639 | South Africa                                                                                                                                                                                                                                                                                                                                                                                                                                      | <https://nominatim.openstreetmap.org/ui/mapicons//poi_boundary_administrative.p.20.png> |
| Sweden                  |  59.6749712 |   14.520858 | Sverige                                                                                                                                                                                                                                                                                                                                                                                                                                           | <https://nominatim.openstreetmap.org/ui/mapicons//poi_boundary_administrative.p.20.png> |
| Ghana                   |   8.0300284 |   -1.080027 | Ghana                                                                                                                                                                                                                                                                                                                                                                                                                                             | <https://nominatim.openstreetmap.org/ui/mapicons//poi_boundary_administrative.p.20.png> |
| Croatia                 |  45.5643442 |   17.011895 | Hrvatska                                                                                                                                                                                                                                                                                                                                                                                                                                          | <https://nominatim.openstreetmap.org/ui/mapicons//poi_boundary_administrative.p.20.png> |
| Poland                  |  52.2159330 |   19.134422 | Polska                                                                                                                                                                                                                                                                                                                                                                                                                                            | <https://nominatim.openstreetmap.org/ui/mapicons//poi_boundary_administrative.p.20.png> |
| Jordan                  |  31.1667049 |   36.941628 | &lt;U+0627&gt;&lt;U+0644&gt;&lt;U+0623&gt;&lt;U+0631&gt;&lt;U+062F&gt;&lt;U+0646&gt;                                                                                                                                                                                                                                                                                                                                                              | <https://nominatim.openstreetmap.org/ui/mapicons//poi_boundary_administrative.p.20.png> |
| Finland                 |  63.2467777 |   25.920916 | Suomi / Finland                                                                                                                                                                                                                                                                                                                                                                                                                                   | <https://nominatim.openstreetmap.org/ui/mapicons//poi_boundary_administrative.p.20.png> |
| Peru                    |  -6.8699697 |  -75.045851 | Perú                                                                                                                                                                                                                                                                                                                                                                                                                                              | <https://nominatim.openstreetmap.org/ui/mapicons//poi_boundary_administrative.p.20.png> |
| Morocco                 |  31.1728205 |   -7.336248 | Maroc / &lt;U+2D4D&gt;&lt;U+2D4E&gt;&lt;U+2D56&gt;&lt;U+2D54&gt;&lt;U+2D49&gt;&lt;U+2D31&gt; / &lt;U+0627&gt;&lt;U+0644&gt;&lt;U+0645&gt;&lt;U+063A&gt;&lt;U+0631&gt;&lt;U+0628&gt;                                                                                                                                                                                                                                                               | <https://nominatim.openstreetmap.org/ui/mapicons//poi_boundary_administrative.p.20.png> |
| Israel                  |  31.5313113 |   34.866765 | &lt;U+05D9&gt;&lt;U+05E9&gt;&lt;U+05E8&gt;&lt;U+05D0&gt;&lt;U+05DC&gt;                                                                                                                                                                                                                                                                                                                                                                            | <https://nominatim.openstreetmap.org/ui/mapicons//poi_boundary_administrative.p.20.png> |
| Austria                 |  47.2000000 |   13.200000 | Österreich                                                                                                                                                                                                                                                                                                                                                                                                                                        | <https://nominatim.openstreetmap.org/ui/mapicons//poi_boundary_administrative.p.20.png> |
| Portugal                |  40.0332629 |   -7.889626 | Portugal                                                                                                                                                                                                                                                                                                                                                                                                                                          | <https://nominatim.openstreetmap.org/ui/mapicons//poi_boundary_administrative.p.20.png> |
| Vietnam                 |  13.2904027 |  108.426511 | Vi&lt;U+1EC7&gt;t Nam                                                                                                                                                                                                                                                                                                                                                                                                                             | <https://nominatim.openstreetmap.org/ui/mapicons//poi_boundary_administrative.p.20.png> |
| Palestinian Territories |  31.9469666 |   35.273865 | &lt;U+0627&gt;&lt;U+0644&gt;&lt;U+0623&gt;&lt;U+0631&gt;&lt;U+0627&gt;&lt;U+0636&gt;&lt;U+064A&gt; &lt;U+0627&gt;&lt;U+0644&gt;&lt;U+0641&gt;&lt;U+0644&gt;&lt;U+0633&gt;&lt;U+0637&gt;&lt;U+064A&gt;&lt;U+0646&gt;&lt;U+064A&gt;&lt;U+0629&gt;, &lt;U+0627&gt;&lt;U+0644&gt;&lt;U+0636&gt;&lt;U+0641&gt;&lt;U+0629&gt; &lt;U+0627&gt;&lt;U+0644&gt;&lt;U+063A&gt;&lt;U+0631&gt;&lt;U+0628&gt;&lt;U+064A&gt;&lt;U+0629&gt;, Palestinian Territory | NA                                                                                      |
| Cyprus                  |  34.9823018 |   33.145128 | &lt;U+039A&gt;&lt;U+03CD&gt;p&lt;U+03C1&gt;&lt;U+03BF&gt;&lt;U+03C2&gt; - Kibris                                                                                                                                                                                                                                                                                                                                                                  | <https://nominatim.openstreetmap.org/ui/mapicons//poi_boundary_administrative.p.20.png> |
| New Zealand             | -41.5000831 |  172.834408 | New Zealand / Aotearoa                                                                                                                                                                                                                                                                                                                                                                                                                            | <https://nominatim.openstreetmap.org/ui/mapicons//poi_boundary_administrative.p.20.png> |
| Australia               | -24.7761086 |  134.755000 | Australia                                                                                                                                                                                                                                                                                                                                                                                                                                         | <https://nominatim.openstreetmap.org/ui/mapicons//poi_boundary_administrative.p.20.png> |
| Czechia                 |  49.8167003 |   15.474954 | Cesko                                                                                                                                                                                                                                                                                                                                                                                                                                             | <https://nominatim.openstreetmap.org/ui/mapicons//poi_boundary_administrative.p.20.png> |
| Zambia                  | -14.5189121 |   27.558988 | Zambia                                                                                                                                                                                                                                                                                                                                                                                                                                            | <https://nominatim.openstreetmap.org/ui/mapicons//poi_boundary_administrative.p.20.png> |
| Costa Rica              |  10.2735633 |  -84.073910 | Costa Rica                                                                                                                                                                                                                                                                                                                                                                                                                                        | <https://nominatim.openstreetmap.org/ui/mapicons//poi_boundary_administrative.p.20.png> |
| Norway                  |  60.5000209 |    9.099972 | Norge                                                                                                                                                                                                                                                                                                                                                                                                                                             | <https://nominatim.openstreetmap.org/ui/mapicons//poi_boundary_administrative.p.20.png> |
| Thailand                |  14.8971921 |  100.832730 | &lt;U+0E1B&gt;&lt;U+0E23&gt;&lt;U+0E30&gt;&lt;U+0E40&gt;&lt;U+0E17&gt;&lt;U+0E28&gt;&lt;U+0E44&gt;&lt;U+0E17&gt;&lt;U+0E22&gt;                                                                                                                                                                                                                                                                                                                    | <https://nominatim.openstreetmap.org/ui/mapicons//poi_boundary_administrative.p.20.png> |
| Panama                  |   8.5595590 |  -81.130843 | Panamá                                                                                                                                                                                                                                                                                                                                                                                                                                            | <https://nominatim.openstreetmap.org/ui/mapicons//poi_boundary_administrative.p.20.png> |
| Slovakia                |  48.7411522 |   19.452865 | Slovensko                                                                                                                                                                                                                                                                                                                                                                                                                                         | <https://nominatim.openstreetmap.org/ui/mapicons//poi_boundary_administrative.p.20.png> |
| Denmark                 |  55.6702490 |   10.333328 | Danmark                                                                                                                                                                                                                                                                                                                                                                                                                                           | <https://nominatim.openstreetmap.org/ui/mapicons//poi_boundary_administrative.p.20.png> |
| Singapore               |   1.3571070 |  103.819499 | Singapore                                                                                                                                                                                                                                                                                                                                                                                                                                         | <https://nominatim.openstreetmap.org/ui/mapicons//poi_boundary_administrative.p.20.png> |
| Ethiopia                |  10.2116702 |   38.652120 | &lt;U+12A2&gt;&lt;U+1275&gt;&lt;U+12EE&gt;&lt;U+1335&gt;&lt;U+12EB&gt;                                                                                                                                                                                                                                                                                                                                                                            | <https://nominatim.openstreetmap.org/ui/mapicons//poi_boundary_administrative.p.20.png> |
| Trinidad & Tobago       |  10.4430243 |  -61.261305 | Trinidad, Couva-Tabaquite-Talparo, Trinidad and Tobago                                                                                                                                                                                                                                                                                                                                                                                            | NA                                                                                      |
| Ukraine                 |  49.4871968 |   31.271832 | &lt;U+0423&gt;&lt;U+043A&gt;&lt;U+0440&gt;&lt;U+0430&gt;&lt;U+0457&gt;&lt;U+043D&gt;&lt;U+0430&gt;                                                                                                                                                                                                                                                                                                                                                | <https://nominatim.openstreetmap.org/ui/mapicons//poi_boundary_administrative.p.20.png> |
| Slovenia                |  46.1490345 |   14.626326 | Slovenija                                                                                                                                                                                                                                                                                                                                                                                                                                         | <https://nominatim.openstreetmap.org/ui/mapicons//poi_boundary_administrative.p.20.png> |
| Uganda                  |   1.5333554 |   32.216658 | Uganda                                                                                                                                                                                                                                                                                                                                                                                                                                            | <https://nominatim.openstreetmap.org/ui/mapicons//poi_boundary_administrative.p.20.png> |
| Mongolia                |  46.8250388 |  103.849974 | &lt;U+041C&gt;&lt;U+043E&gt;&lt;U+043D&gt;&lt;U+0433&gt;&lt;U+043E&gt;&lt;U+043B&gt; &lt;U+0443&gt;&lt;U+043B&gt;&lt;U+0441&gt; &lt;U+182E&gt;&lt;U+1824&gt;&lt;U+1829&gt;&lt;U+182D&gt;&lt;U+1824&gt;&lt;U+182F&gt; &lt;U+1824&gt;&lt;U+182F&gt;&lt;U+1824&gt;&lt;U+1830&gt;                                                                                                                                                                     | <https://nominatim.openstreetmap.org/ui/mapicons//poi_boundary_administrative.p.20.png> |
| Yemen                   |  16.3471243 |   47.891527 | &lt;U+0627&gt;&lt;U+0644&gt;&lt;U+064A&gt;&lt;U+0645&gt;&lt;U+0646&gt;                                                                                                                                                                                                                                                                                                                                                                            | <https://nominatim.openstreetmap.org/ui/mapicons//poi_boundary_administrative.p.20.png> |
| Malta                   |  35.8885993 |   14.447691 | Malta                                                                                                                                                                                                                                                                                                                                                                                                                                             | <https://nominatim.openstreetmap.org/ui/mapicons//poi_boundary_administrative.p.20.png> |
| Mexico                  |  22.5000485 | -100.000037 | México                                                                                                                                                                                                                                                                                                                                                                                                                                            | <https://nominatim.openstreetmap.org/ui/mapicons//poi_boundary_administrative.p.20.png> |
| Nauru                   |  -0.5252306 |  166.932443 | Naoero                                                                                                                                                                                                                                                                                                                                                                                                                                            | <https://nominatim.openstreetmap.org/ui/mapicons//poi_boundary_administrative.p.20.png> |
| Côte d’Ivoire           |   7.9897371 |   -5.567946 | Côte d’Ivoire                                                                                                                                                                                                                                                                                                                                                                                                                                     | <https://nominatim.openstreetmap.org/ui/mapicons//poi_boundary_administrative.p.20.png> |
| Guadeloupe              |  16.2305103 |  -61.687126 | Guadeloupe, France                                                                                                                                                                                                                                                                                                                                                                                                                                | <https://nominatim.openstreetmap.org/ui/mapicons//poi_boundary_administrative.p.20.png> |
| Philippines             |  12.7503486 |  122.731210 | Philippines                                                                                                                                                                                                                                                                                                                                                                                                                                       | <https://nominatim.openstreetmap.org/ui/mapicons//poi_boundary_administrative.p.20.png> |
| Venezuela               |   8.0018709 |  -66.110932 | Venezuela                                                                                                                                                                                                                                                                                                                                                                                                                                         | <https://nominatim.openstreetmap.org/ui/mapicons//poi_boundary_administrative.p.20.png> |
| Argentina               | -34.9964963 |  -64.967282 | Argentina                                                                                                                                                                                                                                                                                                                                                                                                                                         | <https://nominatim.openstreetmap.org/ui/mapicons//poi_boundary_administrative.p.20.png> |
| Luxembourg              |  49.8158683 |    6.129675 | Lëtzebuerg                                                                                                                                                                                                                                                                                                                                                                                                                                        | <https://nominatim.openstreetmap.org/ui/mapicons//poi_boundary_administrative.p.20.png> |
| Ireland                 |  52.8651960 |   -7.979460 | Éire / Ireland                                                                                                                                                                                                                                                                                                                                                                                                                                    | <https://nominatim.openstreetmap.org/ui/mapicons//poi_boundary_administrative.p.20.png> |
| Zimbabwe                | -18.4554963 |   29.746841 | Zimbabwe                                                                                                                                                                                                                                                                                                                                                                                                                                          | <https://nominatim.openstreetmap.org/ui/mapicons//poi_boundary_administrative.p.20.png> |
| Tunisia                 |  33.8439408 |    9.400138 | &lt;U+062A&gt;&lt;U+0648&gt;&lt;U+0646&gt;&lt;U+0633&gt;                                                                                                                                                                                                                                                                                                                                                                                          | <https://nominatim.openstreetmap.org/ui/mapicons//poi_boundary_administrative.p.20.png> |
| Serbia                  |  44.1534121 |   20.551440 | &lt;U+0421&gt;&lt;U+0440&gt;&lt;U+0431&gt;&lt;U+0438&gt;&lt;U+0458&gt;&lt;U+0430&gt;                                                                                                                                                                                                                                                                                                                                                              | <https://nominatim.openstreetmap.org/ui/mapicons//poi_boundary_administrative.p.20.png> |
| Greece                  |  38.9953683 |   21.987713 | &lt;U+0395&gt;&lt;U+03BB&gt;&lt;U+03BB&gt;&lt;U+03AC&gt;&lt;U+03C2&gt;                                                                                                                                                                                                                                                                                                                                                                            | <https://nominatim.openstreetmap.org/ui/mapicons//poi_boundary_administrative.p.20.png> |
| Belize                  |  16.8259793 |  -88.760093 | Belize                                                                                                                                                                                                                                                                                                                                                                                                                                            | <https://nominatim.openstreetmap.org/ui/mapicons//poi_boundary_administrative.p.20.png> |
| Saudi Arabia            |  25.6242618 |   42.352833 | &lt;U+0627&gt;&lt;U+0644&gt;&lt;U+0633&gt;&lt;U+0639&gt;&lt;U+0648&gt;&lt;U+062F&gt;&lt;U+064A&gt;&lt;U+0629&gt;                                                                                                                                                                                                                                                                                                                                  | <https://nominatim.openstreetmap.org/ui/mapicons//poi_boundary_administrative.p.20.png> |
| Malaysia                |   4.5693754 |  102.265682 | Malaysia                                                                                                                                                                                                                                                                                                                                                                                                                                          | <https://nominatim.openstreetmap.org/ui/mapicons//poi_boundary_administrative.p.20.png> |
| Ecuador                 |  -1.3397668 |  -79.366697 | Ecuador                                                                                                                                                                                                                                                                                                                                                                                                                                           | <https://nominatim.openstreetmap.org/ui/mapicons//poi_boundary_administrative.p.20.png> |
| Bahrain                 |  26.1551249 |   50.534461 | &lt;U+0627&gt;&lt;U+0644&gt;&lt;U+0628&gt;&lt;U+062D&gt;&lt;U+0631&gt;&lt;U+064A&gt;&lt;U+0646&gt;                                                                                                                                                                                                                                                                                                                                                | <https://nominatim.openstreetmap.org/ui/mapicons//poi_boundary_administrative.p.20.png> |
| Paraguay                | -23.3165935 |  -58.169345 | Paraguay                                                                                                                                                                                                                                                                                                                                                                                                                                          | <https://nominatim.openstreetmap.org/ui/mapicons//poi_boundary_administrative.p.20.png> |
| Egypt                   |  26.2540493 |   29.267547 | &lt;U+0645&gt;&lt;U+0635&gt;&lt;U+0631&gt;                                                                                                                                                                                                                                                                                                                                                                                                        | <https://nominatim.openstreetmap.org/ui/mapicons//poi_boundary_administrative.p.20.png> |
| Mauritius               | -20.2759451 |   57.570357 | Mauritius                                                                                                                                                                                                                                                                                                                                                                                                                                         | <https://nominatim.openstreetmap.org/ui/mapicons//poi_boundary_administrative.p.20.png> |
| Senegal                 |  14.4750607 |  -14.452961 | Sénégal                                                                                                                                                                                                                                                                                                                                                                                                                                           | <https://nominatim.openstreetmap.org/ui/mapicons//poi_boundary_administrative.p.20.png> |
| Latvia                  |  56.8406494 |   24.753764 | Latvija                                                                                                                                                                                                                                                                                                                                                                                                                                           | <https://nominatim.openstreetmap.org/ui/mapicons//poi_boundary_administrative.p.20.png> |
| Albania                 |  41.0000280 |   19.999962 | Shqipëria                                                                                                                                                                                                                                                                                                                                                                                                                                         | <https://nominatim.openstreetmap.org/ui/mapicons//poi_boundary_administrative.p.20.png> |
| Bahamas                 |  24.7736546 |  -78.000055 | The Bahamas                                                                                                                                                                                                                                                                                                                                                                                                                                       | <https://nominatim.openstreetmap.org/ui/mapicons//poi_boundary_administrative.p.20.png> |
| Qatar                   |  25.3336984 |   51.229529 | &lt;U+0642&gt;&lt;U+0637&gt;&lt;U+0631&gt;                                                                                                                                                                                                                                                                                                                                                                                                        | <https://nominatim.openstreetmap.org/ui/mapicons//poi_boundary_administrative.p.20.png> |
| North Macedonia         |  41.6171214 |   21.716839 | &lt;U+0421&gt;&lt;U+0435&gt;&lt;U+0432&gt;&lt;U+0435&gt;&lt;U+0440&gt;&lt;U+043D&gt;&lt;U+0430&gt; &lt;U+041C&gt;&lt;U+0430&gt;&lt;U+043A&gt;&lt;U+0435&gt;&lt;U+0434&gt;&lt;U+043E&gt;&lt;U+043D&gt;&lt;U+0438&gt;&lt;U+0458&gt;&lt;U+0430&gt;                                                                                                                                                                                                   | <https://nominatim.openstreetmap.org/ui/mapicons//poi_boundary_administrative.p.20.png> |
| Lithuania               |  55.3500003 |   23.750000 | Lietuva                                                                                                                                                                                                                                                                                                                                                                                                                                           | <https://nominatim.openstreetmap.org/ui/mapicons//poi_boundary_administrative.p.20.png> |

``` r
l <- map_leaflet()
mapshot(x = l, file = "map.png")
```

![map of downloads](map.png)

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
    plot.title = element_text(face = "bold"),
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
    plot.title = element_text(face = "bold"),
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
    plot.title = element_text(face = "bold"),
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
    plot.title = element_text(face = "bold"),
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
    plot.title = element_text(face = "bold"),
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

# Some table data

``` r
top_n_downloads(total_downloads, 4, r_os) %>%
  set_names("OS", "Count") %>%
  kable()
```

| OS           | Count |
|:-------------|------:|
| darwin17.0   |   301 |
| darwin15.6.0 |    39 |
| darwin13.4.0 |    23 |
| darwin18.7.0 |     5 |

``` r
top_n_downloads(total_downloads, 4, r_version) %>%
  set_names("Version","Count") %>%
  kable()
```

| Version | Count |
|:--------|------:|
| 3.2.3   |    14 |
| 3.2.5   |     9 |
| 3.2.2   |     4 |
| 3.2.1   |     2 |

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

| version | healthyR | healthyR.ai | healthyR.data | healthyR.ts | healthyverse |
|:--------|---------:|------------:|--------------:|------------:|-------------:|
| 0.0.1   |        0 |         249 |             0 |           0 |            0 |
| 0.0.2   |        0 |         529 |             0 |           0 |            0 |
| 0.1.0   |      143 |           0 |             0 |         364 |            0 |
| 0.1.1   |     1190 |           0 |             0 |        1842 |            0 |
| 0.1.2   |     1363 |           0 |             0 |         885 |            0 |
| 0.1.3   |      210 |           0 |             0 |         663 |            0 |
| 0.1.4   |      258 |           0 |             0 |           0 |            0 |
| 0.1.5   |      909 |           0 |             0 |           0 |            0 |
| 0.1.6   |      712 |           0 |             0 |           0 |            0 |
| 1.0.0   |        0 |           0 |          2764 |           0 |         2174 |
| 1.0.1   |        0 |           0 |          3029 |           0 |          630 |

# Cumulative Downloads by Package

``` r
p1 <- plot_cumulative_downloads_pkg(total_downloads, pkg = "healthyR")
p2 <- plot_cumulative_downloads_pkg(total_downloads, pkg = "healthyR.ts")
p3 <- plot_cumulative_downloads_pkg(total_downloads, pkg = "healthyR.data")
p4 <- plot_cumulative_downloads_pkg(total_downloads, pkg = "healthyverse")
p5 <- plot_cumulative_downloads_pkg(total_downloads, pkg = "healthyR.ai")

f <- function(date) format(date, "%b %d, %Y")
patchwork_theme <- theme_classic(base_size = 24) +
  theme(
    plot.title = element_text(face = "bold"),
    plot.caption = element_text(size = 14)
  )
p1 + p2 + p3 + p4 + p5 +
  plot_annotation(
    title    = "healthyR packages are on the Rise",
    subtitle = "A Summary of Downloads from the RStudio CRAN Mirror - Since Inception",
    caption  = glue::glue("Source: RStudio CRAN Logs ({f(start_date)} to {f(end_date)})"),
    theme    = patchwork_theme
  )
```

![](man/figures/README-cum_pkg_dl-1.png)<!-- -->

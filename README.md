CRAN Downloads
================
Steven P. Sanderson II, MPH - Data Scientist/IT Manager
12 October, 2021

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

This file was last updated on October 12, 2021.

``` r
library(packagedownloads)
library(ggplot2)
library(patchwork)
library(dplyr)
library(timetk)
library(purrr)
library(knitr)
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
| 0.0.2   |        0 |           5 |             0 |           0 |            0 |
| 0.1.3   |        0 |           0 |             0 |           2 |            0 |
| 0.1.6   |        2 |           0 |             0 |           0 |            0 |
| 1.0.1   |        0 |           0 |             3 |           0 |            2 |

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
mapping_dataset()
```

    ## # A tibble: 93 x 5
    ##    country             latitude longitude display_name         icon             
    ##    <chr>                  <dbl>     <dbl> <chr>                <chr>            
    ##  1 United States          39.8    -100.   United States        https://nominati~
    ##  2 United Kingdom         54.7      -3.28 United Kingdom       https://nominati~
    ##  3 Germany                51.1      10.4  Deutschland          https://nominati~
    ##  4 Hong Kong SAR China    22.4     114.   <U+9999><U+6E2F> Hong Kong, <U+4E2D><U+56FD> https://nominati~
    ##  5 Japan                  36.6     139.   <U+65E5><U+672C>                 https://nominati~
    ##  6 Chile                 -31.8     -71.3  Chile                https://nominati~
    ##  7 Indonesia              -2.48    118.   Indonesia            https://nominati~
    ##  8 Canada                 61.1    -108.   Canada               https://nominati~
    ##  9 Belarus                53.4      27.7  <U+0411><U+0435><U+043B><U+0430><U+0440><U+0443><U+0441><U+044C>             https://nominati~
    ## 10 South Korea            36.6     128.   <U+B300><U+D55C><U+BBFC><U+AD6D>             https://nominati~
    ## # ... with 83 more rows

``` r
map_leaflet()
```

<div id="htmlwidget-c76cad0e3c53df1410a9" style="width:1152px;height:960px;" class="leaflet html-widget"></div>
<script type="application/json" data-for="htmlwidget-c76cad0e3c53df1410a9">{"x":{"options":{"crs":{"crsClass":"L.CRS.EPSG3857","code":null,"proj4def":null,"projectedBounds":null,"options":{}}},"calls":[{"method":"addTiles","args":["//{s}.tile.openstreetmap.org/{z}/{x}/{y}.png",null,null,{"minZoom":0,"maxZoom":18,"tileSize":256,"subdomains":"abc","errorTileUrl":"","tms":false,"noWrap":false,"zoomOffset":0,"zoomReverse":false,"opacity":1,"zIndex":1,"detectRetina":false,"attribution":"&copy; <a href=\"http://openstreetmap.org\">OpenStreetMap<\/a> contributors, <a href=\"http://creativecommons.org/licenses/by-sa/2.0/\">CC-BY-SA<\/a>"}]},{"method":"addMarkers","args":[[39.7837304,54.7023545,51.0834196,22.350627,36.5748441,-31.7613365,-2.4833826,61.0666922,53.4250605,36.638392,32.6475314,4.099917,35.000074,-10.3333333,42.6384261,38.9597594,39.3260685,46.7985624,46.603354,30.3308401,24.0002488,1.4419683,33.0955793,47.1817585,45.9852129,15.2572432,50.6402809,22.3511148,64.6863136,52.5001698,23.9739374,-28.8166236,59.6749712,8.0300284,45.5643442,52.215933,31.1667049,63.2467777,-6.8699697,31.1728205,31.5313113,47.2,40.0332629,13.2904027,31.94696655,34.9823018,-41.5000831,-24.7761086,49.8167003,-14.5189121,10.2735633,60.5000209,14.8971921,8.559559,48.7411522,55.670249,1.357107,10.2116702,10.4430243,49.4871968,46.14903455,1.5333554,46.8250388,16.3471243,35.8885993,22.5000485,-0.5252306,7.9897371,16.23051025,12.7503486,8.0018709,-34.9964963,49.8158683,52.865196,-18.4554963,33.8439408,44.1534121,38.9953683,16.8259793,25.6242618,4.5693754,-1.3397668,26.1551249,-23.3165935,26.2540493,-20.2759451,14.4750607,56.8406494,41.000028,24.7736546,25.3336984,41.6171214,55.3500003],[-100.445882,-3.2765753,10.4234469,114.1849161,139.2394179,-71.3187697,117.8902853,-107.991707,27.6971358,127.6961188,54.5643516,-72.9088133,104.999927,-53.2,12.674297,34.9249653,-4.8379791,8.2319736,1.8883335,71.247499,53.9994829,38.4313975,44.1749775,19.5060937,24.6859225,-86.0755145,4.6667145,78.6677428,97.7453061,5.7480821,120.9820179,24.991639,14.5208584,-1.0800271,17.0118954,19.134422,36.941628,25.9209164,-75.0458515,-7.3362482,34.8667654,13.2,-7.8896263,108.4265113,35.273865472915,33.1451285,172.8344077,134.755,15.4749544,27.5589884,-84.0739102,9.0999715,100.83273,-81.1308434,19.4528646,10.3333283,103.8194992,38.6521203,-61.2613053887806,31.2718321,14.6263257533406,32.2166578,103.8499736,47.8915271,14.4476911,-100.000037,166.9324426,-5.5679458,-61.6871260213885,122.7312101,-66.1109318,-64.9672817,6.1296751,-7.9794599,29.7468414,9.400138,20.55144,21.9877132,-88.7600927,42.3528328,102.2656823,-79.3666965,50.5344606,-58.1693445,29.2675469,57.5703566,-14.4529612,24.7537645,19.9999619,-78.0000547,51.2295295,21.7168387,23.7499997],null,null,null,{"interactive":true,"draggable":false,"keyboard":true,"title":"","alt":"","zIndexOffset":0,"opacity":1,"riseOnHover":false,"riseOffset":250},["<strong>Country: <\/strong> United States <br><strong>Display Name: <\/strong> United States <br><strong>Downloads: <\/strong> 12629","<strong>Country: <\/strong> United Kingdom <br><strong>Display Name: <\/strong> United Kingdom <br><strong>Downloads: <\/strong> 188","<strong>Country: <\/strong> Germany <br><strong>Display Name: <\/strong> Deutschland <br><strong>Downloads: <\/strong> 156","<strong>Country: <\/strong> Hong Kong SAR China <br><strong>Display Name: <\/strong> 香港 Hong Kong, 中国 <br><strong>Downloads: <\/strong> 71","<strong>Country: <\/strong> Japan <br><strong>Display Name: <\/strong> 日本 <br><strong>Downloads: <\/strong> 605","<strong>Country: <\/strong> Chile <br><strong>Display Name: <\/strong> Chile <br><strong>Downloads: <\/strong> 62","<strong>Country: <\/strong> Indonesia <br><strong>Display Name: <\/strong> Indonesia <br><strong>Downloads: <\/strong> 67","<strong>Country: <\/strong> Canada <br><strong>Display Name: <\/strong> Canada <br><strong>Downloads: <\/strong> 214","<strong>Country: <\/strong> Belarus <br><strong>Display Name: <\/strong> Беларусь <br><strong>Downloads: <\/strong> 17","<strong>Country: <\/strong> South Korea <br><strong>Display Name: <\/strong> 대한민국 <br><strong>Downloads: <\/strong> 331","<strong>Country: <\/strong> Iran <br><strong>Display Name: <\/strong> ایران <br><strong>Downloads: <\/strong> 17","<strong>Country: <\/strong> Colombia <br><strong>Display Name: <\/strong> Colombia <br><strong>Downloads: <\/strong> 52","<strong>Country: <\/strong> China <br><strong>Display Name: <\/strong> 中国 <br><strong>Downloads: <\/strong> 247","<strong>Country: <\/strong> Brazil <br><strong>Display Name: <\/strong> Brasil <br><strong>Downloads: <\/strong> 67","<strong>Country: <\/strong> Italy <br><strong>Display Name: <\/strong> Italia <br><strong>Downloads: <\/strong> 109","<strong>Country: <\/strong> Turkey <br><strong>Display Name: <\/strong> Türkiye <br><strong>Downloads: <\/strong> 37","<strong>Country: <\/strong> Spain <br><strong>Display Name: <\/strong> España <br><strong>Downloads: <\/strong> 152","<strong>Country: <\/strong> Switzerland <br><strong>Display Name: <\/strong> Schweiz/Suisse/Svizzera/Svizra <br><strong>Downloads: <\/strong> 76","<strong>Country: <\/strong> France <br><strong>Display Name: <\/strong> France <br><strong>Downloads: <\/strong> 97","<strong>Country: <\/strong> Pakistan <br><strong>Display Name: <\/strong> پاکستان <br><strong>Downloads: <\/strong> 8","<strong>Country: <\/strong> United Arab Emirates <br><strong>Display Name: <\/strong> الإمارات العربية المتحدة <br><strong>Downloads: <\/strong> 38","<strong>Country: <\/strong> Kenya <br><strong>Display Name: <\/strong> Kenya <br><strong>Downloads: <\/strong> 41","<strong>Country: <\/strong> Iraq <br><strong>Display Name: <\/strong> العراق <br><strong>Downloads: <\/strong> 30","<strong>Country: <\/strong> Hungary <br><strong>Display Name: <\/strong> Magyarország <br><strong>Downloads: <\/strong> 15","<strong>Country: <\/strong> Romania <br><strong>Display Name: <\/strong> România <br><strong>Downloads: <\/strong> 31","<strong>Country: <\/strong> Honduras <br><strong>Display Name: <\/strong> Honduras <br><strong>Downloads: <\/strong> 16","<strong>Country: <\/strong> Belgium <br><strong>Display Name: <\/strong> België / Belgique / Belgien <br><strong>Downloads: <\/strong> 90","<strong>Country: <\/strong> India <br><strong>Display Name: <\/strong> India <br><strong>Downloads: <\/strong> 109","<strong>Country: <\/strong> Russia <br><strong>Display Name: <\/strong> Россия <br><strong>Downloads: <\/strong> 41","<strong>Country: <\/strong> Netherlands <br><strong>Display Name: <\/strong> Nederland <br><strong>Downloads: <\/strong> 88","<strong>Country: <\/strong> Taiwan <br><strong>Display Name: <\/strong> 臺灣 <br><strong>Downloads: <\/strong> 57","<strong>Country: <\/strong> South Africa <br><strong>Display Name: <\/strong> South Africa <br><strong>Downloads: <\/strong> 99","<strong>Country: <\/strong> Sweden <br><strong>Display Name: <\/strong> Sverige <br><strong>Downloads: <\/strong> 27","<strong>Country: <\/strong> Ghana <br><strong>Display Name: <\/strong> Ghana <br><strong>Downloads: <\/strong> 14","<strong>Country: <\/strong> Croatia <br><strong>Display Name: <\/strong> Hrvatska <br><strong>Downloads: <\/strong> 2","<strong>Country: <\/strong> Poland <br><strong>Display Name: <\/strong> Polska <br><strong>Downloads: <\/strong> 40","<strong>Country: <\/strong> Jordan <br><strong>Display Name: <\/strong> الأردن <br><strong>Downloads: <\/strong> 11","<strong>Country: <\/strong> Finland <br><strong>Display Name: <\/strong> Suomi / Finland <br><strong>Downloads: <\/strong> 24","<strong>Country: <\/strong> Peru <br><strong>Display Name: <\/strong> Perú <br><strong>Downloads: <\/strong> 8","<strong>Country: <\/strong> Morocco <br><strong>Display Name: <\/strong> Maroc / ⵍⵎⵖⵔⵉⴱ / المغرب <br><strong>Downloads: <\/strong> 19","<strong>Country: <\/strong> Israel <br><strong>Display Name: <\/strong> ישראל <br><strong>Downloads: <\/strong> 52","<strong>Country: <\/strong> Austria <br><strong>Display Name: <\/strong> Österreich <br><strong>Downloads: <\/strong> 7","<strong>Country: <\/strong> Portugal <br><strong>Display Name: <\/strong> Portugal <br><strong>Downloads: <\/strong> 15","<strong>Country: <\/strong> Vietnam <br><strong>Display Name: <\/strong> Việt Nam <br><strong>Downloads: <\/strong> 21","<strong>Country: <\/strong> Palestinian Territories <br><strong>Display Name: <\/strong> الأراضي الفلسطينية, الضفة الغربية, Palestinian Territory <br><strong>Downloads: <\/strong> 3","<strong>Country: <\/strong> Cyprus <br><strong>Display Name: <\/strong> Κύπρος - Kıbrıs <br><strong>Downloads: <\/strong> 3","<strong>Country: <\/strong> New Zealand <br><strong>Display Name: <\/strong> New Zealand / Aotearoa <br><strong>Downloads: <\/strong> 8","<strong>Country: <\/strong> Australia <br><strong>Display Name: <\/strong> Australia <br><strong>Downloads: <\/strong> 25","<strong>Country: <\/strong> Czechia <br><strong>Display Name: <\/strong> Česko <br><strong>Downloads: <\/strong> 13","<strong>Country: <\/strong> Zambia <br><strong>Display Name: <\/strong> Zambia <br><strong>Downloads: <\/strong> 5","<strong>Country: <\/strong> Costa Rica <br><strong>Display Name: <\/strong> Costa Rica <br><strong>Downloads: <\/strong> 6","<strong>Country: <\/strong> Norway <br><strong>Display Name: <\/strong> Norge <br><strong>Downloads: <\/strong> 3","<strong>Country: <\/strong> Thailand <br><strong>Display Name: <\/strong> ประเทศไทย <br><strong>Downloads: <\/strong> 11","<strong>Country: <\/strong> Panama <br><strong>Display Name: <\/strong> Panamá <br><strong>Downloads: <\/strong> 9","<strong>Country: <\/strong> Slovakia <br><strong>Display Name: <\/strong> Slovensko <br><strong>Downloads: <\/strong> 4","<strong>Country: <\/strong> Denmark <br><strong>Display Name: <\/strong> Danmark <br><strong>Downloads: <\/strong> 24","<strong>Country: <\/strong> Singapore <br><strong>Display Name: <\/strong> Singapore <br><strong>Downloads: <\/strong> 20","<strong>Country: <\/strong> Ethiopia <br><strong>Display Name: <\/strong> ኢትዮጵያ <br><strong>Downloads: <\/strong> 4","<strong>Country: <\/strong> Trinidad & Tobago <br><strong>Display Name: <\/strong> Trinidad, Couva-Tabaquite-Talparo, Trinidad and Tobago <br><strong>Downloads: <\/strong> 26","<strong>Country: <\/strong> Ukraine <br><strong>Display Name: <\/strong> Україна <br><strong>Downloads: <\/strong> 30","<strong>Country: <\/strong> Slovenia <br><strong>Display Name: <\/strong> Slovenija <br><strong>Downloads: <\/strong> 4","<strong>Country: <\/strong> Uganda <br><strong>Display Name: <\/strong> Uganda <br><strong>Downloads: <\/strong> 2","<strong>Country: <\/strong> Mongolia <br><strong>Display Name: <\/strong> Монгол улс ᠮᠤᠩᠭᠤᠯ ᠤᠯᠤᠰ <br><strong>Downloads: <\/strong> 4","<strong>Country: <\/strong> Yemen <br><strong>Display Name: <\/strong> اليمن <br><strong>Downloads: <\/strong> 1","<strong>Country: <\/strong> Malta <br><strong>Display Name: <\/strong> Malta <br><strong>Downloads: <\/strong> 2","<strong>Country: <\/strong> Mexico <br><strong>Display Name: <\/strong> México <br><strong>Downloads: <\/strong> 46","<strong>Country: <\/strong> Nauru <br><strong>Display Name: <\/strong> Naoero <br><strong>Downloads: <\/strong> 8","<strong>Country: <\/strong> Côte d’Ivoire <br><strong>Display Name: <\/strong> Côte d’Ivoire <br><strong>Downloads: <\/strong> 4","<strong>Country: <\/strong> Guadeloupe <br><strong>Display Name: <\/strong> Guadeloupe, France <br><strong>Downloads: <\/strong> 1","<strong>Country: <\/strong> Philippines <br><strong>Display Name: <\/strong> Philippines <br><strong>Downloads: <\/strong> 4","<strong>Country: <\/strong> Venezuela <br><strong>Display Name: <\/strong> Venezuela <br><strong>Downloads: <\/strong> 4","<strong>Country: <\/strong> Argentina <br><strong>Display Name: <\/strong> Argentina <br><strong>Downloads: <\/strong> 14","<strong>Country: <\/strong> Luxembourg <br><strong>Display Name: <\/strong> Lëtzebuerg <br><strong>Downloads: <\/strong> 8","<strong>Country: <\/strong> Ireland <br><strong>Display Name: <\/strong> Éire / Ireland <br><strong>Downloads: <\/strong> 9","<strong>Country: <\/strong> Zimbabwe <br><strong>Display Name: <\/strong> Zimbabwe <br><strong>Downloads: <\/strong> 4","<strong>Country: <\/strong> Tunisia <br><strong>Display Name: <\/strong> تونس <br><strong>Downloads: <\/strong> 12","<strong>Country: <\/strong> Serbia <br><strong>Display Name: <\/strong> Србија <br><strong>Downloads: <\/strong> 17","<strong>Country: <\/strong> Greece <br><strong>Display Name: <\/strong> Ελλάς <br><strong>Downloads: <\/strong> 6","<strong>Country: <\/strong> Belize <br><strong>Display Name: <\/strong> Belize <br><strong>Downloads: <\/strong> 5","<strong>Country: <\/strong> Saudi Arabia <br><strong>Display Name: <\/strong> السعودية <br><strong>Downloads: <\/strong> 22","<strong>Country: <\/strong> Malaysia <br><strong>Display Name: <\/strong> Malaysia <br><strong>Downloads: <\/strong> 6","<strong>Country: <\/strong> Ecuador <br><strong>Display Name: <\/strong> Ecuador <br><strong>Downloads: <\/strong> 14","<strong>Country: <\/strong> Bahrain <br><strong>Display Name: <\/strong> البحرين <br><strong>Downloads: <\/strong> 4","<strong>Country: <\/strong> Paraguay <br><strong>Display Name: <\/strong> Paraguay <br><strong>Downloads: <\/strong> 4","<strong>Country: <\/strong> Egypt <br><strong>Display Name: <\/strong> مصر <br><strong>Downloads: <\/strong> 17","<strong>Country: <\/strong> Mauritius <br><strong>Display Name: <\/strong> Mauritius <br><strong>Downloads: <\/strong> 4","<strong>Country: <\/strong> Senegal <br><strong>Display Name: <\/strong> Sénégal <br><strong>Downloads: <\/strong> 9","<strong>Country: <\/strong> Latvia <br><strong>Display Name: <\/strong> Latvija <br><strong>Downloads: <\/strong> 6","<strong>Country: <\/strong> Albania <br><strong>Display Name: <\/strong> Shqipëria <br><strong>Downloads: <\/strong> 1","<strong>Country: <\/strong> Bahamas <br><strong>Display Name: <\/strong> The Bahamas <br><strong>Downloads: <\/strong> 4","<strong>Country: <\/strong> Qatar <br><strong>Display Name: <\/strong> قطر <br><strong>Downloads: <\/strong> 5","<strong>Country: <\/strong> North Macedonia <br><strong>Display Name: <\/strong> Северна Македонија <br><strong>Downloads: <\/strong> 5","<strong>Country: <\/strong> Lithuania <br><strong>Display Name: <\/strong> Lietuva <br><strong>Downloads: <\/strong> 5"],null,null,null,["United States","United Kingdom","Germany","Hong Kong SAR China","Japan","Chile","Indonesia","Canada","Belarus","South Korea","Iran","Colombia","China","Brazil","Italy","Turkey","Spain","Switzerland","France","Pakistan","United Arab Emirates","Kenya","Iraq","Hungary","Romania","Honduras","Belgium","India","Russia","Netherlands","Taiwan","South Africa","Sweden","Ghana","Croatia","Poland","Jordan","Finland","Peru","Morocco","Israel","Austria","Portugal","Vietnam","Palestinian Territories","Cyprus","New Zealand","Australia","Czechia","Zambia","Costa Rica","Norway","Thailand","Panama","Slovakia","Denmark","Singapore","Ethiopia","Trinidad &amp;amp; Tobago","Ukraine","Slovenia","Uganda","Mongolia","Yemen","Malta","Mexico","Nauru","Côte d’Ivoire","Guadeloupe","Philippines","Venezuela","Argentina","Luxembourg","Ireland","Zimbabwe","Tunisia","Serbia","Greece","Belize","Saudi Arabia","Malaysia","Ecuador","Bahrain","Paraguay","Egypt","Mauritius","Senegal","Latvia","Albania","Bahamas","Qatar","North Macedonia","Lithuania"],{"interactive":false,"permanent":false,"direction":"auto","opacity":1,"offset":[0,0],"textsize":"10px","textOnly":false,"className":"","sticky":true},null]}],"limits":{"lat":[-41.5000831,64.6863136],"lng":[-107.991707,172.8344077]}},"evals":[],"jsHooks":[]}</script>

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
| 0.0.2   |        0 |         513 |             0 |           0 |            0 |
| 0.1.0   |      143 |           0 |             0 |         364 |            0 |
| 0.1.1   |     1190 |           0 |             0 |        1842 |            0 |
| 0.1.2   |     1363 |           0 |             0 |         885 |            0 |
| 0.1.3   |      210 |           0 |             0 |         646 |            0 |
| 0.1.4   |      258 |           0 |             0 |           0 |            0 |
| 0.1.5   |      909 |           0 |             0 |           0 |            0 |
| 0.1.6   |      696 |           0 |             0 |           0 |            0 |
| 1.0.0   |        0 |           0 |          2764 |           0 |         2174 |
| 1.0.1   |        0 |           0 |          3005 |           0 |          613 |

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

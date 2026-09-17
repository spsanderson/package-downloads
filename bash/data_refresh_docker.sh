#!/usr/bin/env bash
set -euo pipefail

echo "== package-downloads daily refresh =="
echo "Started: $(date -Is)"

# Install the checked-out repository itself so README.qmd can library(packagedownloads).
R CMD INSTALL .

echo "Rendering README.qmd with Quarto..."
quarto render README.qmd --to gfm

echo "Validating required upstream handoff files..."
test -s old_downloads.RDS
test -s pkg_release_tbl.rds

echo "Validating primary rendered output..."
test -s README.md

echo "Checking latest CRAN log date..."
Rscript - <<'RSCRIPT'
x <- readRDS("old_downloads.RDS")
stopifnot(nrow(x) > 0)
latest <- max(as.Date(x$date), na.rm = TRUE)
message("Latest CRAN date in old_downloads.RDS: ", latest)

# The source pipeline intentionally trails CRAN publication availability.
# Guard against obviously stale data without requiring a specific exact day.
age_days <- as.integer(Sys.Date() - latest)
if (is.na(age_days) || age_days > 7L) {
  stop("CRAN download data appears stale: latest date is ", latest)
}
RSCRIPT

echo "Refresh and validation completed: $(date -Is)"

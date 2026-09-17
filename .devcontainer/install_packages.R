options(
  repos = c(CRAN = Sys.getenv("CRAN_MIRROR", "https://cloud.r-project.org")),
  Ncpus = max(1L, parallel::detectCores() - 1L)
)

if (!requireNamespace("jsonlite", quietly = TRUE)) {
  install.packages("jsonlite")
}

cfg <- jsonlite::fromJSON("packages.json", simplifyDataFrame = TRUE)
packages <- unique(cfg$packages$package)

message("Installing R packages:")
message(paste0(" - ", packages, collapse = "\n"))

install.packages(
  packages,
  dependencies = c("Depends", "Imports", "LinkingTo")
)

missing <- packages[
  !vapply(packages, requireNamespace, logical(1), quietly = TRUE)
]

if (length(missing) > 0) {
  stop(
    "The following packages failed validation: ",
    paste(missing, collapse = ", ")
  )
}

message("All declared R packages installed successfully.")

FROM rocker/r-ver:4.6.1

ARG DEBIAN_FRONTEND=noninteractive
ARG QUARTO_VERSION=1.9.38
ARG CRAN_MIRROR=https://cloud.r-project.org

ENV DEBIAN_FRONTEND=${DEBIAN_FRONTEND}
ENV CRAN_MIRROR=${CRAN_MIRROR}
ENV TZ=America/New_York
ENV RENV_CONFIG_AUTOLOADER_ENABLED=FALSE

# System libraries needed by the R/reporting/mapping stack.
RUN apt-get update && apt-get install -y --no-install-recommends \
    bash \
    ca-certificates \
    curl \
    git \
    jq \
    make \
    pandoc \
    wget \
    chromium \
    libcurl4-openssl-dev \
    libssl-dev \
    libxml2-dev \
    libgit2-dev \
    libfontconfig1-dev \
    libfreetype6-dev \
    libpng-dev \
    libjpeg-dev \
    libtiff5-dev \
    libcairo2-dev \
    libharfbuzz-dev \
    libfribidi-dev \
    libudunits2-dev \
    libgdal-dev \
    libgeos-dev \
    libproj-dev \
    libsqlite3-dev \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /tmp/container-setup

COPY .devcontainer/packages.json \
     .devcontainer/install_packages.R \
     .devcontainer/install_quarto.sh \
     ./

RUN Rscript install_packages.R
RUN bash install_quarto.sh "${QUARTO_VERSION}"

# Chromium path used by screenshot/webshot tooling when needed.
ENV CHROMOTE_CHROME=/usr/bin/chromium
ENV CHROME_BIN=/usr/bin/chromium

WORKDIR /workspace

# Basic build-time validation.
RUN R --version && quarto --version && git --version

CMD ["/bin/bash"]

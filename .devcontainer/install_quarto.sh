#!/usr/bin/env bash
set -euo pipefail

QUARTO_VERSION="${1:?Quarto version is required}"

ARCH="$(dpkg --print-architecture)"

case "${ARCH}" in
  amd64)
    QUARTO_ARCH="amd64"
    ;;
  arm64)
    QUARTO_ARCH="arm64"
    ;;
  *)
    echo "Unsupported architecture: ${ARCH}" >&2
    exit 1
    ;;
esac

TMP_DEB="/tmp/quarto.deb"

curl -fsSL \
  "https://github.com/quarto-dev/quarto-cli/releases/download/v${QUARTO_VERSION}/quarto-${QUARTO_VERSION}-linux-${QUARTO_ARCH}.deb" \
  -o "${TMP_DEB}"

apt-get update
apt-get install -y "${TMP_DEB}"
rm -f "${TMP_DEB}"
rm -rf /var/lib/apt/lists/*

quarto --version

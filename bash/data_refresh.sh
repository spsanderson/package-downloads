#!/bin/bash

echo "Rendering the page..."

Rscript -e "rmarkdown::render(input = 'README.Rmd')"

if [[ "$(git status --porcelain)" != "" ]]; then
    git config --global user.name 'spsanderson'
    git config --global user.email 'spsanderson@gmail.com'
    git add *
    git commit -m "Auto update dashboard"
    git push
fi

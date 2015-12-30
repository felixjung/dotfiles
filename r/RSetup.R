# List of require CRAN packages
packages.required.standard <- c('ggplot2', 'foreach', 'mnormt', 'numDeriv',
                                'xts', 'parallel', 'snowfall', 'tis', 'doMC',
                                'stringr', 'setwidth', 'xtable', 'devtools',
                                'reshape2', 'grid', 'vars', 'lubridate',
                                'rgl', 'scales', 'tseries', 'pastecs')

# List of required packages from Github
packages.required.devtools <- list(
  list(repo = 'colorout', user = 'jalvesaq'),
  list(repo = 'VimCom', user = 'jalvesaq'))

# Find installed packages
packages.installed <- installed.packages()[, 'Package']

# Determine standard packages not yet installed
packages.to.install <- packages.required.standard[!(packages.required.standard
  %in% packages.installed)]

# Install required packages
if (length(packages.to.install) > 0) {
  install.packages(packages.to.install, dependencies = TRUE)
}

# Load devtools package
library(devtools)

# Install non-standard packages from Github using devtools
for (package in packages.required.devtools) {
  if (!(package$repo %in% packages.installed)) {
    repo.id  <- paste(package$user, package$repo, sep = '/')
    devtools::install_github(repo.id)
  }
}

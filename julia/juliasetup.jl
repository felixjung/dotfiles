# Packages to install
packages = [
    "Cairo",
    "Gadfly",
    "MultivariateStats",
    "DataArrays",
    "Dates",
    "MathProgBase",
    "GLM"
]

# Install standard packages
for package in packages
    info("Installing package $package.")
    Pkg.add(package)
end

# Install non official packages
package_urls = [
    "git@github.com:farrellm/YTables.jl.git"
]

# Clone non-standard packages
for url in package_urls
    info("Installing package $url.")
    Pkg.clone(url)
end


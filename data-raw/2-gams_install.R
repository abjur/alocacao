# Install GAMS
pkg_url <- "https://support.gams.com/_media/gdxrrw:gdxrrw_1.0.2.tar.gz"
pkg_file <- "data-raw/gams_package.tar.gz"
httr::GET(pkg_url, httr::write_disk(pkg_file))
install.packages("reshape2")
install.packages(pkg_file, repos = NULL, type = "source")

# Download GAMS
## some deps: https://support.gams.com/installation:gams_and_ubuntu_linux
# sudo apt-get install lsb-core
# sudo apt-get install ia32-libs

url_sfx <- "https://d37drm4t2jghv5.cloudfront.net/distributions/24.9.2/linux/linux_x64_64_sfx.exe"
file_sfx <- "data-raw/linux_x64_64_sfx.exe"
httr::GET(url_sfx,
          httr::write_disk(file_sfx, overwrite = TRUE),
          httr::progress())
## takes a life to run
unzip(file_sfx, exdir = "data-raw")

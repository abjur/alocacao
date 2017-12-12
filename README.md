[![Travis-CI Build Status](https://travis-ci.org/abjur/alocacao.svg?branch=master)](https://travis-ci.org/abjur/alocacao)

# alocacao

This package runs GAMS to allocate courts using an integer programming model.

## Installation

You can install alocacao from github with:

``` r
# install.packages("devtools")
devtools::install_github("abjur/alocacao")
```

## Example

This package has no functions. It was not created to add any functionality. All the scripts that matter are inside the `data-raw` folder:

- `1-gams_generate.R`: Generate `.GMS` file, the input to the GAMS model.
- `2-gams_install.R`: Install GAMS deps and `gdxrrw` to an Ubuntu 16.04 distro.
- `3-gams_run.R`: Run the GAMS model and save the `.lst` GAMS output and saves the model output to the `result.rds` file.

The output of these scripts is the `.lst` file and the `.rds` file. This is used as an input to some jurimetric analysis.

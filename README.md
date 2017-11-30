
<!-- README.md is generated from README.Rmd. Please edit that file -->

## Overview

`smargins` is a package that aids in calculating expected values for
models of various kinds. There are many packages like it (e.g.,
[coreSim](https://cran.r-project.org/web/packages/coreSim/),
[effects](https://cran.rstudio.com/web/packages/effects/),
[lsmeans](https://cran.rstudio.com/web/packages/lsmeans/),
[margins](https://cran.rstudio.com/web/packages/margins/),
[rms](https://cran.rstudio.com/web/packages/rms/) and
[Zelig](https://cran.rstudio.com/web/packages/Zelig/)) but this one is
mine.

The main functions provided by this package are: \* `smargins()`
calculates average marginal effects \* `scompare()` performs pairwise
comparisons of the average marginal effects produced by `smargins`.

Some examples are available at (<https://izahn.github.io/smargins/>)

## Purpose

The primary purpose of this package is to serve as a test bed for
exploring interfaces and designs for R packages that facilitate
calculating quantities of interest. Several such packages exist, each
with their own pros and cons. This package is serves as a play ground
where we can try different approaches in order to see if we can find one
with more pros and fewer cons than existing solutions.

## Installation

`smargins` is not on CRAN (and may never be). You can install it from
github using the `devtools` package:

``` r
## install.packages("devtools")
devtools::install_github("izahn/smargins")
```

## Usage

``` r
library(smargins)

mtc <- transform(mtcars, gear = factor(gear))

m.sm <- smargins(lm(mpg ~ gear, data = mtc),
                 gear = levels(gear))
summary(m.sm)
#>   gear     mean       sd   median lower_2.5 upper_97.5
#> 1    3 16.10483 1.200065 16.12023  13.71138   18.36346
#> 2    4 24.51032 1.359366 24.52658  21.86653   27.10848
#> 3    5 21.36217 2.119753 21.38801  17.19834   25.44180

summary(scompare(m.sm, "gear"))
#>     gear      mean       sd    median  lower_2.5 upper_97.5
#> 1 3 vs 4 -8.405488 1.832274 -8.385549 -11.992972 -4.8560910
#> 2 3 vs 5 -5.257342 2.441109 -5.308083 -10.000074 -0.3124534
#> 3 4 vs 5  3.148147 2.524655  3.126986  -1.711864  8.1714581
```

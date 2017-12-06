
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
#> 1    3 16.07482 1.206685 16.07100  13.67641   18.41860
#> 2    4 24.53273 1.340531 24.54211  21.97104   27.16766
#> 3    5 21.34948 2.073918 21.37401  17.20822   25.27452

summary(scompare(m.sm, "gear"))
#>     gear      mean       sd    median  lower_2.5 upper_97.5
#> 1 3 vs 4 -8.457914 1.805836 -8.449702 -11.979365 -5.0524839
#> 2 3 vs 5 -5.274657 2.380107 -5.298567  -9.922065 -0.5888147
#> 3 4 vs 5  3.183256 2.462246  3.201491  -1.586639  7.9665004
```

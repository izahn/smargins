
<!-- README.md is generated from README.Rmd. Please edit that file -->

## Overview

`smargins` is a package that aids in calculating Average Marginal
Effects for models of various kinds. There are many packages like it
(e.g., [coreSim](https://cran.r-project.org/web/packages/coreSim/),
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
#> 1    3 16.12158 1.231164 16.13634  13.75163   18.54393
#> 2    4 24.53023 1.393740 24.55831  21.74456   27.33567
#> 3    5 21.34638 2.099512 21.28180  17.37375   25.56731

summary(scompare(m.sm, "gear"))
#>     gear      mean       sd    median  lower_2.5 upper_97.5
#> 1 3 vs 4 -8.408652 1.844897 -8.393169 -12.034240 -4.8403958
#> 2 3 vs 5 -5.224802 2.419402 -5.195774 -10.047474 -0.4846925
#> 3 4 vs 5  3.183849 2.495371  3.182240  -1.734914  7.9285845
```

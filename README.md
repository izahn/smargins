<!-- README.md is generated from README.Rmd. Please edit that file -->
Overview
--------

`smargins` is a package that aids in calculating Average Marginal
Effects for models of various kinds. There are many packages like it
(e.g., [effects](https://cran.rstudio.com/web/packages/effects/),
[lsmeans](https://cran.rstudio.com/web/packages/lsmeans/),
[margins](https://cran.rstudio.com/web/packages/margins/),
[rms](https://cran.rstudio.com/web/packages/rms/) and
[Zelig](https://cran.rstudio.com/web/packages/Zelig/)) but this one is
mine.

The main functions provided by this package are: \* `smargins()`
calculates average marginal effects \* `scompare()` performs pairwise
comparisons of the average marginal effects produced by `smargins`.

Some examples are available at (<https://izahn.github.io/smargins/>)

Purpose
-------

The primary purpose of this package is to serve as a test bed for
exploring interfaces and designs for R packages that facilitate
calculating quantities of interest. Several such packages exist, each
with their own pros and cons. This package is serves as a play ground
where we can try different approaches in order to see if we can find one
with more pros and fewer cons than existing solutions.

Installation
------------

`smargins` is not on CRAN (and may never be). You can install it from
github using the `devtools` package:

    # install.packages("devtools")
    devtools::install_github("tidyverse/dplyr")

Usage
-----

    library(smargins)

    mtc <- transform(mtcars, gear = factor(gear))

    m.sm <- smargins(lm(mpg ~ gear, data = mtc),
                     at = list(gear = levels(mtc$gear)))
    summary(m.sm)
    #>   gear     mean       sd   median lower_2.5 upper_97.5
    #> 1    3 16.09919 1.235973 16.08059  13.73738   18.50996
    #> 2    4 24.54575 1.333915 24.52239  21.75110   27.19820
    #> 3    5 21.38965 2.091787 21.37447  17.21370   25.45643

    summary(scompare(m.sm, "gear"))
    #>     gear      mean       sd    median  lower_2.5 upper_97.5
    #> 1 3 vs 4 -8.446562 1.800213 -8.472657 -11.993262 -4.9112416
    #> 2 3 vs 5 -5.290452 2.408014 -5.270751  -9.870763 -0.5940042
    #> 3 4 vs 5  3.156109 2.466389  3.107031  -1.713973  8.0977813

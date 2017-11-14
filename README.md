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

Some examples are available at [](https://izahn.github.io/smargins/)

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
    #> 1    3 16.09317 1.228878 16.02596  13.66345   18.43532
    #> 2    4 24.53272 1.374501 24.50382  21.85658   27.49507
    #> 3    5 21.31562 2.144460 21.22444  17.16829   25.67557

    summary(scompare(m.sm, "gear"))
    #>     gear      mean       sd    median  lower_2.5 upper_97.5
    #> 1 3 vs 4 -8.439557 1.835630 -8.485771 -11.993408 -4.7810416
    #> 2 3 vs 5 -5.222452 2.472813 -5.167885 -10.308377 -0.2634693
    #> 3 4 vs 5  3.217106 2.541430  3.213214  -1.475929  8.2469156

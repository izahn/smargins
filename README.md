<!-- README.md is generated from README.Rmd. Please edit that file -->
Overview
--------

`smargins` is a package that aids in calculating Average Marginal
Effects for models of various kinds. There are many packages like it
(e.g.,[effects](https://cran.rstudio.com/web/packages/effects/),
[lsmeans](https://cran.rstudio.com/web/packages/lsmeans/),
[margins](https://cran.rstudio.com/web/packages/margins/), and
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
    #> 1    3 16.11536 1.224537 16.12504  13.70970   18.51455
    #> 2    4 24.56198 1.313763 24.59786  21.95439   27.02018
    #> 3    5 21.45020 2.059484 21.48608  17.40312   25.50417

    summary(scompare(m.sm, "gear"))
    #>     gear      mean       sd    median  lower_2.5 upper_97.5
    #> 1 3 vs 4 -8.446617 1.796413 -8.471356 -11.802274 -4.9091850
    #> 2 3 vs 5 -5.334846 2.448668 -5.333002 -10.106188 -0.3231437
    #> 3 4 vs 5  3.111772 2.453608  3.053308  -1.695247  7.8960754

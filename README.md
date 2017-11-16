<!-- README.md is generated from README.Rmd. Please edit that file -->
Overview
--------

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

    ## install.packages("devtools")
    devtools::install_github("izahn/smargins")

Usage
-----

    library(smargins)

    mtcars <- transform(mtcars, gear = factor(gear))

    m.sm <- smargins(lm(mpg ~ gear, data = mtcars),
                     gear = levels(gear))
    summary(m.sm)
    #>   gear     mean       sd   median lower_2.5 upper_97.5
    #> 1    3 16.07109 1.214436 16.05300  13.75438   18.44333
    #> 2    4 24.53784 1.368736 24.53490  21.92441   27.24769
    #> 3    5 21.43060 2.106989 21.42886  17.30583   25.56910

    summary(scompare(m.sm, "gear"))
    #>     gear      mean       sd    median lower_2.5 upper_97.5
    #> 1 3 vs 4 -8.466747 1.833977 -8.446346 -12.13801 -4.9015510
    #> 2 3 vs 5 -5.359512 2.452244 -5.388814 -10.16701 -0.5767845
    #> 3 4 vs 5  3.107235 2.501960  3.086447  -1.77765  8.0003284

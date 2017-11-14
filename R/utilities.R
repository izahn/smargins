
#' Calculate summary statistics
#'
#' @param x A numeric vector, e.g., of expected values
#' @param level A fraction between 0 and 1 giving the level at which
#'              to calculate confidence intervals.
#'
#' @return A named vector of summary statistics.
#' @author Ista Zahn
#' @export
sumstats <- function (x, level = 0.95) {
    l2 <- (1-level)/2
    lmu <- quantile(x, c(l2, 0.5, (1 - l2)), na.rm = TRUE)
    mn <- mean(x, na.rm = TRUE)
    s <- sd(x, na.rm = TRUE)
    setNames(c(mn, s, lmu[2], lmu[1], lmu[3]),
             c("mean", "sd", "median",
               paste(c("lower", "upper"),
                     sprintf("%1.1f", 100*c(l2, (1-l2))),
                     sep = "_")))
}

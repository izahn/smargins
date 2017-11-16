#' Calculate average marginal effects from a fitted model object.
#'
#' @param model A fitted model object.
#' @param at A named list of values to set predictor variables to.
#' @param n Number of simulations to run.
#' @param ... Further arguments passed to or from other methods.
#'
#' @return A data.frame containing predictor variables values and
#'     expected values of the dependant variable.
#' 
#' @examples
#' library(smargins)
#' lm.out <- lm(Fertility ~ Education, data = swiss)
#'
#' smargins(lm.out, at = list(Education = quantile(swiss$Education, c(.25, .50, .75))))
#'
#' @author Ista Zahn
#' @export
smargins <- function(model, ..., n = 1000) {
    UseMethod("smargins")
}


#' Calculate average marginal effects from a fitted model object.
#'
#' @param model A fitted model object.
#' @param ... Named values to set predictor variables to.
#' @param n Number of simulations to run.
#' @param coef.fun Number of simulations to run.
#' @param sim.fun Number of simulations to run.
#' @param linkinv.fun Number of simulations to run.
#' @param vcov.fun Number of simulations to run.
#' @param model.frame.fun Number of simulations to run.
#' @param model.matrix.fun Number of simulations to run.
#'
#' @return A data.frame containing predictor variables values and
#'         expected values of the dependant variable.
#'
#' @author Ista Zahn
#' @export
smargins.default <- function(model, ..., n = 5000,
                             coef.fun = coef,
                             sim.fun = I,
                             linkinv.fun = family(model)$linkinv,
                             vcov.fun = vcov,
                             model.frame.fun = model.frame,
                             model.matrix.fun = function(x, data) {model.matrix(formula(x), data = data)}
                             #model.matrix.fun = model.matrix
                             ) {
    mf <- model.frame.fun(model)
    #xl <- lapply(mf[!sapply(mf, is.numeric)], levels)
    at <- eval(substitute(list(...)), prediction::find_data(model))
    at.grid <- expand.grid(at)
    fvars <- names(mf)[purrr::map_lgl(mf, is.factor)]
    mf.orig <- mf
    mf <- mf[, setdiff(names(mf), names(at)), drop = FALSE]
    mf <- merge(mf, at.grid, all = TRUE)
    for(var in fvars) levels(mf[[var]]) <- levels(mf.orig[[var]])
    mm <- model.matrix.fun(model, data = mf)
    sim <- sim.fun(MASS::mvrnorm(n, coef.fun(model), vcov.fun(model)))
    smm <- unlist(purrr::map(split.data.frame(mm %*% t(sim), droplevels(mf[, names(at), drop = FALSE])),
                             colMeans))
    xvals <- at.grid[rep(1:nrow(at.grid), each = n), , drop = FALSE]
    sn <- rep(1:n, times = nrow(at.grid))
    out <- data.frame(xvals,
                      `.sim_number` = sn,
                      `.smargin_qi` = smm,
                      stringsAsFactors = FALSE)
    out[[".smargin_qi"]] <- linkinv.fun(out[[".smargin_qi"]])
    class(out) <- c("smargins", class(out))
    rownames(out) <- 1:nrow(out)
    out
}

#' Print a smargins object.
#'
#' @param x An object of class "smargins".
#' @author Ista Zahn
#' @export
print.smargins <- function(x) {
    rownames(x) <- sprintf(paste0("%-", nchar(nrow(x)), "s"), rownames(x))
    width <- nchar(capture.output(print.data.frame(tail(x, 1)))[2])
    print.data.frame(head(x))
    cat("# ", paste(rep("-", width/2), collapse = " "), sep = "")
    print.data.frame(setNames(tail(x), gsub(".", " ", names(x))))
}

#' Summarize a smargins object.
#'
#' @param object An object of class "smargins".
#' @param vars A character vector naming columns to aggregate by.
#' @param level Level at which confidnece interval should be calculated
#' @author Ista Zahn
#' @export
summary.smargins <- function(object, vars = names(object)[1:(ncol(object)-2)], level=0.95) {
    all.vars <- names(object)[1:(ncol(object)-2)]
    stats <- purrr:::map(split(object[[ncol(object)]], object[, all.vars, drop = FALSE]),
                         sumstats, level = level)
    out <- data.frame(unique(object[, all.vars, drop = FALSE]),
                      rbind(purrr::reduce(stats,rbind)))
    if(!identical(vars, all.vars)) {
        out <- data.frame(unique(out[, vars, drop = FALSE]),
                          purrr::reduce(purrr::map(split(out[(ncol(out) - 4):ncol(out)], out[, vars, drop = FALSE]),
                                                   colMeans),
                                        rbind),
                          stringsAsFactors = FALSE)
    }
    rownames(out) <- 1:nrow(out)
    out
}

#' Compare expected values at combinations of predictor variable values.
#'
#' @param object An object of class "smargins".
#' @param var A character string naming the variable to compute comparisons for.
#' @author Ista Zahn
#' @export
scompare <- function(smargins, var) {
    nc <- ncol(smargins)
    nr <- nrow(smargins)
    pairs <- as.data.frame(combn(unique(as.character(smargins[[var]])), 2),
                           stringsAsFactors = FALSE)
    diffs <- purrr::map(pairs,
                        function(pair) {
                            p1 <- smargins[smargins[[var]] == pair[1], nc]
                            p2 <- smargins[smargins[[var]] == pair[2], nc]
                            diff <- p1 - p2
                            out <- data.frame(paste(pair[1], "vs", pair[2]),
                                              1:nr,
                                              diff,
                                              stringsAsFactors = FALSE)
                            setNames(out, c(var, ".sim_number", ".smargin_qi"))
                        })
    out <- purrr::reduce(diffs, rbind)
    class(out) <- c("smargins", class(out))
    out
}

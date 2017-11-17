#' @export
smargins_v1 <- smargins.default

#' Temporary smargins variant
#'
#' @param model A fitted model object.
#' @param vars Character vector naming variables
#' @param xvalues Named list of values.
#' @param n Number of simulations to run.
#' @param coef.fun Function to use for computing coefficients.
#' @param sim.fun Function to use for adjusting simulations.
#' @param linkinv.fun Function to use for cmputing the inverse link.
#' @param vcov.fun Function to use for computing the variance-covariance matrix.
#' @param model.frame.fun Function to use for extracting the model.frame.
#' @param model.matrix.fun Function to use for extracting the model.matrix.
#'
#' @return A data.frame containing predictor variables values and
#'         expected values of the dependant variable.
#'
#' @author Ista Zahn
#' @export
smargins_v2 <- function(model,
                        vars,
                        xvalues = NULL,
                        n = 5000,
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
    alldat <- try(prediction::find_data(model), silent = TRUE)
    if(class(alldat) == "try-error") alldat <- mf
    at <- lapply(vars, function(x) {
        val <- alldat[[x]]
        if(is.numeric(val)) {
            quantile(val)
        } else {
            levels(factor(val))
        }
    })
    names(at) <- vars
    at[names(xvalues)] <- xvalues
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

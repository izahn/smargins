#' Calculate average marginal effects from a fitted model object.
#'
#' @param model A fitted model object.
#' @param at A named list of values to set predictor variables to.
#' @param n Number of simulations to run.
#' @param ... Further arguments passed to or from other methods.
#'
#' @return A data.frame containing predictor variables values and
#'     expected values of the dependant variable.
#' @author Ista Zahn
#' @export
smargins.lmerMod <- smargins.glmerMod <- function(model, at = NULL, n = 1000, ...) {
    smargins.default(model, at = at, n = n,
                     coef.fun = fixef,
                     vcov.fun  = function(x) as.matrix(vcov(x)),
                     model.matrix.fun = function(x, data) model.matrix(update(x, data = data)))
}

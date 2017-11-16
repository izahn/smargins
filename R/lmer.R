#' Calculate average marginal effects from a fitted model object.
#'
#' @param model A fitted model object.
#' @param ... Named values to set predictor variables to.
#' @param n Number of simulations to run.
#'
#' @return A data.frame containing predictor variables values and
#'     expected values of the dependant variable.
#' @author Ista Zahn
#' @export
smargins.lmerMod <- smargins.glmerMod <- function(model, ..., n = 1000) {
    smargins.default(model, ..., n = n,
                     coef.fun = fixef,
                     vcov.fun  = function(x) as.matrix(vcov(x)),
                     model.matrix.fun = function(x, data) model.matrix(update(x, data = data)))
}

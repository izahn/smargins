sr.linkinv <- function(object) {
    if (is.character(object$dist)) 
        dd <- survreg.distributions[[object$dist]]
    else dd <- object$dist
    if (is.null(dd$itrans)) {
        itrans <- function(x) x
        dtrans <- function(x) 1
    }
    else {
        itrans <- dd$itrans
        dtrans <- dd$dtrans
    }
    itrans
}

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
smargins.survreg <- function(model, ..., n = 1000) {
    smargins.default(model = model, ..., n = n,
                     coef.fun = function(x) c(coef(x), log(x$scale)),
                     linkinv.fun = sr.linkinv(model),
                     sim.fun = function(x) x[, -ncol(x), drop = FALSE],
                     model.matrix.fun = model.matrix)
}

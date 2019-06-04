### =========================================================================
### HailContext singleton management
### -------------------------------------------------------------------------
###

#' Create a HailContext
#' 
#' To use Hail features it is necessary to create a connection, the function 
#' \code{hail_context()} create this connection and returns a jobj of 
#' class \code{is.Hail.HailContext}. The \code{hail()} funciton is just a wrapper of 
#' \code{hail_context()}.
#' 
#' @examples 
#' \dontrun{
#' hail()
#' }
#' @name HailContext
NULL


setClassUnion("HailContext_OR_NULL", c("HailContext", "NULL"))

HailContextManager_getContext <- function(.self) {
    ctx <- .self$context
    if (is.null(ctx)) {
        ctx <- .self$setHailContext(initHailContext())
    }
    ctx
}

HailContextManager_setContext <- function(.self, ctx) {
    .self$context <- ctx
    ctx
}

HailContextManager <- 
    setRefClass("HailContextManager", fields=c(context="HailContext_OR_NULL"),
                methods=list(getHailContext=HailContextManager_getContext,
                             setHailContext=HailContextManager_setContext))()

use_hail_context <- function(context) {
    HailContextManager$setContext(context)
}

#' @rdname HailContext
#' @export
hail_context <- function() {
    HailContextManager$getHailContext()
}

#' @rdname HailContext
#' @export
hail <- hail_context

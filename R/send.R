### =========================================================================
### Sending
### -------------------------------------------------------------------------
###
### Utlitlies for sending data somewhere and still being able to use it.
### 

### - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
### send(): the top-level user entry point
###

#' Sending
#'  
#' Utlitlies for sending data somewhere and still being able to use it.
#' 
#' @param x 
#' @param dest 
#'
#' @export
send <- function(x, dest) {
    marshalled <- marshal(x, dest)
    remote <- transmit(marshalled, dest)
    unmarshal(remote, x)
}

setGeneric("marshal", function(x, dest) x)

setGeneric("transmit", function(x, dest) standardGeneric("transmit"))

setGeneric("unmarshal", function(x, skeleton) x)

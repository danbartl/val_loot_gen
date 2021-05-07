require(yaml)
require(data.table)
require(magrittr)
require(readxl)
require(stringr)


options(datatable.print.class = T)


require("rjson")
require("RJSONIO")
require("rlist")
require("zoo")
library(magrittr)
require(clipr)

combineListsAsOne <-function(...){
  return(list(...))
}

CJ.dt <- function(X, Y) {
  k <- NULL
  X <- X[, c(k = 1, .SD)]
  setkey(X, k)
  Y <- Y[, c(k = 1, .SD)]
  setkey(Y, NULL)
  X[Y, allow.cartesian = TRUE][, `:=`(k, NULL)]
} 


smart.round <- function(x) {
  y <- floor(x)
  indices <- tail(order(x-y), round(sum(x)) - sum(y))
  y[indices] <- y[indices] + 1
  y
}

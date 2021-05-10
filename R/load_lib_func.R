
if (!require('yaml')) install.packages('yaml'); library('yaml')
if (!require('data.table')) install.packages('data.table'); library('data.table')
if (!require('magrittr')) install.packages('magrittr'); library('magrittr')
if (!require('readxl')) install.packages('readxl'); library('readxl')
if (!require('stringr')) install.packages('stringr'); library('stringr')
if (!require('rjson')) install.packages('rjson'); library('rjson')
if (!require('RJSONIO')) install.packages('RJSONIO'); library('RJSONIO')
if (!require('rlist')) install.packages('rlist'); library('rlist')
if (!require('zoo')) install.packages('zoo'); library('zoo')
if (!require('clipr')) install.packages('clipr'); library('clipr')
if (!require('extraDistr')) install.packages('extraDistr'); library('extraDistr')
if (!require('readr')) install.packages('readr'); library('readr')



options(datatable.print.class = T)


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

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

#Specify the ratio of conversion
conversion_enchantmats <- 5
#from lowest to highest rarity across four tiers
tiers <- 4

#Drops are scaled linearly from weakest to strongest creeature
expected_drops <- c(0.2,10)

#How many legendaries should you get for highest difficulty mob
legendary_count <- 5

#Which hero scenarios should be relevant?
#early, mid, end
hero_weight <- c(0.25,0.25,0.5)

early_hero_armor <- 20
early_hero_damage <- 30
early_hero_hp <- 90

mid_hero_armor <- 80
mid_hero_damage <- 80
mid_hero_hp <- 140


end_hero_armor <- 200
end_hero_damage <- 150
end_hero_hp <- 460


source("R/read_creaturedata.R")
source("R/cllc_levelup.R")
source("R/distribute_magicdust.R")
source("R/probcalculator_cleaned.R")

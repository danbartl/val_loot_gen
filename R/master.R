
source("R/load_lib_func.R")
source("R/set_parameters.R")

#No longer needed
source("R/prepare_creaturedata.R")
source("R/read_cllc_yaml.R")
source("R/add_levelupdata.R")
source("R/strength_to_magicdust.R")
source("R/lootdistribution.R")
source("R/generate_loottable.R")


inspect_dt <- creatures2[,.(name,stars,hp,effective_hp,movement_speed,attack_speed,damage,magic_dust)]
inspect_dt <- inspect_dt[,lapply(.SD,function(x) round(x,3)),by=.(name,stars)]
inspect_dt[name %like% "Troll$"]
inspect_dt[name %like% "Greydwarf$"]
inspect_dt[name %like% "Bonemass$"]
inspect_dt[name %like% "Deathsquito$"]
inspect_dt[name %like% "Wolf$"]


inspect_dt[,` `:=NA]
setcolorder(inspect_dt," ")



target_dt <- target_values[,.(name=tstrsplit(creature_id,"__")[[1]],stars=tstrsplit(creature_id,"__")[[2]] %>%  as.numeric,item_id,weight=lognorm_rounded)]
drops_dt <- drop_dt2[probabilities>0,.(name=tstrsplit(creature_id,"__")[[1]],stars=tstrsplit(creature_id,"__")[[2]] %>%  as.numeric,drops,probabilities)]


setorderv(drops_dt,c("name","stars"))
setorderv(target_dt,c("name","stars"))

target_cast <- dcast(target_dt,name+stars~item_id)
drops_cast <- dcast(drops_dt,name+stars~drops)

drops_cast[is.na(drops_cast)] <- 0

target_cast[,` `:=NA]
setcolorder(target_cast," ")

drops_cast[,` `:=NA]
setcolorder(drops_cast," ")
target_cast[,name:=factor(name,levels = c("Greydwarf","Wolf","Troll","GoblinKing"))]
drops_cast[,name:=factor(name,levels = c("Greydwarf","Wolf","Troll","GoblinKing"))]

setorderv(target_cast,c("name","stars"))
setorderv(drops_cast,c("name","stars"))

fwrite(inspect_dt[name %in% c("Troll","Greydwarf","Wolf","GoblinKing")],"data/output/examples/strength.csv",sep="|")
fwrite(target_cast[name %in% c("Troll","Greydwarf","Wolf","GoblinKing")],"data/output/examples/items.csv",sep="|")
fwrite(drops_cast[name %in% c("Troll","Greydwarf","Wolf","GoblinKing")],"data/output/examples/drops.csv",sep="|")


source("R/load_lib_func.R")
source("R/set_parameters.R")

#No longer needed
source("R/prepare_creaturedata.R")
source("R/read_cllc_yaml.R")
source("R/add_levelupdata.R")
source("R/distribute_magicdust.R")
source("R/probcalculator_cleaned.R")


inspect_dt <- creatures2[,.(name,stars,hp,effective_hp,movement_speed,attack_speed,damage,magic_dust)]
inspect_dt <- inspect_dt[,lapply(.SD,function(x) round(x,3)),by=.(name,stars)]
inspect_dt[name %like% "Troll$"]
inspect_dt[name %like% "Greydwarf$"]
inspect_dt[name %like% "Bonemass$"]
inspect_dt[name %like% "Deathsquito$"]
inspect_dt[name %like% "Wolf$"]


inspect_dt[,` `:=NA]
setcolorder(inspect_dt," ")

fwrite(inspect_dt[name %like% "Troll$"],"data/output/examples/troll.csv",sep="|")
fwrite(inspect_dt[name %like% "Greydwarf$"],"data/output/examples/greydwarf.csv",sep="|")
fwrite(inspect_dt[name %like% "Wolf$"],"data/output/examples/wolf.csv",sep="|")

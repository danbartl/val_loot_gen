
source("R/load_lib_func.R")
source("R/set_parameters.R")

#No longer needed
source("R/prepare_creaturedata.R")
source("R/read_cllc_yaml.R")
source("R/add_levelupdata.R")
source("R/distribute_magicdust.R")
source("R/probcalculator_cleaned.R")


inspect_dt <- creatures2[,.(name,stars,hp,effective_hp,movement_speed,attack_speed,damage,magic_dust)]
inspect_dt[name %like% "Troll$"]
inspect_dt[name %like% "Greydwarf$"]
inspect_dt[name %like% "Bonemass$"]
inspect_dt[name %like% "Deathsquito$"]
inspect_dt[name %like% "Wolf$"]


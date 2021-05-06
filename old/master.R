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

setwd("C:/temp/valheim/")

library(magrittr)
require(clipr)

creatures <- readxl::read_excel("C:/temp/valheim/creatures.xlsx") %>%  data.table
creatures %>% setnames(.,tolower(names(.))) %>%
  setnames(.,str_replace_all(names(.),"[^[:alnum:]]+","_")) %>%
  setnames(.,str_replace_all(names(.),"(^_)|(_$)","")) %>%
  setnames(.,stringi::stri_replace_all_fixed(names(.),
                                             c("ä", "ö", "ü", "Ä", "Ö", "Ü","ã","ã","ö","ä","ß"),
                                             c("ae", "oe", "ue", "Ae", "Oe", "Ue","ae","ae","oe","ae","ss"),
                                             vectorize_all = FALSE))

creatures[,(paste0("hp",1:3)):=tstrsplit(hp,"\\\r\\\n")]
creatures[,(paste0("dmg",1:3)):=tstrsplit(damage,"\\\r\\\n")]


creatures[,aoe:=fifelse(attack %ilike% "aoe",T,F)]
creatures[,heal:=fifelse(type %ilike% "heal|shield",T,F)]
creatures[,dot:=fifelse(type %ilike% "tick",T,F)]


creatures_short <- creatures[,.(name,type_behavior,hp1,dmg1,aoe,heal,dot,usual_biome)]
creatures_short[,multiattack:=str_detect(dmg1,"\\/|,")]
creatures_short[,speed:=1]
creatures_short[name =="Deathsquito",speed:=3]
creatures_short[name =="Wolf",speed:=2]
creatures_short[,dmg_edit:=str_replace_all(dmg1,"\\*| ","")]
creatures_short[,dmg_edit:=str_replace_all(dmg_edit,",","\\/")]
cdmg <- cbind(creatures_short[,.(name)],creatures_short[,tstrsplit(dmg_edit,"\\/")])
cdmg2 <- melt(cdmg,id.vars = "name")
cdmg3 <-cdmg2[,.(damage=max(as.numeric(value),na.rm=T)),by="name"]
cdmg3[damage<0,damage:=0]

creatures_short[,hp:=as.numeric(hp1)]
creatures_short[,hp1:=NULL]
creatures2a <- merge(creatures_short,cdmg3,by="name")
creatures2a[,damage_ranged:=0]
#fwrite(creatures2a,"C:/temp/valheim/creatures_edited.csv")

creatures2a <- fread("C:/temp/valheim/creatures_edited.csv")



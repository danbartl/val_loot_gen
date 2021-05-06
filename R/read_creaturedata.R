


creatures <- readxl::read_excel("rawdata/creatures.xlsx") %>%  data.table
creatures %>% setnames(.,tolower(names(.))) %>%
  setnames(.,str_replace_all(names(.),"[^[:alnum:]]+","_")) %>%
  setnames(.,str_replace_all(names(.),"(^_)|(_$)","")) %>%
  setnames(.,stringi::stri_replace_all_fixed(names(.),
                                             c("?", "?", "?", "?", "?", "?","?","?","?","?","?"),
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
creatures_edited <- merge(creatures_short,cdmg3,by="name")


creatures_edited["Eikthyr",damage:=30]
creatures_edited["The Elder",damage:=70]
creatures_edited["Bonemass",damage:=150]
creatures_edited["Moder",damage:=180]
creatures_edited["Yagluth",damage:=200]
creatures_edited[,movement_speed:=1]
creatures_edited[name=="Deathsquito",movement_speed:=2.5]
creatures_edited[name=="Wolf",movement_speed:=1.5]
creatures_edited[,attack_speed:=1]
creatures_edited[name=="Wolf",attack_speed:=1.5]
creatures_edited[,accuracy:=1]
creatures_edited[type_behavior=="Boss",accuracy:=2]
creatures_edited[name %in% c("Lox","Troll","Fuling Berserker"),accuracy:=2.2]
creatures_edited[name %in% c("Blob"),accuracy:=1.5]
creatures_edited[name %in% c("Lox"),accuracy:=2]
creatures_edited[name %in% c("Fuling Berserker"),accuracy:=1.8]
creatures_edited[name %in% c("Stone Golem"),accuracy:=1.6]
creatures_edited[name %in% c("Moder","Yagluth"),accuracy:=3]
creatures_edited[name=="Deathsquito",accuracy:=0.1]
creatures_edited[name=="Wolf",accuracy:=0.5]

fwrite(creatures_edited,"rawdata/creatures_modified.csv")

#creatures_editeda <- fread("C:/temp/valheim/creatures_edited.csv")



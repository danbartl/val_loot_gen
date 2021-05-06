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



creatures2[,hp_scaled:=(10+pmin(hp,200))^0.75]
creatures2[hp>200,hp_scaled:=hp_scaled+(10+hp-200)^0.5]






creatures2[,individual_scaler:=1]

creatures2[aoe==T,individual_scaler:=individual_scaler*1.1]
creatures2[heal==T,individual_scaler:=individual_scaler*1.1]
creatures2[dot==T,individual_scaler:=individual_scaler*1.25]
creatures2[,individual_scaler:=individual_scaler*speed]
creatures2[multiattack==T,individual_scaler :=individual_scaler*1.1]
creatures2[name %like% "Fuling",individual_scaler:=1.1]
creatures2["Lox",individual_scaler:=0.8]






creatures2[usual_biome=="Meadows",addon:=0]
creatures2[usual_biome=="Black Forest",addon:=10]
creatures2[usual_biome=="Swamp",addon:=20]
creatures2[usual_biome=="Mountain",addon:=30]
creatures2[usual_biome=="Plains",addon:=40]
creatures2[usual_biome=="Ocean",addon:=40]

#creatures2[,danger:=log(100+addon+as.numeric(hp1))*(individual_scaler*damage+addon)^1.5]

creatures2[,c("hp1","dmg1"):=.((10+addon+pmin(hp,200))^0.75,(individual_scaler*damage)^1.25)]
creatures2[,c("hp2","dmg2"):=.((10+addon+hp-200)^0.5,(individual_scaler*damage)^1.25)]
creatures2[ ,danger:=hp1*dmg1]
creatures2[hp1 >200,danger:=danger+hp2*dmg2]



creatures3 <- creatures2[order(danger)][!is.na(danger) & danger>0 & type_behavior!="Passive"] 

creatures3[,danger:=as.integer(danger/creatures3[,min(danger)])]


creatures2[order(danger)] %>%  tail(10) %>% .[,name]  %>%  print %>% clipr::write_clip()

creatures3[name!="Boar",.(name,danger,hp1,hp2,dmg1,dmg2)] %>% clipr::write_clip() %>%  print
#View(creatures2)

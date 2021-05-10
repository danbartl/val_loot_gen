cllc <- yaml::read_yaml("data/configuration/CreatureConfig.yml") 

cllc <- data.table(cllc_category=cllc,names=names(cllc))

cllc <- cllc[names !="groups"]

cllc_expand <- cbind(cllc[,.(cllc_category)],cllc[,tstrsplit(names,",")])


cllc_melt <- melt(cllc_expand,id.vars=c("cllc_category"))

cllc_melt <- cllc_melt[!is.na(value),!"variable",with=F]

cllc_melt[,attack:=list(list(cllc_category[[1]][["attack speed"]])),by=1:nrow(cllc_melt)]
cllc_melt[,movement:=list(list(cllc_category[[1]][["movement speed"]])),by=1:nrow(cllc_melt)]
cllc_melt[,health:=list(list(cllc_category[[1]][["health"]])),by=1:nrow(cllc_melt)]
cllc_melt[,damage:=list(list(cllc_category[[1]][["damage"]])),by=1:nrow(cllc_melt)]


attack <- cllc_melt[,unlist(attack),by=.(value)]
attack %>%  setnames(c("V1","value"),c("attack_speed","value"))
attack[,stars:=1:.N-1,by=value]

movement <- cllc_melt[,unlist(movement),by=.(value)]
movement %>%  setnames(c("V1","value"),c("movement_speed","value"))
movement[,stars:=1:.N-1,by=value]

health <- cllc_melt[,unlist(health),by=.(value)]
health %>%  setnames(c("V1","value"),c("health","value"))
health[,stars:=1:.N-1,by=value]

damage <- cllc_melt[,unlist(damage),by=.(value)]
damage %>%  setnames(c("V1","value"),c("damage","value"))
damage[,stars:=1:.N-1,by=value]


level_base <- data.table(stars=0:10)

level_all <- CJ.dt(level_base,attack[,.(value)] %>%  unique)

level_all <- attack[level_all,on=c("stars","value")]
level_all <- movement[level_all,on=c("stars","value")]
level_all <- health[level_all,on=c("stars","value")]
level_all <- damage[level_all,on=c("stars","value")]


level_melt <- melt(level_all,id.vars=c("stars","value"),value.name="setting")

level_melt[,setting:=na.locf(setting),by=.(value,variable)]

level_melt <- level_melt[!is.na(setting)]

level_cast <- dcast(level_melt,value+stars ~ variable,value.var = "setting")

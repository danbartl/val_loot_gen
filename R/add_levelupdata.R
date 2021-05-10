health_gained_per_star_for_bosses= 0.3
damage_gained_per_star_for_bosses= 0.2


creatures3 <- creatures_edited[,.(type_behavior,usual_biome,name)] %>%  unique




level <- CJ.dt(creatures3,level_base)

#First stats from biomes
#Which are then overwritten by creature stats
setnames(level,"usual_biome","value")
level[level_cast,attack_speed:=fifelse(is.na(i.attack_speed),attack_speed,i.attack_speed),on=c("value","stars")]
level[level_cast,movement_speed:=fifelse(is.na(i.movement_speed),movement_speed,i.movement_speed),on=c("value","stars")]
level[level_cast,health:=fifelse(is.na(i.health),health,i.health),on=c("value","stars")]
level[level_cast,damage:=fifelse(is.na(i.damage),damage,i.damage),on=c("value","stars")]

setnames(level,"value","usual_biome")
setnames(level,"name","value")

level[level_cast,attack_speed:=fifelse(is.na(i.attack_speed),attack_speed,i.attack_speed),on=c("value","stars")]
level[level_cast,movement_speed:=fifelse(is.na(i.movement_speed),movement_speed,i.movement_speed),on=c("value","stars")]
level[level_cast,health:=fifelse(is.na(i.health),health,i.health),on=c("value","stars")]
level[level_cast,damage:=fifelse(is.na(i.damage),damage,i.damage),on=c("value","stars")]

setnames(level,"value","name")

level[is.na(level)] <- 1


fwrite(level,"data/processed/cllc_levelup.csv")

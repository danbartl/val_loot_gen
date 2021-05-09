health_gained_per_star_for_bosses= 0.3
damage_gained_per_star_for_bosses= 0.2


creatures3 <- creatures_edited[,.(type_behavior,usual_biome,name)] %>%  unique


level_base <- data.table(stars=0:10)

level <- CJ.dt(creatures3,level_base)

#First stats from biomes
#Which are then overwritten by creature stats
setnames(level,"usual_biome","value")
level[attack,attack_speed:=i.attack_speed,on=c("value","stars")]
level[movement,movement_speed:=i.movement_speed,on=c("value","stars")]
level[health,health:=i.health,on=c("value","stars")]
level[damage,damage:=i.damage,on=c("value","stars")]


setnames(level,"value","usual_biome")
setnames(level,"name","value")

level[attack,attack_speed:=i.attack_speed,on=c("value","stars")]
level[movement,movement_speed:=i.movement_speed,on=c("value","stars")]
level[health,health:=i.health,on=c("value","stars")]
level[damage,damage:=i.damage,on=c("value","stars")]

setnames(level,"value","name")

level[,c("attack_speed","movement_speed","health","damage"):=lapply(.SD,na.locf),.SDcols=c("attack_speed","movement_speed","health","damage")]

fwrite(level,"data/processed/cllc_levelup.csv")

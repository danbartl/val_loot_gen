
CJ.dt <- function(X, Y) {
  k <- NULL
  X <- X[, c(k = 1, .SD)]
  setkey(X, k)
  Y <- Y[, c(k = 1, .SD)]
  setkey(Y, NULL)
  X[Y, allow.cartesian = TRUE][, `:=`(k, NULL)]
} 


health_gained_per_star_for_creatures=1
damage_gained_per_star_for_creatures=1

health_gained_per_star_for_bosses= 0.3
damage_gained_per_star_for_bosses= 0.2

level <- data.table(stars=0:10)
level <- CJ.dt(level,data.table(type_behavior=creatures2a[,unique(type_behavior)]))

level[type_behavior=="Aggressive",c("hp_boost","damage_boost"):=.(health_gained_per_star_for_creatures,
                                                                  damage_gained_per_star_for_creatures)]
level[type_behavior=="Boss",c("hp_boost","damage_boost"):=.(health_gained_per_star_for_bosses,
                                                            damage_gained_per_star_for_bosses)]


level[,c("hp_boost","damage_boost"):=.(1+hp_boost*stars,1+damage_boost*stars)]
#level[,c("move_boost","attack_boost"):=.(1+hp_boost*stars,1+damage_boost*stars)]


creatures2b <- creatures2a[!is.na(hp) & !is.na(damage) & type_behavior!="Passive"]


creatures2 <- merge(creatures2b,level,by=c("type_behavior"),all.x=T,allow.cartesian = T)

setkeyv(creatures2,"name")
hero_armor <- 80
hero_hp <- 100
 creatures2["Eikthyr",damage:=30]
 creatures2["The Elder",damage:=70]
 creatures2["Bonemass",damage:=150]
creatures2["Moder",damage:=180]
creatures2["Yagluth",damage:=200]
creatures2[,movement_speed:=1]
creatures2[name=="Deathsquito",movement_speed:=2.5]
creatures2[name=="Wolf",movement_speed:=1.5]
creatures2[,attack_speed:=1]
creatures2[name=="Wolf",attack_speed:=1.5]
#creatures2[name=="Blob",attack_speed:=1.5]
creatures2[,accuracy:=1]
creatures2[type_behavior=="Boss",accuracy:=2]
creatures2[name %in% c("Lox","Troll","Fuling Berserker"),accuracy:=2.2]
creatures2[name %in% c("Blob"),accuracy:=1.5]
creatures2[name %in% c("Lox"),accuracy:=2]
creatures2[name %in% c("Fuling Berserker"),accuracy:=1.8]
creatures2[name %in% c("Stone Golem"),accuracy:=1.6]
creatures2[name %in% c("Moder","Yagluth"),accuracy:=3]
creatures2[name=="Deathsquito",accuracy:=0.1]
creatures2[name=="Wolf",accuracy:=0.5]


creatures2[,hp:=hp_boost*hp]
creatures2[,damage:=damage_boost*damage]

creatures2[,scaled_hp:=(20+hp)/accuracy]

print(creatures2[name=="Yagluth"])



early_hero_armor <- 20
early_hero_damage <- 40
early_hero_hp <- 90

mid_hero_armor <- 80
mid_hero_damage <- 80
mid_hero_hp <- 140


end_hero_armor <- 200
end_hero_damage <- 150
end_hero_hp <- 460
#Which hero scenarios should be relevant?
#early, mid, end

hero_weight <- c(0.25,0.25,0.5)

creatures2[,early_damage:=0.5*damage^2/(early_hero_armor + 0.5 * damage)]
creatures2[,mid_damage:=0.5*damage^2/(mid_hero_armor + 0.5 * damage)]
creatures2[,end_damage:=0.5*damage^2/(end_hero_armor + 0.5 * damage)]

creatures2[,early_damage:=pmin(early_damage,early_hero_hp)]
creatures2[,mid_damage:=pmin(mid_damage,mid_hero_hp)]
creatures2[,end_damage:=pmin(end_damage,end_hero_hp)]

creatures2[,early_damage_byhero:=pmax(early_hero_damage,scaled_hp)]
creatures2[,mid_damage_byhero:=pmax(mid_hero_damage,scaled_hp)]
creatures2[,end_damage_byhero:=pmax(end_hero_damage,scaled_hp)]

creatures2[,effective_hp:=hero_weight[1]*early_damage_byhero+hero_weight[2]*mid_damage_byhero+hero_weight[3]*end_damage_byhero]

# 
# creatures2[,damage_weighted:=pmax(hero_weight[1]*0.5*damage^2/(early_hero_armor + 0.5 * damage)
#            +hero_weight[2]*0.5*damage^2/(mid_hero_armor + 0.5 * damage)
#            +hero_weight[3]*0.5*damage^2/(mid_hero_hp + 0.5 * damage)]



creatures2[,hits_to_kill:=hero_weight[1]*early_hero_hp/early_damage
           +hero_weight[2]*mid_hero_hp/mid_damage
           +hero_weight[3]*end_hero_hp/end_damage]

creatures2[,hits_to_kill_scaled:=hits_to_kill/(movement_speed*attack_speed)]


creatures2[,danger:=1/hits_to_kill_scaled*effective_hp]
creatures2[,danger:=ceiling(danger/creatures2[,min(danger)])]

setorderv(creatures2,"danger")

creatures2[aoe==T,danger:=danger*1.25]
creatures2[dot==T & heal != T,danger:=danger*1.5]
creatures2[heal==T ,danger:=danger*2]
creatures2[multiattack==T,danger :=danger*1.1]
creatures2[type_behavior=="Boss",danger :=danger*1.5]

creatures2[,legendaries:=5*danger/creatures2[,max(danger)]]
creatures2[,rare:=legendaries*1000]
creatures2[,.(name,danger,damage,hits_to_kill,hp,effective_hp,stars,rare)] %>% clipr::write_clip() %>%  View
setorderv(creatures2,"danger")
creatures2[stars <= 2,.(name,danger,damage,hits_to_kill,hp,effective_hp,stars,rare=round(rare,2))] %>% clipr::write_clip() %>%  View
creatures2[stars <= 2,.(name,danger,damage,hits_to_kill,hp,effective_hp,stars,rare=round(rare,2))]%>% clipr::write_clip() 
creatures2[stars <= 2,.(name,stars,magic_dust=round(rare,2))]%>% clipr::write_clip() 

c3 <- creatures2[stars <= 2,.(name,stars,hp,magic_dust=round(rare/2,2))]


fwrite(c3,"C:/temp/valheim/draft.csv",sep="|")

#damage <- 700
#0.5*damage^2/(200 + 0.5 * damage)

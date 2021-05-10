


level <- fread("data/processed/cllc_levelup.csv")

creatures_edited <- fread("data/configuration/base_creatures.csv")

creatures_edited[usual_biome %like% "Meadows",progression:=1]
creatures_edited[usual_biome %like% "Black Forest",progression:=2]
creatures_edited[usual_biome %like% "Swamp",progression:=3]
creatures_edited[usual_biome %like% "Mountain",progression:=4]
creatures_edited[usual_biome %like% "Ocean",progression:=3]
creatures_edited[usual_biome %like% "Plains",progression:=5]

creatures_edited[,hero_min_damage:=25+(progression-1)*30]



#Currently no passive loottables

creatures2b <- creatures_edited[!is.na(health) & !is.na(damage) & type_behavior!="Passive"]

creatures2 <- merge(creatures2b,level,by=c("name"),all.x=T,allow.cartesian = T,suffixes=c("","_boost"))

creatures2[is.na(attack_speed_boost)]


#creatures2[,.N,by=.(usual_biome)]
setkeyv(creatures2,"name")


creatures2[,hp:=health_boost*health]
creatures2[,damage:=damage_boost*damage]
creatures2[,movement_speed:=exp(movement_speed_boost-1)*movement_speed]
creatures2[,attack_speed:=exp(attack_speed_boost-1)*attack_speed]


creatures2[,scaled_hp:=hp/accuracy]


creatures2[,early_damage:=10+0.5*damage^2/(early_hero_armor + 0.5 * damage)]
creatures2[,mid_damage:=10+0.5*damage^2/(mid_hero_armor + 0.5 * damage)]
creatures2[,end_damage:=10+0.5*damage^2/(end_hero_armor + 0.5 * damage)]

creatures2[,early_damage:=pmin(early_damage,early_hero_hp)]
creatures2[,mid_damage:=pmin(mid_damage,mid_hero_hp)]
creatures2[,end_damage:=pmin(end_damage,end_hero_hp)]

# creatures2[,early_damage_byhero:=pmax(early_hero_damage,scaled_hp)]
# creatures2[,mid_damage_byhero:=pmax(mid_hero_damage,scaled_hp)]
# creatures2[,end_damage_byhero:=pmax(end_hero_damage,scaled_hp)]
# 
# creatures2[,effective_hp:=hero_weight[1]*early_damage_byhero+hero_weight[2]*mid_damage_byhero+hero_weight[3]*end_damage_byhero]

creatures2[,effective_hp:=pmax(scaled_hp,hero_min_damage)]

creatures2[,hits_to_kill:=hero_weight[1]*early_hero_hp/early_damage
           +hero_weight[2]*mid_hero_hp/mid_damage
           +hero_weight[3]*end_hero_hp/end_damage]

#creatures2[,hits_to_kill_scaled:=hits_to_kill/(movement_speed*attack_speed)]

creatures2[,danger:=1/hits_to_kill*effective_hp*movement_speed*attack_speed]
creatures2[,danger:=danger/creatures2[,min(danger)]]

setorderv(creatures2,"danger")

creatures2[aoe==T,danger:=danger*1.25]
creatures2[dot==T & heal != T,danger:=danger*1.5]
creatures2[heal==T ,danger:=danger*2]
creatures2[multiattack==T,danger :=danger*1.1]
creatures2[type_behavior=="Boss",danger :=danger*1.5]

creatures2[,legendaries:=legendary_count*danger/creatures2[,max(danger)]]
creatures2[,rare:=legendaries*conversion_enchantmats^(tiers-1)]

setorderv(creatures2,"danger")


creatures_to_dust <- creatures2[,.(name,stars,hp,effective_hp,damage,rare=round(rare,5),magic_dust=round(0.1+rare,5))]

# creatures_to_dust %>%  tail(100)
# creatures_to_dust %>%  head(100)
# creatures2 %>%  View

fwrite(creatures_to_dust,"data/processed/creatures_to_dust.csv")




level <- fread("rawdata/cllc_levelup.csv")

creatures_edited <- fread("rawdata/creatures_modified.csv")

#Currently no passive loottables

creatures2b <- creatures_edited[!is.na(hp) & !is.na(damage) & type_behavior!="Passive"]

creatures2 <- merge(creatures2b,level,by=c("type_behavior"),all.x=T,allow.cartesian = T)

setkeyv(creatures2,"name")


creatures2[,hp:=hp_boost*hp]
creatures2[,damage:=damage_boost*damage]
creatures2[,scaled_hp:=hp/accuracy]


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

creatures2[,legendaries:=legendary_count*danger/creatures2[,max(danger)]]
creatures2[,rare:=legendaries*conversion_enchantmats^(tiers-1)]

setorderv(creatures2,"danger")


creatures_to_dust <- creatures2[,.(name,stars,hp,damage,magic_dust=fifelse(rare<1,0.1+ceiling(rare^0.5*100)/100,0.1+rare))]

creatures_to_dust %>%  tail(100)
creatures_to_dust %>%  head(100)

fwrite(creatures_to_dust,"rawdata/creatures_to_dust.csv")




level <- fread("data/processed/cllc_levelup.csv")

creatures_edited <- fread("data/configuration/base_creatures.csv")



#Currently no passive loottables

creatures2b <- creatures_edited[!is.na(health) & !is.na(damage) & type_behavior!="Passive"]

creatures2 <- merge(creatures2b,level,by=c("name"),all.x=T,allow.cartesian = T,suffixes=c("","_boost"))

setkeyv(creatures2,"name")

#Scale with CLLC level up boosts
creatures2[,hp:=health_boost*health]
creatures2[,damage:=damage_boost*damage]
creatures2[,movement_speed:=exp(movement_speed_boost-1)*movement_speed]
creatures2[,attack_speed:=exp(attack_speed_boost-1)*attack_speed]

#Adjust hp for slow / buggy pathfinding creatures
creatures2[,scaled_hp:=hp/accuracy]

#Set min damage of hero 25 + 30 per each biome after Meadows
creatures2[usual_biome == "Meadows",progression:=1]
creatures2[usual_biome == "Black Forest",progression:=2]
creatures2[usual_biome == "Swamp",progression:=3]
creatures2[usual_biome == "Mountain",progression:=4]
creatures2[usual_biome == "Ocean",progression:=3]
creatures2[usual_biome == "Plains",progression:=5]
creatures2[,hero_min_damage:=25+(progression-1)*30]

#Adjust creature hp according to min damage of hero
#Whether creature has 5 or 20 hp does not matter when hero deals 30 damage
creatures2[,effective_hp:=pmax(scaled_hp,hero_min_damage)]

#Damage taken according to Combat Overhaul armor formula
creatures2[,early_damage:=10+0.5*damage^2/(early_hero_armor + 0.5 * damage)]
creatures2[,mid_damage:=10+0.5*damage^2/(mid_hero_armor + 0.5 * damage)]
creatures2[,end_damage:=10+0.5*damage^2/(end_hero_armor + 0.5 * damage)]

#Cap at hero hp for each scenario
creatures2[,early_damage:=pmin(early_damage,early_hero_hp)]
creatures2[,mid_damage:=pmin(mid_damage,mid_hero_hp)]
creatures2[,end_damage:=pmin(end_damage,end_hero_hp)]

#Hits to kill based on scenario weight set in config (end game typically most important)
creatures2[,hits_to_kill:=hero_weight[1]*early_hero_hp/early_damage
           +hero_weight[2]*mid_hero_hp/mid_damage
           +hero_weight[3]*end_hero_hp/end_damage]

#Danger formula
creatures2[,danger:=1/hits_to_kill*effective_hp*movement_speed*attack_speed]

#Scaling to one
creatures2[,danger:=danger/creatures2[,min(danger)]]

setorderv(creatures2,"danger")

#Add ons for aoe, dot, heal, multiattak, boss
creatures2[aoe==T,danger:=danger*1.25]
creatures2[dot==T & heal != T,danger:=danger*1.5]
creatures2[heal==T ,danger:=danger*2]
creatures2[multiattack==T,danger :=danger*1.1]
creatures2[type_behavior=="Boss",danger :=danger*1.5]

#Define legendaries as reference for highest danger creature
#Highest danger creature will get full legendary drop
#Might change to fixed reference (e.g. GoblinKing 10 starts)
creatures2[,legendaries:=legendary_count*danger/creatures2[,max(danger)]]

#Convert back to single magic dust
creatures2[,magic_dust:=legendaries*conversion_enchantmats^(tiers-1)]

#Set minimum dust to 0.1
creatures2[,magic_dust:=round(0.1+magic_dust,5)]

setorderv(creatures2,"danger")

creatures_to_dust <- creatures2[,.(name,stars,health,attack_speed,movement_speed,damage,magic_dust)]

# creatures_to_dust %>%  tail(100)
# creatures_to_dust %>%  head(100)
# creatures2 %>%  View

fwrite(creatures_to_dust,"data/processed/creatures_to_dust.csv")

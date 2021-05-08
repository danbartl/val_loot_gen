
health_gained_per_star_for_creatures=1
damage_gained_per_star_for_creatures=1

health_gained_per_star_for_bosses= 0.3
damage_gained_per_star_for_bosses= 0.2

level <- data.table(stars=0:10)
level <- CJ.dt(level,data.table(type_behavior=c("Aggressive","Boss","Passive")))

level[type_behavior=="Aggressive",c("hp_boost","damage_boost"):=.(health_gained_per_star_for_creatures,
                                                                  damage_gained_per_star_for_creatures)]
level[type_behavior=="Boss",c("hp_boost","damage_boost"):=.(health_gained_per_star_for_bosses,
                                                            damage_gained_per_star_for_bosses)]


level[,c("hp_boost","damage_boost"):=.(1+hp_boost*stars,1+damage_boost*stars)]


fwrite(level,"rawdata/cllc_levelup.csv")

creatures_to_dust

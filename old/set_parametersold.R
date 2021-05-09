
#Specify the ratio of conversion


to_yaml <- list(enchantcosts=list(conversion_rate=5,tiers=4)
     ,drop_count=list(min_expected_drops=0.2,max_expected_drops=10)
     ,drop_value=list(legendary_for_strongest=8)
     ,hero=list(scenario_weight=list(early=0.25,mid=0.25,end=0.5),
                early_stats=list(armor=20,damage=15,health=90),
                mid_stats=list(armor=80,damage=60,health=140),
                end_stats=list(armor=200,damage=140,health=460)
                ))
yaml::write_yaml(to_yaml,"data/configuration/config.yaml")

config <- yaml::read_yaml("data/configuration/config.yaml")

conversion_enchantmats <- config[["enchantcosts"]][["conversion_rate"]]
#from lowest to highest rarity across four tiers
tiers <- config[["enchantcosts"]][["tiers"]]

#Drops are scaled linearly from weakest to strongest creeature
expected_drops <- c(config[["drop_count"]][["min_expected_drops"]],
                    config[["drop_count"]][["max_expected_drops"]])

#How many legendaries should you get for highest difficulty mob
legendary_count <- config[["drop_value"]][["legendary_for_strongest"]]

#Which hero scenarios should be relevant?
#early, mid, end
hero_weight <- c(config[["hero"]][["scenario_weight"]][["early"]]
                 ,config[["hero"]][["scenario_weight"]][["mid"]],
                 config[["hero"]][["scenario_weight"]][["end"]])

early_hero_armor <- config[["hero"]][["early_stats"]][["armor"]]
early_hero_damage <- config[["hero"]][["early_stats"]][["damage"]]
early_hero_hp <- config[["hero"]][["early_stats"]][["health"]]

mid_hero_armor <- config[["hero"]][["mid_stats"]][["armor"]]
mid_hero_damage <- config[["hero"]][["mid_stats"]][["damage"]]
mid_hero_hp <- config[["hero"]][["mid_stats"]][["health"]]

end_hero_armor <- config[["hero"]][["end_stats"]][["armor"]]
end_hero_damage <- config[["hero"]][["end_stats"]][["damage"]]
end_hero_hp <- config[["hero"]][["end_stats"]][["health"]]



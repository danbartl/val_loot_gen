
config <- yaml::read_yaml("data/configuration/config.yml")

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

#Which hero parameters shall be used?
#Scales damage of creatures based on armor

early_hero_armor <- config[["hero"]][["early_stats"]][["armor"]]
early_hero_damage <- config[["hero"]][["early_stats"]][["damage"]]
early_hero_hp <- config[["hero"]][["early_stats"]][["health"]]

mid_hero_armor <- config[["hero"]][["mid_stats"]][["armor"]]
mid_hero_damage <- config[["hero"]][["mid_stats"]][["damage"]]
mid_hero_hp <- config[["hero"]][["mid_stats"]][["health"]]

end_hero_armor <- config[["hero"]][["end_stats"]][["armor"]]
end_hero_damage <- config[["hero"]][["end_stats"]][["damage"]]
end_hero_hp <- config[["hero"]][["end_stats"]][["health"]]



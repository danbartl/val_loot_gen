## Features
* Read a CLLC YAML file
* Read creature basic data (currently only vanilla, but easily configurable to add other e.g. RRR NPCS) bosses are not yet fully implemented
* Calculate creature strength taking into account multiple factors
* Generate full distribution of drops and loot (currently following EpicLoot "crafting approach" to only specify enchanting materials)
* * Discretized Gamma distribution for drops
* * Discretized Log Normal Distribution for Loot Table Weight
* Export loottables.json that can be copied for use in Epi Loot (currently only creatures)

## Instructions:
* Just adjust everything in the data/configuration folder
* * Drop your CLLC YAML file here
* * * Currently only single file is supported
* * * Currently only health, damage, movement speed and attack speed are supported
* * Adjust base stats for you creatures in base_creatures.csv
* * Adjust other settings in config.yaml
* You can inspect intermediate results in data/processed
* Run master.R and take the loottable file from data/output and put it into your game folder. Currently only available as R scripts, so you need R and ideally Rstudio 
* * https://cran.r-project.org/
* * https://www.rstudio.com/products/rstudio/download/#download

## TODO

- [ ] Add more CLLC keywords
- [ ] Read from CLLC config
- [ ] Include danger scaling for resistances, infusions, effects
- [ ] Include treasure chests
- [ ] Allow for different items than enchanting materiaks


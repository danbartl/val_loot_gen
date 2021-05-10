## Features

* Turn creature stats into fully adjustable EpicLoot loottable
    * Inludes automatic reading of CLLC yml
    * Automatic export of generated loottables.json

* Generate full distribution of drops and loot 
  * Takes into account creature strength
  * Discretized Gamma distribution for drops
  * Discretized Log Normal Distribution for Loot Table Weight


## Instructions:
* Just adjust everything in the data/configuration folder
  * Set general parameters in config.yml
  * Drop your CLLC YAML file here
    * Currently only single file is supported
    * Currently only health, damage, movement speed and attack speed are supported
  * Adjust base stats for you creatures in base_creatures.csv
* You can inspect intermediate results in data/processed
  * You can find resulting creature level up table in data/processed/creatures_to_dust.csv
  * You can find resulting creature strength table in data/processed/creatures_to_dust.csv
* Run master.R and take the loottable file from data/output and put it into your game folder. Currently only available as R scripts, so you need R and ideally Rstudio 
  * https://cran.r-project.org/
  * https://www.rstudio.com/products/rstudio/download/#download

## TODO

- [ ] Add more CLLC keywords
- [ ] Read from CLLC config
- [ ] Include danger scaling for resistances, infusions, effects
- [ ] Include treasure chests
- [ ] Allow for different items than enchanting materiaks


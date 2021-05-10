## Features

* Turn creature stats into fully adjustable EpicLoot loottable
    * Inludes automatic reading of CLLC yml
    * Automatic export of generated loottables.json
    * See strength/loot conversion formula in R/distribute_magicdust.R

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
  * You can find resulting creature level up table in data/processed/cllc_levelup.csv
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

## Examples

Troll
|name|stars|hp|effective_hp|movement_speed|attack_speed|damage|magic_dust
|Troll|0|600|400|0.8|1|70|0.458
|Troll|1|1200|800|0.833|1.051|105|1.326
|Troll|2|1800|1200|0.849|1.105|140|2.933
|Troll|3|2100|1400|0.929|1.221|175|5.468
|Troll|4|2400|1600|0.977|1.221|210|8.329
|Troll|5|2580|1720|1.193|1.649|245|17.804
|Troll|6|2760|1840|1.458|2.226|280|36.62
|Troll|7|2940|1960|1.458|2.718|315|54.344
|Troll|8|3120|2080|1.458|2.718|350|64.566
|Troll|9|3300|2200|1.458|2.718|385|75.286
|Troll|10|3600|2400|1.458|2.718|420|89.406

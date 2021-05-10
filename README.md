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

Greydwarf
|name|stars|hp|effective_hp|movement_speed|attack_speed|damage|magic_dust
|--|--|--|--|--|--|--|--|
|Greydwarf|0|40|55|1|1|14|0.129
|Greydwarf|1|80|80|1.041|1.051|21|0.15
|Greydwarf|2|120|120|1.062|1.051|28|0.183
|Greydwarf|3|140|140|1.083|1.105|35|0.214
|Greydwarf|4|160|160|1.162|1.105|42|0.254
|Greydwarf|5|172|172|1.284|1.221|49|0.324
|Greydwarf|6|184|184|1.35|1.35|56|0.407
|Greydwarf|7|196|196|1.419|1.419|63|0.5
|Greydwarf|8|208|208|1.462|1.462|70|0.597
|Greydwarf|9|220|220|1.462|1.462|77|0.678
|Greydwarf|10|240|240|1.462|1.462|84|0.792

Wolf
|name|stars|hp|effective_hp|movement_speed|attack_speed|damage|magic_dust
|--|--|--|--|--|--|--|--|
|Wolf|0|80|115|1.5|1.4|70|0.345
|Wolf|1|160|200|1.561|1.472|105|0.831
|Wolf|2|240|300|1.593|1.472|140|1.708
|Wolf|3|280|350|1.625|1.547|175|2.802
|Wolf|4|320|400|1.743|1.547|210|4.326
|Wolf|5|344|430|1.926|1.71|245|6.835
|Wolf|6|368|460|2.025|1.89|280|9.89
|Wolf|7|392|490|2.129|1.987|315|13.257
|Wolf|8|416|520|2.193|2.047|350|16.704
|Wolf|9|440|550|2.193|2.047|385|19.464
|Wolf|10|480|600|2.193|2.047|420|23.101

Troll
|name|stars|hp|effective_hp|movement_speed|attack_speed|damage|magic_dust
|--|--|--|--|--|--|--|--|
|Troll|0|600|428.571|0.8|1|70|0.483
|Troll|1|1200|857.143|0.833|1.051|105|1.413
|Troll|2|1800|1285.714|0.849|1.105|140|3.135
|Troll|3|2100|1500|0.929|1.221|175|5.852
|Troll|4|2400|1714.286|0.977|1.221|210|8.917
|Troll|5|2580|1842.857|1.193|1.649|245|19.069
|Troll|6|2760|1971.429|1.458|2.226|280|39.229
|Troll|7|2940|2100|1.458|2.718|315|58.218
|Troll|8|3120|2228.571|1.458|2.718|350|69.171
|Troll|9|3300|2357.143|1.458|2.718|385|80.656
|Troll|10|3600|2571.429|1.458|2.718|420|95.785
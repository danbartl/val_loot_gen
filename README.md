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
- [ ] Improve discretization, currently the actual values underestimate, especially for low danger creatures

## Examples

Greydwarf, Wolf Troll

Strength
|name|stars|hp|effective_hp|movement_speed|attack_speed|damage|magic_dust
|--|--|--|--|--|--|--|--|
|Greydwarf|0|40|55|1|1|14|0.129
|Greydwarf|1|80|80|1.041|1.051|21|0.15
|Greydwarf|2|120|120|1.062|1.051|28|0.183
|Greydwarf|3|140|140|1.083|1.105|35|0.214
|Greydwarf|4|160|160|1.162|1.105|42|0.254
|Greydwarf|5|172|172|1.284|1.221|49|0.324
|Wolf|0|80|115|1.5|1.4|70|0.345
|Greydwarf|6|184|184|1.35|1.35|56|0.407
|Troll|0|600|428.571|0.8|1|70|0.483
|Greydwarf|7|196|196|1.419|1.419|63|0.5
|Greydwarf|8|208|208|1.462|1.462|70|0.597
|Greydwarf|9|220|220|1.462|1.462|77|0.678
|Greydwarf|10|240|240|1.462|1.462|84|0.792
|Wolf|1|160|200|1.561|1.472|105|0.831
|Troll|1|1200|857.143|0.833|1.051|105|1.413
|Wolf|2|240|300|1.593|1.472|140|1.708
|Wolf|3|280|350|1.625|1.547|175|2.802
|Troll|2|1800|1285.714|0.849|1.105|140|3.135
|Wolf|4|320|400|1.743|1.547|210|4.326
|Troll|3|2100|1500|0.929|1.221|175|5.852
|Wolf|5|344|430|1.926|1.71|245|6.835
|Troll|4|2400|1714.286|0.977|1.221|210|8.917
|Wolf|6|368|460|2.025|1.89|280|9.89
|Wolf|7|392|490|2.129|1.987|315|13.257
|Wolf|8|416|520|2.193|2.047|350|16.704
|Troll|5|2580|1842.857|1.193|1.649|245|19.069
|Wolf|9|440|550|2.193|2.047|385|19.464
|GoblinKing|0|10000|4000|1|1|200|22.124
|Wolf|10|480|600|2.193|2.047|420|23.101
|Troll|6|2760|1971.429|1.458|2.226|280|39.229
|Troll|7|2940|2100|1.458|2.718|315|58.218
|Troll|8|3120|2228.571|1.458|2.718|350|69.171
|GoblinKing|1|20000|8000|1.041|1.051|300|79.075
|Troll|9|3300|2357.143|1.458|2.718|385|80.656
|Troll|10|3600|2571.429|1.458|2.718|420|95.785
|GoblinKing|2|30000|12000|1.062|1.051|400|163.726
|GoblinKing|3|35000|14000|1.083|1.105|500|251.486
|GoblinKing|4|40000|16000|1.162|1.105|600|357.021
|GoblinKing|5|43000|17200|1.284|1.221|700|523.127
|GoblinKing|6|46000|18400|1.35|1.35|800|653.41
|GoblinKing|7|49000|19600|1.419|1.419|900|769.208
|GoblinKing|8|52000|20800|1.462|1.462|1000|866.767
|GoblinKing|9|55000|22000|1.462|1.462|1100|916.767
|GoblinKing|10|60000|24000|1.462|1.462|1200|1000.1


Drop Count
|name|stars|hp|effective_hp|movement_speed|attack_speed|damage|magic_dust
|--|--|--|--|--|--|--|--|
|Greydwarf|0|0.95|0.03|0.01|0|0|0|0|0|0|0|0|0|0|0|0
|Greydwarf|1|0.95|0.04|0.01|0|0|0|0|0|0|0|0|0|0|0|0
|Greydwarf|2|0.94|0.05|0.01|0|0|0|0|0|0|0|0|0|0|0|0
|Greydwarf|3|0.93|0.05|0.01|0|0|0|0|0|0|0|0|0|0|0|0
|Greydwarf|4|0.92|0.06|0.01|0|0|0|0|0|0|0|0|0|0|0|0
|Greydwarf|5|0.92|0.06|0.01|0|0|0|0|0|0|0|0|0|0|0|0
|Greydwarf|6|0.91|0.08|0.01|0|0|0|0|0|0|0|0|0|0|0|0
|Greydwarf|7|0.89|0.09|0.02|0|0|0|0|0|0|0|0|0|0|0|0
|Greydwarf|8|0.89|0.1|0.02|0|0|0|0|0|0|0|0|0|0|0|0
|Greydwarf|9|0.88|0.1|0.02|0|0|0|0|0|0|0|0|0|0|0|0
|Greydwarf|10|0.87|0.11|0.02|0|0|0|0|0|0|0|0|0|0|0|0
|Wolf|0|0.92|0.07|0.01|0|0|0|0|0|0|0|0|0|0|0|0
|Wolf|1|0.86|0.12|0.02|0|0|0|0|0|0|0|0|0|0|0|0
|Wolf|2|0.84|0.14|0.02|0|0|0|0|0|0|0|0|0|0|0|0
|Wolf|3|0.74|0.23|0.02|0|0|0|0|0|0|0|0|0|0|0|0
|Wolf|4|0.65|0.32|0.03|0|0|0|0|0|0|0|0|0|0|0|0
|Wolf|5|0.51|0.44|0.05|0|0|0|0|0|0|0|0|0|0|0|0
|Wolf|6|0.4|0.54|0.07|0|0|0|0|0|0|0|0|0|0|0|0
|Wolf|7|0.22|0.66|0.11|0.01|0|0|0|0|0|0|0|0|0|0|0
|Wolf|8|0.11|0.7|0.18|0.01|0|0|0|0|0|0|0|0|0|0|0
|Wolf|9|0.09|0.7|0.2|0.01|0|0|0|0|0|0|0|0|0|0|0
|Wolf|10|0.03|0.63|0.32|0.02|0|0|0|0|0|0|0|0|0|0|0
|Troll|0|0.9|0.09|0.02|0|0|0|0|0|0|0|0|0|0|0|0
|Troll|1|0.81|0.17|0.02|0|0|0|0|0|0|0|0|0|0|0|0
|Troll|2|0.7|0.28|0.03|0|0|0|0|0|0|0|0|0|0|0|0
|Troll|3|0.6|0.37|0.04|0|0|0|0|0|0|0|0|0|0|0|0
|Troll|4|0.45|0.49|0.06|0|0|0|0|0|0|0|0|0|0|0|0
|Troll|5|0.11|0.7|0.19|0.01|0|0|0|0|0|0|0|0|0|0|0
|Troll|6|0|0.32|0.6|0.08|0|0|0|0|0|0|0|0|0|0|0
|Troll|7|0|0.05|0.65|0.28|0.01|0|0|0|0|0|0|0|0|0|0
|Troll|8|0|0.02|0.54|0.42|0.03|0|0|0|0|0|0|0|0|0|0
|Troll|9|0|0.01|0.43|0.52|0.04|0|0|0|0|0|0|0|0|0|0
|Troll|10|0|0|0.2|0.67|0.13|0|0|0|0|0|0|0|0|0|0
|GoblinKing|0|0.04|0.66|0.28|0.02|0|0|0|0|0|0|0|0|0|0|0
|GoblinKing|1|0|0.01|0.4|0.55|0.05|0|0|0|0|0|0|0|0|0|0
|GoblinKing|2|0|0|0|0.17|0.68|0.15|0|0|0|0|0|0|0|0|0
|GoblinKing|3|0|0|0|0|0.07|0.65|0.27|0.01|0|0|0|0|0|0|0
|GoblinKing|4|0|0|0|0|0|0.02|0.51|0.45|0.02|0|0|0|0|0|0
|GoblinKing|5|0|0|0|0|0|0|0|0.05|0.6|0.35|0.01|0|0|0|0
|GoblinKing|6|0|0|0|0|0|0|0|0|0.01|0.32|0.61|0.06|0|0|0
|GoblinKing|7|0|0|0|0|0|0|0|0|0|0|0.28|0.64|0.08|0|0
|GoblinKing|8|0|0|0|0|0|0|0|0|0|0|0|0.26|0.65|0.09|0
|GoblinKing|9|0|0|0|0|0|0|0|0|0|0|0|0.06|0.63|0.31|0.01
|GoblinKing|10|0|0|0|0|0|0|0|0|0|0|0|0|0.14|0.68|0.18

Items
|name|stars|hp|effective_hp|movement_speed|attack_speed|damage|magic_dust
|--|--|--|--|--|--|--|--|
|Greydwarf|0|95|5|0|0
|Greydwarf|1|94|6|0|0
|Greydwarf|2|91|9|0|0
|Greydwarf|3|89|11|0|0
|Greydwarf|4|85|15|0|0
|Greydwarf|5|80|19|1|0
|Greydwarf|6|73|26|1|0
|Greydwarf|7|69|30|1|0
|Greydwarf|8|62|36|2|0
|Greydwarf|9|64|34|2|0
|Greydwarf|10|58|39|3|0
|Wolf|0|78|21|1|0
|Wolf|1|56|41|3|0
|Wolf|2|35|55|9|1
|Wolf|3|25|59|15|1
|Wolf|4|18|60|20|2
|Wolf|5|14|59|24|3
|Wolf|6|13|58|25|4
|Wolf|7|12|57|27|4
|Wolf|8|12|57|27|4
|Wolf|9|10|56|29|5
|Wolf|10|9|55|31|5
|Troll|0|70|29|1|0
|Troll|1|41|52|7|0
|Troll|2|23|60|16|1
|Troll|3|16|59|22|3
|Troll|4|13|58|25|4
|Troll|5|11|56|28|5
|Troll|6|6|49|37|8
|Troll|7|5|45|40|10
|Troll|8|4|42|42|12
|Troll|9|3|40|43|14
|Troll|10|3|38|44|15
|GoblinKing|0|10|55|30|5
|GoblinKing|1|3|41|43|13
|GoblinKing|2|1|30|47|22
|GoblinKing|3|1|24|47|28
|GoblinKing|4|1|19|46|34
|GoblinKing|5|0|15|44|41
|GoblinKing|6|0|13|42|45
|GoblinKing|7|0|11|41|48
|GoblinKing|8|0|10|40|50
|GoblinKing|9|0|9|39|52
|GoblinKing|10|0|9|38|53
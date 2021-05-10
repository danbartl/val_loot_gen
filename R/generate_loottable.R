
valheim_loot6 <- target_values[lognorm_rounded >0,.(Loot=combineListsAsOne(Loot)),by=.(Object,Level)]

valheim_loot61 <- merge(valheim_loot6,valheim_melt2,by=c("Object","Level"))

valheim_loot7 <- valheim_loot61[,.(LeveledLoot=
                                     list(
                                       list(Level=Level,
                                            Drops=Drops %>%  as.list %>% .[[1]],
                                            Loot=Loot[[1]]))
),by=.(Object,Level)]

valheim_loot8 <- valheim_loot7[,.(LeveledLoot=combineListsAsOne(LeveledLoot)),by=.(Object)]

valheim_loot8[,full:=list(list(list(Object=Object,LeveledLoot=LeveledLoot[[1]])  %>%  as.list)),by=.(Object)]
valheim_loot9 <- valheim_loot8[,combineListsAsOne(full)][[1]]


valheim_export <- valheim_loot9  %>%  RJSONIO::toJSON(pretty=TRUE) 
#roux <- valheim_loot8[1,list(list(Object=Object,LeveledLoot=LeveledLoot)),by=.(Object)] %>%  RJSONIO::toJSON() 
#roux
require("readr")

mystring <- read_file("data/raw/loottables_077_edited.json")
valheim_export <- substring(valheim_export,4,nchar(valheim_export)-2)
# 
mystring <- str_replace_all(mystring,"INSERTLOOT",valheim_export)
# 
write(mystring, "data/output/loottables.json")

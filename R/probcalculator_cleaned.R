
creatures_to_dust <- fread("data/raw/creatures_to_dust.csv")

drop_base <- creatures_to_dust[,.(creature_id=paste0(name,"__",stars),magic_dust)] %>%  unique
drop_base[,expected_count:=seq(expected_drops[1],expected_drops[2],length.out=.N)]


count_dt<- data.table(drops=0:(ceiling(max(expected_drops)*1.5)))

drop_dt <- CJ.dt(drop_base,count_dt)

setorderv(drop_dt,"creature_id")


drop_dt[,drops_lower:=drops-0.5]
drop_dt[,drops_upper:=shift(drops %>%  as.numeric,type="lead",fill=Inf)-0.5,by=.(creature_id)]


drop_dt[,density:=pgamma(drops_upper,shape=expected_count*expected_count ,rate=expected_count )-pgamma(drops_lower,shape=expected_count*expected_count ,rate=expected_count )]
drop_dt[,probabilities:=smart.round(density*100)/100]


target <- drop_dt[,.(actual_count=sum(probabilities*drops)),by=.(magic_dust,creature_id)]
target[,expected_value:=magic_dust/actual_count]
target[,sdlog:=1]
target[,meanlog:=log(expected_value)-sdlog^2/2]

value_dt <- data.table(item_id=1:4)
value_dt[,dust_value:=conversion_enchantmats^(item_id-1)]
value_dt[,threshold_lower:=exp((log(shift(dust_value,type="lag",fill=0))*0.75+log(dust_value)*0.25))]
value_dt[,threshold_upper:=exp((log(shift(dust_value,type="lead",fill=Inf))*0.25+log(dust_value)*0.75))]

target_values <- CJ.dt(target,value_dt)
setorderv(target_values,"creature_id")


target_values[,lognorm:=plnorm(threshold_upper,meanlog,sdlog)-plnorm(threshold_lower,meanlog,sdlog),by=creature_id]
target_values[,lognorm_rounded:=smart.round(lognorm*100)/100,by=.(creature_id)]
target_values[,expected_actual:=sum(lognorm_rounded*dust_value),by=.(creature_id)]

target_values[,delta:=expected_actual/expected_value]


drop_base2 <- unique(target_values[,.(creature_id,delta)])[drop_base,on="creature_id"]

drop_base2[,expected_count:=expected_count/delta]

drop_dt2 <- CJ.dt(drop_base2,count_dt)

setorderv(drop_dt2,"creature_id")


drop_dt2[,drops_lower:=drops-0.5]
drop_dt2[,drops_upper:=shift(drops %>%  as.numeric,type="lead",fill=Inf)-0.5,by=.(creature_id)]

drop_dt2[,density:=pgamma(drops_upper,shape=expected_count*expected_count ,rate=expected_count )-pgamma(drops_lower,shape=expected_count*expected_count ,rate=expected_count )]
drop_dt2[,probabilities:=smart.round(density*100)/100]

drop_dt2[,drops:=as.numeric(drops)]
drop_dt2[,probabilities:=probabilities*100]
drop_dt2[,drop_prob:=lapply(transpose(.(drops,probabilities)), as.list)]

valheim_melt2 <- drop_dt2[probabilities>0,.(Drops=combineListsAsOne(drop_prob)),by=.(creature_id)]
valheim_melt2[,c("Object","Level"):=tstrsplit(creature_id,"__")]
valheim_melt2[,Level:=as.numeric(Level)+1]
valheim_melt2[,creature_id:=NULL]

target2 <- drop_dt2[,.(actual_count=sum(probabilities*drops)),by=.(magic_dust,creature_id)]

target_values[target2,on="creature_id",correct_count:=i.actual_count]
target_values[,c("Object","Level"):=tstrsplit(creature_id,"__")]
target_values[,Level:=as.numeric(Level)+1]
target_values[,lognorm_rounded:=lognorm_rounded*100]
target_values[,item_id:=paste0("Tier",item_id-1,"Mats")]
target_values[,Loot:=list(list(list("Item"=item_id %>% as.character(),"Weight"=lognorm_rounded %>%  unlist))),by=1:nrow(target_values)]

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

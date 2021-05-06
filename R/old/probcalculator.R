

count_range <- c(0.2,10)


target_base <- c31[,.(creature_id=paste0(name,"_",stars),magic_dust)] %>%  unique

target_base[,expected_count:=seq(count_range[1],count_range[2],length.out=.N)]


count_dt<- data.table(drops=0:14)

target_count <- CJ.dt(target_base,count_dt)


setorderv(target_count,"creature_id")


target_count[,drops_lower:=drops-0.5]
target_count[,drops_upper:=shift(drops %>%  as.numeric,type="lead",fill=Inf)-0.5,by=.(creature_id)]


target_count[,density:=pgamma(drops_upper,shape=expected_count*expected_count ,rate=expected_count )-pgamma(drops_lower,shape=expected_count*expected_count ,rate=expected_count )]
target_count[,probabilities:=smart.round(density*100)/100]


#rgamma(10000, shape=8, rate = 1) %>%  sd %>%  mean

target <- target_count[,.(actual_count=sum(probabilities*drops)),by=.(magic_dust,creature_id)]

target[,expected_value:=magic_dust/actual_count]

target[,sdlog:=1]
target[,meanlog:=log(expected_value)-sdlog^2/2]

value_dt <- data.table(item_id=1:4)
value_dt[,dust_value:=5^(item_id-1)]
#value_dt[,threshold_lower:=(shift(dust_value,type="lag",fill=-Inf)+dust_value)/2]
#value_dt[,threshold_upper:=(shift(dust_value,type="lead",fill=Inf)+dust_value)/2]

value_dt[,threshold_lower:=exp((log(shift(dust_value,type="lag",fill=0))*0.75+log(dust_value)*0.25))]
value_dt[,threshold_upper:=exp((log(shift(dust_value,type="lead",fill=Inf))*0.25+log(dust_value)*0.75))]


target_values <- CJ.dt(target,value_dt)
setorderv(target_values,"creature_id")

#rlnorm(10000,0.6159958,3) %>%  mean
#target_values{[]}

#target_values[,lognorm:=plnorm(shift(threshold,fill=Inf,type="lead"),meanlog,sdlog)-plnorm(threshold,meanlog,sdlog),by=creature_id]

target_values[,lognorm:=plnorm(threshold_upper,meanlog,sdlog)-plnorm(threshold_lower,meanlog,sdlog),by=creature_id]
target_values[,lognorm_rounded:=smart.round(lognorm*100)/100,by=.(creature_id)]
# target_values[,cond_exp:=exp(meanlog+sdlog^2/2)*(
#   pnorm((meanlog+sdlog^2-log(shift(threshold,type="lead",fill=Inf)))/sdlog)-
#     pnorm((meanlog+sdlog^2-log(threshold))/sdlog)
# )
# /(
#   (1-pnorm((log(shift(threshold,type="lead",fill=Inf))-meanlog)/sdlog))
#   -
#     (1-pnorm((log(threshold)-meanlog)/sdlog))
# )
# ,by=name]

#target_values[,lognorm_scaled1:=cond_exp/dust_value*lognorm]
#target_values[,lognorm_scaled2:=lognorm_scaled1/sum(lognorm_scaled1),by=.(name)]
#target_values[,.(sum(lognorm_scaled2*dust_value),max(expected_value)),by=.(name)]
#target_values[,lognorm_scaled_round:=smart.round(lognorm_scaled2*100)/100,by=.(name)]

#target_values[,sum(cond_exp*lognorm),by=.(name)]
#target_values[,sum(lognorm_scaled1*dust_value),by=.(name)]
#target_values[,sum(lognorm_scaled2*dust_value),by=.(name)]
target_values[,expected_actual:=sum(lognorm_rounded*dust_value),by=.(creature_id)]

target_values[,delta:=expected_actual/expected_value]


target_base2 <- unique(target_values[,.(creature_id,delta)])[target_base,on="creature_id"]

target_base2[,expected_count:=expected_count/delta]
target_count2 <- CJ.dt(target_base2,count_dt)

setorderv(target_count2,"creature_id")



target_count2[,drops_lower:=drops-0.5]
target_count2[,drops_upper:=shift(drops %>%  as.numeric,type="lead",fill=Inf)-0.5,by=.(creature_id)]


target_count2[,density:=pgamma(drops_upper,shape=expected_count*expected_count ,rate=expected_count )-pgamma(drops_lower,shape=expected_count*expected_count ,rate=expected_count )]
target_count2[,probabilities:=smart.round(density*100)/100]


#rgamma(10000, shape=8, rate = 1) %>%  sd %>%  mean


target2 <- target_count2[,.(actual_count=sum(probabilities*drops)),by=.(magic_dust,creature_id)]

 target_values[target2,on="creature_id",correct_count:=i.actual_count]
 target_values[creature_id %like% "Troll",sum(correct_count*lognorm_rounded*dust_value),by=.(creature_id)]
# 
 target_count2[,drops:=as.numeric(drops)]
 target_count2[,drop_prob:=lapply(transpose(.(drops,probabilities)), as.list)]
# 
 target_count2[1,drop_prob][[1]] %>%  RJSONIO::toJSON()
# 
 target_count2[creature_id %like% "Blob"] %>%  View

valheim_melt2 <- target_count2[probabilities>0,.(Drops=combineListsAsOne(drop_prob)),by=.(creature_id)]

#valheim_melt2[1,.(Drops=Drops[[1]])] %>%  RJSONIO::toJSON()

target_values[,c("Object","Level"):=tstrsplit(creature_id,"_")]
target_values[,Level:=as.numeric(Level)+1]

valheim_melt2[,c("Object","Level"):=tstrsplit(creature_id,"_")]
valheim_melt2[,Level:=as.numeric(Level)+1]
valheim_melt2[,creature_id:=NULL]
#valheim_loot5[,Loot:=list(list(list("Item"=item,"Weight"=Weight %>%  unlist,"Rarity"=Rarity %>%  unlist))),by=1:nrow(valheim_loot5)]

# 
# outcome <- list(Object=target_values[1,Object],LeveledLoot=
#                                                     list(
#                                                     list(Level=target_values[1,Level],
#                                                      Drops=valheim_melt2[1,.(Drops=Drops[[1]])] %>%  as.list %>% .[[1]],
#                                                      Loot=valheim_loot6[Object=="Blob" & Level ==1,Loot][[1]]
#                                                       ),
#                                                     list(Level=target_values[5,Level],
#                        Drops=valheim_melt2[level==2,.(Drops=Drops[[1]])] %>%  as.list %>% .[[1]],
#                        Loot=valheim_loot6[Object=="Blob" & Level ==2,Loot][[1]]
#                   )
#                   )
# )   %>%  RJSONIO::toJSON()
# 
# 
# target_values[1:4,list(list(list("Item"=item_id,"Weight"=lognorm_rounded  %>%  unlist)))][[1]]

target_values[,Loot:=list(list(list("Item"=item_id %>% as.character(),"Weight"=lognorm_rounded %>%  unlist))),by=1:nrow(target_values)]
#target_values[,Loot:=list(list("Item"=item_id %>% as.character(),"Weight"=lognorm_rounded %>%  unlist)),by=1:nrow(target_values)]
Tier0Mats

target_values[,.N,by=.(item_id)]
target_values[,item_id:=paste0("Tier",item_id,"Mats")]

valheim_loot6 <- target_values[lognorm_rounded >0,.(Loot=combineListsAsOne(Loot)),by=.(Object,Level)]

valheim_loot61 <- merge(valheim_loot6,valheim_melt2,by=c("Object","Level"))


# outcome <- list(Object=valheim_loot6[Object=="Blob",unique(Object)],LeveledLoot=
#                   list(
#                     list(Level=valheim_loot6[Object=="Blob" & Level==1,Level],
#                          Drops=valheim_loot6[Object=="Blob" & Level==1,.(Drops=Drops[[1]])] %>%  as.list %>% .[[1]],
#                          Loot=valheim_loot6[Object=="Blob" & Level ==1,Loot][[1]]
#                     ),
#                     list(
#                       Level=valheim_loot6[Object=="Blob" & Level==2,Level],
#                       Drops=valheim_loot6[Object=="Blob" & Level==2,.(Drops=Drops[[1]])] %>%  as.list %>% .[[1]],
#                       Loot=valheim_loot6[Object=="Blob" & Level ==2,Loot][[1]]
#                     )
#                   )
# )   %>%  RJSONIO::toJSON()

# valheim_loot7 <- valheim_loot61[,.(LeveledLoot=
#                    list(
#                     list(Level=valheim_loot6[,Level],
#                    Drops=valheim_loot6[,.(Drops=Drops[[1]])] %>%  as.list %>% .[[1]],
#                    Loot=valheim_loot6[,Loot][[1]]))
#                    ),by=.(Object,Level)]

valheim_loot7 <- valheim_loot61[,.(LeveledLoot=
                                    list(
                                      list(Level=Level,
                                           Drops=Drops %>%  as.list %>% .[[1]],
                                           Loot=Loot[[1]]))
),by=.(Object,Level)]

valheim_loot8 <- valheim_loot7[,.(LeveledLoot=combineListsAsOne(LeveledLoot)),by=.(Object)]

valheim_loot8[,full:=list(list(list(Object=Object,LeveledLoot=LeveledLoot[[1]])  %>%  as.list)),by=.(Object)]
valheim_loot9 <- valheim_loot8[,combineListsAsOne(full)][[1]]
roux <- valheim_loot9  %>%  RJSONIO::toJSON() 
#roux <- valheim_loot8[1,list(list(Object=Object,LeveledLoot=LeveledLoot)),by=.(Object)] %>%  RJSONIO::toJSON() 
#roux
write(roux, "output.json")

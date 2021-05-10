require("extraDistr")

creatures_to_dust <- fread("data/processed/creatures_to_dust.csv")

drop_base <- creatures_to_dust[,.(creature_id=paste0(name,"__",stars),magic_dust)] %>%  unique

drop_base[,expected_count:=0.1+(10-0.1)*sqrt(magic_dust)/drop_base[,max(sqrt(magic_dust))]]


count_dt<- data.table(drops=0:(ceiling(max(expected_drops)*1.5)))

drop_dt <- CJ.dt(drop_base,count_dt)

setorderv(drop_dt,"creature_id")


# drop_dt[,drops_lower:=drops-0.5]
# #drop_dt[drops_lower<1,drops_lower:=0]
# drop_dt[,drops_upper:=shift(drops %>%  as.numeric,type="lead",fill=Inf)-0.5,by=.(creature_id)]
# 
# drop_dt[,drops_lower:=drops]
# drop_dt[,drops_upper:=shift(drops %>%  as.numeric,type="lead",fill=Inf),by=.(creature_id)]



#Gamma distribution

var_scale <- 4
drop_dt[,density:=pdgamma(drops,shape=expected_count*expected_count*var_scale ,scale=1/(expected_count*var_scale))-pdgamma(drops-1,shape=expected_count*expected_count*var_scale ,scale=1/(expected_count*var_scale))]
drop_dt[,probabilities:=smart.round(density*100)/100]

drop_dt[,pd:=sum(probabilities*drops),by=.(creature_id)]

drop_dt[,min_drop:=min(drops[probabilities>0]),by=.(creature_id)]
drop_dt[,max_drop:=max(drops[probabilities>0]),by=.(creature_id)]
post_process <- drop_dt[pd<expected_count,creature_id] %>%  unique

drop_dt[creature_id %in% post_process & drops==min_drop,probabilities:=probabilities-0.01]
drop_dt[creature_id %in% post_process & drops==max_drop+1 & drops !=drop_dt[,max(drops)],probabilities:=probabilities+0.01]
drop_dt[creature_id %in% post_process & drops==max_drop & drops ==drop_dt[,max(drops)],probabilities:=probabilities+0.01]



drop_dt[creature_id %like% "Greyling__9"]

drop_dt[,min_drop:=min(drops[probabilities>0]),by=.(creature_id)]
drop_dt[,max_drop:=max(drops[probabilities>0]),by=.(creature_id)]
post_process <- drop_dt[pd<expected_count,creature_id] %>%  unique

drop_dt[creature_id %in% post_process & drops==min_drop,probabilities:=probabilities-0.01]
drop_dt[creature_id %in% post_process & drops==max_drop+1 & drops !=drop_dt[,max(drops)],probabilities:=probabilities+0.01]
drop_dt[creature_id %in% post_process & drops==max_drop & drops ==drop_dt[,max(drops)],probabilities:=probabilities+0.01]

drop_dt[,pd:=sum(probabilities*drops),by=.(creature_id)]


error <- drop_dt[,.(expected_count[1],pd[1]),by=.(creature_id)]

target <- drop_dt[,.(actual_count=sum(probabilities*drops)),by=.(magic_dust,creature_id)]
target[,expected_value:=magic_dust/actual_count]
target[,sdlog:=1]
target[,meanlog:=log(expected_value)-sdlog^2/2]


value_dt <- data.table(item_id=1:4)
value_dt[,dust_value:=conversion_enchantmats^(item_id-1)]
#correctly solve for threshold
value_dt[,threshold_lower:=exp((log(shift(dust_value,type="lag",fill=0))*fifelse(item_id<=2,0.75,0.25)+log(dust_value)**fifelse(item_id<=2,0.25,0.75)))]
value_dt[,threshold_upper:=shift(threshold_lower,type="lead",fill="Inf")]

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
drop_dt2[,density:=pdgamma(drops,shape=expected_count*expected_count*var_scale ,scale=1/(expected_count*var_scale))-pdgamma(drops-1,shape=expected_count*expected_count*var_scale ,scale=1/(expected_count*var_scale))]
drop_dt2[,probabilities:=smart.round(density*100)/100]

drop_dt2[,drops:=as.numeric(drops)]
drop_dt2[,probabilities:=probabilities]
drop_dt2[,drop_prob:=lapply(transpose(.(drops,probabilities)), as.list)]

valheim_melt2 <- drop_dt2[probabilities>0,.(Drops=combineListsAsOne(drop_prob)),by=.(creature_id)]
valheim_melt2[,c("Object","Level"):=tstrsplit(creature_id,"__")]
valheim_melt2[,Level:=as.numeric(Level)+1]
valheim_melt2[,creature_id:=NULL]

target2 <- drop_dt2[,.(actual_count=sum(probabilities*drops)),by=.(creature_id)]

target_values[target2,on="creature_id",correct_count:=i.actual_count]
target_values[,c("Object","Level"):=tstrsplit(creature_id,"__")]
target_values[,Level:=as.numeric(Level)+1]
target_values[,lognorm_rounded:=lognorm_rounded*100]
target_values[,item_id:=paste0("Tier",item_id-1,"Mats")]
target_values[,Loot:=list(list(list("Item"=item_id %>% as.character(),"Weight"=lognorm_rounded %>%  unlist))),by=1:nrow(target_values)]


# drop_dt[creature_id=="Greydwarf__0"]
# drop_dt2[creature_id=="Greydwarf__0"]
# target2[creature_id=="Greydwarf__0"]
#global_check
#target_values[,.(sum(correct_count*lognorm_rounded*dust_value/100)/magic_dust[1]),by=.(creature_id)][,.(mean(V1),sd(V1))]
